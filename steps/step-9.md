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
// sessionsTest.cfc
component extends="tests.resources.BaseIntegrationSpec"{

	property name="query" 		inject="provider:QueryBuilder@qb";
    property name="bcrypt" 		inject="@BCrypt";
    property name="cbAuth"      inject="authenticationService@cbauth";

	function beforeAll(){
		super.beforeAll();
		query.from( "users" )
			.insert( values = {
				username : "testuser",
				email : "testuser@tests.com",
				password : bcrypt.hashPassword( "password" )
			} );
	}

	function afterAll(){
		super.afterAll();
		query.from( "users" )
			.where( "username", "=", "testuser" )
			.delete();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "sessions Suite", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			});

			it( "can present the login screen", function(){
				var event = execute( event="sessions.new", renderResults=true );
				// expectations go here.
				expect( event.getRenderedContent() ).toInclude( "Log In" );
			});

			it( "can log in a valid user", function(){
				var event = post( route="/login", params={ username="testuser", password="password"} );
				// expectations go here.
				expect( event.getValue( "relocate_URI") ).toBe( "/" );
				expect( cbAuth.isLoggedIn() ).toBeTrue();
			});

			it( "can show an invalid message for an invalid user", function(){
				var event = post( route="/login", params={ username="testuser", password="bad"} );
				// expectations go here.
				expect( event.getValue( "relocate_URI") ).toBe( "/login" );
			});

			it( "can logout a user", function(){
				var event = delete( route="/logout" );
				// expectations go here.
				expect( cbAuth.isLoggedIn() ).toBeFalse();
				expect( event.getValue( "relocate_URI") ).toBe( "/" );
			});

		});

	}

}
```

## Router

Add the following to your existing `/config/Router.cfc` file.  Note that we won't be using the `resources()` method, as we want to add some nice routing around the login and logout.

```js
// Login Flow
route( "/login" )
    .withAction( { "POST" : "create", "GET" : "new" } )
    .toHandler( "sessions" );
// Logout
delete( "/logout" ).to( "sessions.delete" );
```

Check them out in the route visualizer!

## Event Handler

Let's start building out the code:

```js
component {

    /**
	* new
	*/
	function new( event, rc, prc ){
		event.setView( "sessions/new" );
	}

	/**
	* create
	*/
	function create( event, rc, prc ){
		try {
			auth().authenticate( rc.username ?: "", rc.password ?: "" );
			messagebox.success( "Welcome back #encodeForHTML( rc.username )#" );
            return relocate( uri = "/" );
        }
        catch ( InvalidCredentials e ) {
            messagebox.warn( e.message );
            return relocate( uri = "/login" );
        }
	}

	/**
	* delete
	*/
	function delete( event, rc, prc ){
		auth().logout();
		relocate( uri="/" );
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
	User function retrieveUserById( required id ) {
        return populator.populateFromQuery(
            new(),
            queryExecute( "SELECT * FROM `users` WHERE `id` = ?", [ arguments.id ] )
        );
    }

    User function retrieveUserByUsername( required username ) {
        return populator.populateFromQuery(
            new(),
            queryExecute( "SELECT * FROM `users` WHERE `username` = ?", [ arguments.username ] )
        );
    }

    boolean function isValidCredentials( required username, required password ) {
		var oUser = retrieveUserByUsername( arguments.username );
        if( !oUser.isLoaded() ){
            return false;
		}

        return bcrypt.checkPassword( arguments.password, oUser.getPassword() );
    }
```

## Model `User.cfc`

Now let's update the User object so it can handle the `IAuthUser` interface: https://coldbox-security.ortusbooks.com/usage/authentication-services#iauthuser

We don't have to create the `getId()` method, since we already have a property called `id` with a generated setter.  We just need the authorization methods.  We don't have any roles or permissions in our system, but let's add them as properties and initialize them as arrays and use a new ColdBox 7 feature: Delegation.

```js

```

## Login View

Update the view  `/views/sessions/new.cfm`

```html
<!-- views/sessions/new.cfm -->
<cfoutput>
    <div class="card">
        <h4 class="card-header">Log In</h4>
        <form class="form panel card-body" method="POST" action="#event.buildLink( "login" )#">
            <div class="form-group">
                <label for="username" class="control-label">Username</label>
                <input id="username" name="username" type="text" class="form-control" placeholder="Username" />
            </div>
            <div class="form-group">
                <label for="password" class="control-label">Password</label>
                <input id="password" name="password" type="password" class="form-control" placeholder="Password" />
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-primary">Log In</button>
            </div>
        </form>
    </div>
</cfoutput>
```

Hit http://127.0.0.1:42518/login in your browser. You can now see the login screen. Let's build the login action next.

## Layout NavBar

Update the main layout to show and hide the register / login / logout buttons.

```html
<ul class="navbar-nav ml-auto">
    <cfif auth().isLoggedIn()>
        <form method="POST" action="#event.buildLink( "logout" )#">
            <input type="hidden" name="_method" value="DELETE" />
            <button type="submit" class="btn btn-link nav-link">Log Out</button>
        </form>
    <cfelse>
        <a href="#event.buildLink( "registration.new" )#" class="nav-link">Register</a>
        <a href="#event.buildLink( "login" )#" class="nav-link">Log In</a>
    </cfif>
</ul>
```

Refresh the page, and you will get an error `Messages: No matching function [AUTH] found` unless you have reinited the framework.

## Test the login and logout.

Try to register and login/logout visually confirming the tests.

## Auto login user when registering

When registering, it might be nice to automatically log the user in.
Replace the `Create` function with the following code

```js
function create( event, rc, prc ) {
    prc.oUser = userService.create( populateModel( "User" ) );

    auth().login( prc.oUser );

    relocate( uri = "/" );
}
```

Now register and you will be automatically logged in.
