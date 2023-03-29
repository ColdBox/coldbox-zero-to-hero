# 11 - Securing our App

We're going to use CBSecurity to help secure our app.

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

Let's add some security contexts by leveraging : `auth().isLoggedIn()`

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

### Try It Out

The visualizer will ONLY be available once you log in.

```bash
coldbox reinit
```

Run the tests!  Did we break something?  FIX IT!

Updated `rants` integration test:

```js
/**
 * 	ColdBox Integration Test
 *
 * 	The 'appMapping' points by default to the '/root ' mapping created in  the test folder Application.cfc.  Please note that this
 * 	Application.cfc must mimic the real one in your root, including ORM  settings if needed.
 *
 *	The 'execute()' method is used to execute a ColdBox event, with the  following arguments
 *	- event : the name of the event
 *	- private : if the event is private or not
 *	- prePostExempt : if the event needs to be exempt of pre post interceptors
 *	- eventArguments : The struct of args to pass to the event
 *	- renderResults : Render back the results of the event
 *
 * You can also use the HTTP executables: get(), post(), put(), path(), delete(), request()
 **/
component extends="tests.resources.BaseIntegrationSpec" {

	// DI
	property name="qb"     inject="QueryBuilder@qb";
	property name="bcrypt" inject="@BCrypt";
	property name="auth"   inject="authenticationService@cbauth";

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
		variables.testUser     = qb.from( "users" ).first();
		variables.testPassword = "test";
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		feature( "Crud for rants", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				auth.logout();
			} );

			it( "can display all rants", function(){
				var event = get( "/rants" );
				expect( event.getPrivateValue( "aRants" ) ).toBeArray();
				expect( event.getRenderedContent() ).toInclude( "All Rants" );
			} );

			it( "can display the rants index when no rants exists", function(){
				prepareMock( getInstance( "RantsService" ) ).$( "list", [] );
				var event = get( "/rants" );

				getWireBox().clearSingletons();

				expect( event.getPrivateValue( "aRants" ) ).toBeEmpty();
				expect( event.getRenderedContent() ).toInclude( "No rants yet" );
			} );

			it( "can display the new rant form", function(){
				// Log in user
				auth.authenticate( testUser.email, testPassword );
				var event = get( "/rants/new" );
				expect( event.getRenderedContent() ).toInclude( "Start a Rant" );
			} );

			it( "can stop the display of the new rant form if you are not logged in", function(){
				var event = post( "rants/new" );
				expect( event.getValue( "relocate_event" ) ).toBe( "login" );
			} );

			it( "can stop a rant from being created from an invalid user", function(){
				expect( function(){
					var event = post( route = "rants", params = { body : "Test Rant" } );
				} ).toThrow( type = "NoUserLoggedIn" );
			} );

			it( "can create a rant from a valid user", function(){
				// Log in user
				auth.authenticate( testUser.email, testPassword );
				var event = post( route = "rants", params = { body : "Test Rant" } );
				var prc   = event.getPrivateCollection();
				expect( prc.oRant.isLoaded() ).toBeTrue();
				expect( prc.oRant.getBody() ).toBe( "Test Rant" );
				expect( event.getValue( "relocate_event" ) ).toBe( "rants" );
			} );
		} );
	}

}
```

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
