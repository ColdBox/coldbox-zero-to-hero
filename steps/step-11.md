# 11 - Securing our App

We're going to use CBSecurity and its ecosystem to help secure our app.

## Update CBSecurity Configuration

Let's update our firewall settings to match some of our actions and let's activate the security visualizer as well.

### Firewall Section

```js
// The global invalid authentication event or URI or URL to go if an invalid authentication occurs
"invalidAuthenticationEvent"  : "login",
// Default Auhtentication Action: override or redirect when a user has not logged in
"defaultAuthenticationAction" : "redirect",
// The global invalid authorization event or URI or URL to go if an invalid authorization occurs
"invalidAuthorizationEvent"   : "rants",
// Default Authorization Action: override or redirect when a user does not have enough permissions to access something
"defaultAuthorizationAction"  : "redirect",
```

### Visualizer Section

```js
/**
* --------------------------------------------------------------------------
* Security Visualizer
* --------------------------------------------------------------------------
* This is a debugging panel that when active, a developer can visualize security settings and more.
* You can use the `securityRule` to define what rule you want to use to secure the visualizer but make sure the `secured` flag is turned to true.
* You don't have to specify the `secureList` key, we will do that for you.
*/
visualizer : {
	"enabled"      : true,
	"secured"      : true,
	"securityRule" : {}
}
```

### Firewall Rules

Let's create a firewall rule to secure our app:

```js
// Firewall Rules, this can be a struct of detailed configuration
// or a simple array of inline rules
"rules" : {
    // Use regular expression matching on the rule match types
    "useRegex" : true,
    // Force SSL for all relocations
    "useSSL"   : false,
    // A collection of default name-value pairs to add to ALL rules
    // This way you can add global roles, permissions, redirects, etc
    "defaults" : {},
    // You can store all your rules in this inline array
    "inline"   : [
        {
            "whitelist"   : "",
            "securelist"  : "rants/(new|create),poops,bumps",
            "match"       : "url",
            "roles"       : "",
            "permissions" : ""
        }
    ]
}
```

### Update `views/rants/index.cfm`

Let's add some security contexts by leveraging: `auth().isLoggedIn()`

```js
<cfoutput>
<div class="container">
	<h2>All Rants</h2>

	<cfif prc.aRants.isEmpty()>
		<div class="alert alert-info">
			No rants yet, why not create some?
		</div>
		<cfif auth().isLoggedIn()>
			<a
				href="#event.buildLink( "rants.new" )#"
				class="btn btn-outline-primary">Start a Rant!</a>
		<cfelse>
			<a
				href="#event.buildLink( "registration/new" )#"
				class="btn btn-outline-success">Register</a>
			<a
				href="#event.buildLink( "login" )#"
				class="btn btn-outline-success">Log In</a>
		</cfif>
	<cfelse>

		<cfif auth().isLoggedIn()>
		<a
			href="#event.buildLink( "rants.new" )#"
			class="btn btn-primary">Start a Rant!</a>
		</cfif>

		<div class="mt-3">
			<cfloop array="#prc.aRants#" item="rant">
				<div class="card mb-3">
					<div class="card-header">
						<strong>#rant.getUser().getEmail()#</strong>
						said:
					</div>
					<div class="card-body">
						#rant.getBody()#
					</div>
					<div class="card-footer">
						<span class="badge text-bg-light">
							#dateTimeFormat( rant.getCreatedDate(), "h:nn:ss tt" )#
						on #dateFormat( rant.getCreatedDate(), "mmm d, yyyy")#
						</span>
					</div>
				</div>
			</cfloop>
		</div>
	</cfif>
</div>
</cfoutput>
```

## Cross-Site Request Forgery

Since we are in the securing our app section, let's add some `cbcsrf` goodness so we can protect our forms.  You can read more about this module here: https://forgebox.io/view/cbcsrf. The main methods we will use are:

- `csrfToken()` : To generate a token, using the default or a custom key
- `csrfVerify()` : Verify a valid token or not
- `csrf()` : To generate a hidden field (csrf) with the token
- `csrfField()` : To generate a hidden field (csrf) with the token, force new token generation and include javascript that will reload the page if the token expires
- `csrfRotate()` : To wipe and rotate the tokens for the user

Let's modify the following forms:

- [`rants/new.cfm`](../src/views/rants/new.cfm) - New rant form
- [`registration/new.cfm`](../src/views/registration/new.cfm) - New user registration form
- [`sessions/new.cfm`](../src/views/new.cfm) - User login form

We will add this to all forms:

```js
#csrf()#
```

This will produce the csrf token, just notice that this will create an input field called `csrf`.

```html
<input type="hidden" name="csrf" id="csrf" value="E1B828F8D854860AB029246A20DAA04D63282388">
```

Then we need to create the verification code in each of the form handlers:

```js
// rants.cfc
if ( !csrfVerify( rc.csrf ?: "" ) ) {
    cbMessageBox().error( "Invalid Security Token!" );
    return back( persist: "body" );
}

// registration.cfc
// Validate Token
if ( !csrfVerify( rc.csrf ?: "" ) ) {
    cbMessageBox().error( "Invalid Security Token!" );
    return back( persist: "name,email" );
}

// session.cfc
if ( !csrfVerify( rc.csrf ?: "" ) ) {
    cbMessageBox().error( "Invalid Security Token!" );
    return back();
}
```

## Tests

Run the tests!  Did we break something? Time to fix!

### Consolidate Integration Test Helpers

Since we are repeating lots of code now in our integration tests, let's refactor them to encapsulate behavior in our base integration test.

```js
/**
 * Base test bundle for our application
 *
 * @see https://coldbox.ortusbooks.com/testing/testing-coldbox-applications/integration-testing
 */
component extends="coldbox.system.testing.BaseTestCase" autowire {

	/**
	 * --------------------------------------------------------------------------
	 * Dependency Injections
	 * --------------------------------------------------------------------------
	 */
	property name="qb"     inject="QueryBuilder@qb";
	property name="auth"   inject="authenticationService@cbauth";
	property name="cbcsrf" inject="@cbcsrf";

	/**
	 * --------------------------------------------------------------------------
	 * Integration testing controls
	 * --------------------------------------------------------------------------
	 * - We want the ColdBox virtual application to load once per request and get destroyed at the end of the request.
	 */
	this.loadColdBox   = true;
	this.unloadColdBox = false;

	/**
	 * --------------------------------------------------------------------------
	 * Global Variables
	 * --------------------------------------------------------------------------
	 * - Global helper variables
	 */
	variables.testPassword = "test";

	/**
	 * Run Before all tests
	 */
	function beforeAll(){
		super.beforeAll();
	}

	/**
	 * This function is tagged as an around each handler.  All the integration tests we build
	 * will be automatically rolledbacked so we don't corrupt the database with our tests
	 *
	 * @aroundEach
	 */
	function wrapInTransaction( spec ){
		transaction action="begin" {
			try {
				arguments.spec.body( argumentCollection = arguments );
			} catch ( any e ) {
				rethrow;
			} finally {
				transaction action="rollback";
			}
		}
	}

	/**
	 * --------------------------------------------------------------------------
	 * Helper Methods
	 * --------------------------------------------------------------------------
	 */

	function csrfToken(){
		return cbcsrf.generate( argumentCollection = arguments );
	}

	struct function getTestUser(){
		return qb.from( "users" ).first();
	}

}
```

Now let's do the following:

- Remove all the `variables.testPassword` sets so it can use the base
- Remove the `variables.testUser` implementation and replace it with `getTestUser()` call
- Add to all creation forms `csrf : csrfToken()` to the `params` so the forms can be secure even in testing.

## CBSecurity Logs

If you start getting the following error in your tests:

```text
The incoming function threw exception [database] [Table 'soapbox.cbsecurity_logs' doesn't exist] [] different than expected params type=[NoUserLoggedIn], regex=[.*
```

It means that the security logs are not being created automatically by CBSecurity during testing.
So let's just create a migration for it to avoid further issues down the road.  Also, update the CBSecurity settings to false for creating the logs table.

```js
// Firewall database event logs.
"logs"                        : {
    "enabled"    : true,
    "dsn"        : "",
    "schema"     : "",
    "table"      : "cbsecurity_logs",
    "autoCreate" : false
},
```

Create the migration:

```bash
migrate create create_security_logs_table
```

Now add the following:

```js
component {

    variables.INDEX_COLUMNS = [
        "userId",
        "userAgent",
        "ip",
        "host",
        "httpMethod",
        "path",
        "referer"
    ];

	function up( schema, qb ){
		schema.create( "cbsecurity_logs", function( table ){
			table.string( "id", 36 ).primaryKey();
			table.timestamp( "logDate" ).withCurrent();
			table.string( "action" );
			table.string( "blockType" );
			table.string( "ip" );
			table.string( "host" );
			table.string( "httpMethod" );
			table.string( "path" );
			table.string( "queryString" );
			table.string( "referer" ).nullable();
			table.string( "userAgent" );
			table.string( "userId" ).nullable();
			table.longText( "securityRule" ).nullable();
			table.index( [ "logDate", "action", "blockType" ], "idx_cbsecurity" );

            INDEX_COLUMNS.each( ( key ) => {
                table.index( [ arguments.key ], "idx_cbsecurity_#arguments.key#" );
            } );

		} );
	}

	function down( schema, qb ){
		schema.drop( "cbsecurity_logs" );
	}

}
```

and run it `migrate up`
