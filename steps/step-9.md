# 9 - Login and Logout

## Make Messages Prettier

We used flash, but that's too much work.  Let's go nuts and reuse a module `cbmessagebox` which will produce Bootstrap-compliant messages.

`install cbmessagebox && coldbox reinit`

Update the flash setting code in the `create` action of the [`registration`](../src/handlers/registration.cfc) handler to this:

```js
flash.put( "notice", {
    type : "success",
    message : "The user #encodeForHTML( rc.username )# with id: #generatedKey# was created!"
} );

to this:

cbMessageBox().success( "The user #encodeForHTML( prc.oUser.getEmail() )# with id: #prc.oUser.getId()# was created!" );
```

And the display code in the [`layouts/Main.cfm`](../src/layouts/Main.cfm) to this:

```html
<cfif flash.exists( "notice" )>
    <div class="alert alert-#flash.get( "notice" ).type#">
    #flash.get( "notice" ).message#
    </div>
</cfif>
```

to this

```html
#cbMessageBox().renderit()#
```

Test it out!

## CBSecurity

To secure our application we will use `CBSecurity` which is the standard module for securing ColdBox applications.  It comes with all the facilities we need in order to build secure ColdBox applications.  Check out the docs here: https://coldbox-security.ortusbooks.com/.

With CBSecurity we will be able to do the following:

- Create security rules
- Annotate our handler actions with security contexts
- Provide CSRF protection to our forms
- Provide authentication tracking via the included `cbauth` module
- Provide authorization tracking
- Provide security headers

```bash
install cbsecurity
```

### Configure CBSecurity

Now we must configure `cbauth` and `cbsecurity`. Create a `config/modules/cbauth.cfc` and `config/modules/cbsecurity.cfc` so we can configure the modules:

```bash
touch config/modules/cbauth.cfc --open
touch config/modules/cbsecurity.cfc --open
```

#### cbauth.cfc

```js
component {

	function configure(){
		return {
			// This is the path to your user object that contains the credential validation methods
			userServiceClass : "UserService"
		};
	}

}
```

#### cbsecurity.cfc

```js
component {

	function configure(){
		return {
			/**
			 * --------------------------------------------------------------------------
			 * Authentication Services
			 * --------------------------------------------------------------------------
			 * Here you will configure which service is in charge of providing authentication for your application.
			 * By default we leverage the cbauth module which expects you to connect it to a database via your own User Service.
			 *
			 * Available authentication providers:
			 * - cbauth : Leverages your own UserService that determines authentication and user retrieval
			 * - basicAuth : Leverages basic authentication and basic in-memory user registration in our configuration
			 * - custom : Any other service that adheres to our IAuthService interface
			 */
			authentication : {
				// The WireBox ID of the authentication service to use which must adhere to the cbsecurity.interfaces.IAuthService interface.
				"provider"        : "authenticationService@cbauth",
				// The name of the variable to use to store an authenticated user in prc scope on all incoming authenticated requests
				"prcUserVariable" : "oCurrentUser"
			},
			/**
			 * --------------------------------------------------------------------------
			 * CSRF - Cross Site Request Forgery Settings
			 * --------------------------------------------------------------------------
			 * These settings configures the cbcsrf module. Look at the module configuration for more information
			 */
			csrf : {
				// By default we load up an interceptor that verifies all non-GET incoming requests against the token validations
				enableAutoVerifier     : false,
				// A list of events to exclude from csrf verification, regex allowed: e.g. stripe\..*
				verifyExcludes         : [],
				// By default, all csrf tokens have a life-span of 30 minutes. After 30 minutes, they expire and we aut-generate new ones.
				// If you do not want expiring tokens, then set this value to 0
				rotationTimeout        : 30,
				// Enable the /cbcsrf/generate endpoint to generate cbcsrf tokens for secured users.
				enableEndpoint         : false,
				// The WireBox mapping to use for the CacheStorage
				cacheStorage           : "CacheStorage@cbstorages",
				// Enable/Disable the cbAuth login/logout listener in order to rotate keys
				enableAuthTokenRotator : true
			},
			/**
			 * --------------------------------------------------------------------------
			 * Firewall Settings
			 * --------------------------------------------------------------------------
			 * The firewall is used to block/check access on incoming requests via security rules or via annotation on handler actions.
			 * Here you can configure the operation of the firewall and especially what Validator will be in charge of verifying authentication/authorization
			 * during a matched request.
			 */
			firewall : {
				// Auto load the global security firewall automatically, else you can load it a-la-carte via the `Security` interceptor
				"autoLoadFirewall"            : true,
				// The Global validator is an object that will validate the firewall rules and annotations and provide feedback on either authentication or authorization issues.
				"validator"                   : "CBAuthValidator@cbsecurity",
				// Activate handler/action based annotation security
				"handlerAnnotationSecurity"   : true,
				// The global invalid authentication event or URI or URL to go if an invalid authentication occurs
				"invalidAuthenticationEvent"  : "login",
				// Default Auhtentication Action: override or redirect when a user has not logged in
				"defaultAuthenticationAction" : "redirect",
				// The global invalid authorization event or URI or URL to go if an invalid authorization occurs
				"invalidAuthorizationEvent"   : "dashboard",
				// Default Authorization Action: override or redirect when a user does not have enough permissions to access something
				"defaultAuthorizationAction"  : "redirect",
				// Firewall database event logs.
				"logs"                        : {
					"enabled"    : true,
					"dsn"        : "",
					"schema"     : "",
					"table"      : "cbsecurity_logs",
					"autoCreate" : true
				},
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
					"inline"   : []
				}
			}
		};
	}

}
```

`cbAuth` requires us to create the following functions in our `UserService` so authentication can be done for us by implementing the `IUserService` interface: https://coldbox-security.ortusbooks.com/usage/authentication-services#iuserservice

```js
interface{

    /**
     * Verify if the incoming username/password are valid credentials.
     *
     * @username The username
     * @password The password
     */
    boolean function isValidCredentials( required username, required password );

    /**
     * Retrieve a user by username
     *
     * @return User that implements JWTSubject and/or IAuthUser
     */
    function retrieveUserByUsername( required username );

    /**
     * Retrieve a user by unique identifier
     *
     * @id The unique identifier
     *
     * @return User that implements JWTSubject and/or IAuthUser
     */
    function retrieveUserById( required id );
}
```

We also need our `User` object to adhere to the `IAuthUser` interface in CBSecurity: https://coldbox-security.ortusbooks.com/usage/authentication-services#iauthuser

```js
/**
 * Copyright since 2016 by Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * If you use a user with a user service or authentication service, it must implement this interface
 */
interface{

    /**
     * Return the unique identifier for the user
     */
    function getId();

    /**
     * Verify if the user has one or more of the passed in permissions
     *
     * @permission One or a list of permissions to check for access
     *
     */
    boolean function hasPermission( required permission );

	/**
     * Verify if the user has one or more of the passed in roles
     *
     * @role One or a list of roles to check for access
     *
     */
    boolean function hasRole( required role );

}
```

Ok, so we know that as part of our BDD process, we will satisfy the stories and implement the details as we go through. So let's start.

## BDD Time

```text
Feature: Login and Logout Users
Stories:
- It can present a login screen
- It can log in a valid user
- It can show an invalid message for an invalid user
- It can logout a user
```

Issue the following: `coldbox create handler name="sessions" actions="new,create,delete"`. This is our start so we can create the functionality for the login page, login, and logout using resourceful conventions.
Delete the unnecessary views generated:

```bash
delete views/sessions/create.cfm,views/sessions/delete.cfm
```

Now let's open our integration tests and start!

```js
/*******************************************************************************
 *	Integration Test as BDD (CF10+ or Railo 4.1 Plus)
 *
 *	Extends the integration class: coldbox.system.testing.BaseTestCase
 *
 *	so you can test your ColdBox application headlessly. The 'appMapping' points by default to
 *	the '/root' mapping created in the test folder Application.cfc.  Please note that this
 *	Application.cfc must mimic the real one in your root, including ORM settings if needed.
 *
 *	The 'execute()' method is used to execute a ColdBox event, with the following arguments
 *	* event : the name of the event
 *	* private : if the event is private or not
 *	* prePostExempt : if the event needs to be exempt of pre post interceptors
 *	* eventArguments : The struct of args to pass to the event
 *	* renderResults : Render back the results of the event
 *******************************************************************************/
component extends="tests.resources.BaseIntegrationSpec" {

	property name="query"  inject="provider:QueryBuilder@qb";
	property name="auth"   inject="authenticationService@cbauth";
	property name="bcrypt" inject="@BCrypt";

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.testUser     = query.from( "users" ).first();
		variables.testPassword = "test";
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		feature( "Login and Logout Users", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				auth.logout();
			} );

			it( "can present the login screen", function(){
				var event = get( route = "/login" );
				expect( event.getRenderedContent() ).toInclude( "SoapBox Log In" );
			} );

			it( "can log in a valid user", function(){
				var event = post( route = "/login", params = { email : testUser.email, password : testPassword } );
				expect( event.getValue( "relocate_URI" ) ).toBe( "/" );
				expect( auth.isLoggedIn() ).toBeTrue();
			} );

			it( "can show an invalid message for an invalid user", function(){
				var event = post(
					route  = "/login",
					params = { username : "testuser@tests.com", password : "bad" }
				);
				expect( event.getValue( "relocate_event" ) ).toBe( "login" );
				expect( auth.isLoggedIn() ).toBeFalse();
			} );

			it( "can logout a user", function(){
				auth.authenticate( testUser.email, testPassword );
				expect( auth.isLoggedIn() ).toBeTrue();

				var event = delete( route = "/logout" );

				expect( auth.isLoggedIn() ).toBeFalse();
				expect( event.getValue( "relocate_URI" ) ).toBe( "/" );
			} );
		} );
	}

}
```

## Router

Add the following to your existing `/config/Router.cfc` file.  Note that we won't be using the `resources()` method, as we want to add some nice routing around the login and logout.

```js
// Login Flow
GET( "/login" ).as( "login" ).to( "sessions.new" );
POST( "/login" ).to( "sessions.create" );
// Logout
delete( "/logout" ).as( "logout" ).to( "sessions.delete" );
```

Check them out in the route visualizer!

## Event Handler

Let's start building out the code:

```js
/**
 * I manage logins and logouts
 */
component {

	/**
	 * Show the login screen
	 */
	function new( event, rc, prc ){
		event.setView( "sessions/new" );
	}

	/**
	 * Login a user
	 */
	function create( event, rc, prc ){
		try {
			cbsecure().authenticate( rc.email ?: "", rc.password ?: "" );
			cbMessageBox().success( "Welcome back #encodeForHTML( rc.email )#" );
			return relocate( uri = "/" );
		} catch ( InvalidCredentials e ) {
			cbMessageBox().error( e.message );
			return relocate( "login" );
		}
	}

	/**
	 * Logout a user
	 */
	function delete( event, rc, prc ){
		cbMessageBox().success( "Bye Bye! See you soon!" );
		cbsecure().logout();
		relocate( uri = "/" );
	}

}

```

## Model: `UserService`

Update the `UserService` to match the `IUserService` https://coldbox-security.ortusbooks.com/usage/authentication-services#iuserservice.  Also note that we are to the point where we will need to do queries and **populate** objects with that data.  We already used population before via the framework super type method.  However, this method comes from WireBox's Object Populator, which you can inject anywhere in your app via the injection DSL: `wirebox:populator`.  You can find much more information about this populator here: https://wirebox.ortusbooks.com/advanced-topics/wirebox-object-populator

### Injections

```js
component {
    // To populate objects from data
    property name="populator" inject="wirebox:populator";
    // For encryption
    property name="bcrypt" inject="@BCrypt";
```

### Interface Methods

Add the new methods to the `/models/UserService.cfc`

```js
/**
 * Get a user by ID
 *
 * @id The id to retrieve
 *
 * @return The user matching the incoming id
 */
User function retrieveUserById( required id ){
    return populator.populateFromQuery(
        new (),
        queryExecute( "SELECT * FROM `users` WHERE `id` = ?", [ arguments.id ] )
    );
}

/**
 * Get a user by username, in our case we use the email as the username
 *
 * @username The required username
 *
 * @return The user matching the incoming the username
 */
User function retrieveUserByUsername( required username ){
    return populator.populateFromQuery(
        new (),
        queryExecute( "SELECT * FROM `users` WHERE `email` = ?", [ arguments.username ] )
    );
}

/**
 * Verify if the credentials are valid or not
 *
 * @username The required username
 * @password The required password
 *
 * @return Are the credentials valid or not
 */
boolean function isValidCredentials( required username, required password ){
    var oUser = retrieveUserByUsername( arguments.username );
    if ( !oUser.isLoaded() ) {
        return false;
    }

    return bcrypt.checkPassword( arguments.password, oUser.getPassword() );
}
```

## Model `User.cfc`

Now let's update the User object so it can handle the `IAuthUser` interface: https://coldbox-security.ortusbooks.com/usage/authentication-services#iauthuser

We don't have to create the `getId()` method, since we already have a property called `id` with a generated setter.  We just need the authorization methods.  We don't have any roles or permissions in our system, but let's add them as properties and initialize them as arrays and use a new ColdBox 7 feature: Delegation.

```js
/**
 * I am a user in SoapBox
 */
component accessors="true" delegates="Authorizable@cbsecurity" {

	// Properties
	property name="id"           type="numeric";
	property name="name"         type="string";
	property name="email"        type="string";
	property name="password"     type="string";
	property name="createdDate"  type="date";
	property name="modifiedDate" type="date";
	property name="roles"        type="array";
	property name="permissions"  type="array";

	/**
	 * Constructor
	 */
	User function init(){
		variables.roles       = [];
		variables.permissions = [];
		return this;
	}

	/**
	 * Verify if this is a persisted or new user
	 */
	boolean function isLoaded(){
		return ( !isNull( variables.id ) && len( variables.id ) );
	}

}
```

## Login View

Update the view  `/views/sessions/new.cfm`

```html
<cfoutput>
<div class="vh-100 d-flex justify-content-center align-items-center">
    <div class="container">
        <div class="d-flex justify-content-center">
            <div class="col-8">
                <div class="card">
                    <div class="card-header">
                        SoapBox Log In
                    </div>
                    <div class="card-body">
                        #html.startForm( action : "login" )#

                            #html.emailField(
                                name : "email",
                                class : "form-control",
                                placeholder : "email@soapbox.com",
                                groupWrapper : "div class='mb-3'",
                                label : "Email",
                                labelClass : "form-label"
                            )#

                            #html.passwordField(
                                name : "password",
                                class : "form-control",
                                groupWrapper : "div class='mb-3'",
                                label : "Password",
                                labelClass : "form-label"
                            )#

                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">Log In</button>
                            </div>
                        #html.endForm()#
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</cfoutput>

```

Hit http://127.0.0.1:42518/login in your browser. You can now see the login screen. Let's build the login action next.

## Layout NavBar

Update the main layout to show and hide the register / login / logout buttons.

```html
<div class="collapse navbar-collapse" id="navbarSupportedContent">
    <!--- Left Aligned --->
    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <!--- Logged In --->
        <cfif cbsecure().guest()>
            <li class="nav-item">
                <a
                    class="nav-link #event.urlMatches( "registration/new" ) ? 'active' : ''#"
                    href="#event.buildLink( 'registration.new' )#"
                    >
                    Register
                </a>
            </li>
            <li class="nav-item">
                <a
                    class="nav-link #event.routeIs( "login" ) ? 'active' : ''#"
                    href="#event.route( 'login' )#"
                    >
                    Log in
                </a>
            </li>
        <cfelse>
            <li class="nav-item me-2">
                <a
                    class="nav-link #event.getCurrentEvent() eq 'rants.index' ? 'active' : ''#"
                    href="#event.buildLink( 'rants' )#"
                    >
                    Rants
                </a>
            </li>
        </cfif>

        <li class="nav-item me-2">
            <a
                class="nav-link #event.routeIs( "about" ) ? 'active' : ''#"
                href="#event.buildLink( 'about' )#"
                >
                About
            </a>
        </li>
    </ul>

    <!--- Right Aligned --->
    <div class="ms-auto d-flex">
        <cfif cbsecure().isLoggedIn()>
            <form method="POST" action="#event.buildLink( "logout" )#">
                <input type="hidden" name="_method" value="DELETE" />
                <button class="btn btn-outline-success" type="submit">Log Out</button>
            </form>
        </cfif>
    </div>
</div>
```

Refresh the page, and you will get an error `Messages: No matching function [AUTH] found` unless you have reinited the framework.

## Test the login and logout

Try to register and login/logout visually confirming the tests.

## Auto login user when registering

When registering, it might be nice to automatically log the user in.
Replace the `Create` function with the following code

```js
function create( event, rc, prc ) {
    prc.oUser = userService.create( populateModel( "User" ) );

    auth().login( prc.oUser );

    cbMessageBox().success( "The user #encodeForHTML( prc.oUser.getEmail() )# with id: #prc.oUser.getId()# was created!" );

	relocate( URI: "/" );
}
```

Now register and you will be automatically logged in.
