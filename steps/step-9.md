## 9 - Build the Login & Logout Flow

### Make Messages Prettier

We used flash, but that's too much work, lets go nuts and reuse a module `cbmessagebox` which will produce Bootstrap compliant messages.

`install cbmessagebox && coldbox reinit`

Update the flash setting code in the `create` action of the `registration` handler to this:

```js
flash.put( "notice", {
    type : "success",
    message : "The user #encodeForHTML( rc.username )# with id: #generatedKey# was created!"
} );

to this:

getInstance( "messageBox@cbmessagebox" )
    .success( "The user #encodeForHTML( rc.username )# with id: #generatedKey# was created!" );
```

And the display code in the `layouts/Main.cfm` to this:

```html
<cfif flash.exists( "notice" )>
    <div class="alert alert-#flash.get( "notice" ).type#">
    #flash.get( "notice" ).message#
    </div>
</cfif>
```

to this

```html
#getInstance( "messagebox@cbMessageBox" ).renderit()#
```

### Security using cbSecurity and cbAuth

Install cbSecurity which includes cbAuth.  We will use the modules to provide security to our app and also authentication services.

`install cbsecurity`

- https://www.forgebox.io/view/cbauth
- https://www.forgebox.io/view/cbsecurity

Then you need to configure the module in the `moduleSettings` Setting struct in the `/config/Coldbox.cfc` file.  Look at the cbSecurity and cbAuth docs for the settings.

```js
moduleSettings = {
    "cbauth" : {
        "userServiceClass" : "UserService"
    }
};
```

And cbAuth requires us to create the following functions so authentication can occur for us:

```js
function isValidCredentials( username, password )
function retrieveUserByUsername( username )
function retrieveUserById( id )
```

Additionally, the `User` component returned by the retrieve methods needs to respond to `getId()`. WOW! We have no `User` class yet, so I guess we will also have to model it.  Ok, now it's time for some BDD modeling:

### BDD Time!

Issue the following: `coldbox create handler name="sessions" actions="new,create,delete"`. This is our start so we can create the functionality for login page, do login, and logout.  We will again start with our BDD tests:

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

### Router

Add the following into your existing `/config/Router.cfc` file

```js
// config/Router.cfc
function configure(){
    setFullRewrites( true );
    resources("registration");

    route( "/login" )
        .withAction( { "POST" = "create", "GET" = "new" } )
        .toHandler( "sessions" );

    delete( "/logout" ).to( "sessions.delete" );

	route( ":handler/:action?" ).end();
}
```

Check them out in the route visualizer!

### Event Handler

Let's start building out the code:

```js
// handlers/Sessions.cfc
component {

    // DI
    property name="messagebox" 		inject="MessageBox@cbmessagebox";
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

### Model: `User`

Create a new Model `coldbox create model name="User" properties="id,username,email,password"`

```js
/**
* I am a new Model Object
*/
component accessors="true"{

	// Properties
	property name="id" type="string";
	property name="username" type="string";
	property name="email" type="string";
	property name="password" type="string";

	/**
	 * Constructor
	 */
	User function init(){

		return this;
    }

    boolean function isLoaded(){
		return ( !isNull( variables.id ) && len( variables.id ) );
	}

}
```

### Model: `UserService`

We need to update our User Service for CBAuth to function. It requires 3 functions and 1 for good luck:

**Explain `wirebox.getInstance` and `populator`**

Inject the new wirebox items into `/models/UserService.cfc`

```js
component {

    // To populate objects from data
    property name="populator" inject="wirebox:populator";
    // For encryption
    property name="bcrypt" inject="@BCrypt";
```

Add the new methods to the `/models/UserService.cfc`

```js
   // What is this FUNKYNESS!!!
    User function new() provider="User";

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

### Login View

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



### Layout NavBar

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



### Registration Refactoring

Refactor the Registration to use the User Object, we have gone OOP

#### Update UserService `create` function to use User object

```js
function create( required user ){
    queryExecute(
        "
            INSERT INTO `users` (`email`, `username`, `password`)
            VALUES (?, ?, ?)
        ",
        [
            user.getEmail(),
            user.getUsername(),
            bcrypt.hashPassword( user.getPassword() )
        ],
        { result = "local.result" }
    );
    user.setId( result.generatedKey );
    return user;
}
```

#### Update Registration.cfc handler to use User Object

Replace the Create function with the following

```js
// create / save User
function create( event, rc, prc ) {
    var user = populateModel( getInstance( "User" ) );
    userService.create( user );
    relocate( uri = "/login" );
}
```

Also note that your tests don't change. Run Them!

**References**
* [`populateModel`](https://coldbox.ortusbooks.com/full/models/super_type_usage_methods#populatemodel())
* [`relocate`](https://coldbox.ortusbooks.com/full/event_handlers/relocating)

#### Let's make the user listing friendly

Let's update our dump to just a simple listing in order to try out the HTML Helper and make it pretty:

Open the `main/index.cfm` and remove the dump and use the following instead:

```html
<cfoutput>
<h1>System Users</h1>
#html.table(
    data = prc.userList,
    class = "table table-hover table-striped"
)#
</cfoutput>
```

### Test the login and logout.

Try to register and login/logout visually confirming the tests.

### Auto login user when registering

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
