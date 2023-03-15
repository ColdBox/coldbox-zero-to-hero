## 8 - Building the Registration Flow

Let's begin by creating the registration flow by generating our `registration` handler:

```bash
coldbox create handler name="registration" actions="new,create"
```

The `create` action does not have a view, so let's clean that up: `delete views/registration/create.cfm`

### BDD

Open `tests/specs/integration/RegistrationTest.cfc` and modify

```js
component extends="tests.resources.BaseIntegrationSpec"{

	property name="query" inject="provider:QueryBuilder@qb";

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Registration Suite", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			});

			it( "can show the user registration form", function(){
				var event = get( route="registration.new", params={} );
				// expectations go here.
				expect( false ).toBeTrue();
            });

            it( "can register a user", function(){
				var event = post( route="registration", params={} );
				// expectations go here.
				expect( false ).toBeTrue();
			});


		});

	}

}
```

Hit the url: http://127.0.0.1:42518/tests/runner.cfm to run your tests. The test will run and fail as expected. As we use BDD we will write the real specs:

```js

component extends="tests.resources.BaseIntegrationSpec"{

	/*********************************** BDD SUITES ***********************************/

	function run(){

		feature( "User Registrations", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			});

			it( "should present a new registration screen", function(){
				var event = GET( "registration/new" );
				// expectations go here.
				expect( event.getRenderedContent() ).toInclude( "Register for SoapBox" );
			});

			story( "I want to register users", function(){

				given( "valid data", function(){
					then( "I should register a new user", function() {
						expect(
							queryExecute(
								"select * from users where username = :username",
								{ username : "testadmin" },
								{ returntype = "array" }
							)
						).toBeEmpty();

						var event = POST( "/registration", {
							username : "testadmin",
							email : "testadmin@test.com",
							password : "password",
							passwordConfirmation : "password"
						} );

						// expectations go here.
						expect( event.getValue( "relocate_URI" ) ).toBe( "/" );

						expect(
							queryExecute(
								"select * from users where username = :username",
								{ username : "testadmin" },
								{ returntype = "array" }
							)
						).notToBeEmpty();
					})
				});

				xgiven( "invalid registration data", function(){
					then( "I should show a validation error", function() {
						fail( "implement" );
					})
				});

				xgiven( "a non-unique email", function(){
					then( "I should show a validation error", function() {
						fail( "implement" );
					})
				});

				xgiven( "a non-unique username", function(){
					then( "I should show a validation error", function() {
						fail( "implement" );
					})
				});

			} );


		});

	}

}
```

Now let's move to implementation.

### Resourceful Routes

**SHOW RESOURCES ROUTING TABLE. EXPLAIN WHY RESOURCES.**
https://coldbox.ortusbooks.com/the-basics/routing/routing-dsl/resourceful-routes

Update the `/config/Router.cfc` file - insert a resources definition.

```js
// config/Router.cfc
function configure(){
    setFullRewrites( true );

    resources( "registration" );

    route( ":handler/:action?" ).end();
}
```

When working with routes it is essential to visualize them as they can become very complex.  We have just the module for that. Go to your shell and install our awesome route visualizer: `install route-visualizer --saveDev`.  Now issue a reinit: `coldbox reinit` and refresh your browser.  You can navigate to: http://localhost:42518/route-visualizer and see all your wonderful routes.

### Event Handler - new() action

Revise the actions in the Registration Handler `handlers/registration.cfc`

```js
function new( event, rc, prc ) {
    event.setView( "registration/new" );
}

function create( event, rc, prc ) {
    event.setView( "registration/create" ); // REMOVE THIS
}
```


### Update the `new` view

Add the following into a new file `views/registration/new.cfm`

```html
<!-- views/registration/new.cfm -->
<cfoutput>
    <div class="card">
        <h4 class="card-header">Register for SoapBox</h4>
        <form class="form panel card-body" method="POST" action="#event.buildLink( "registration" )#">
            <div class="form-group">
                <label for="email" class="control-label">Email</label>
                <input id="email" name="email" type="email" class="form-control" placeholder="Email" />
            </div>
            <div class="form-group">
                <label for="username" class="control-label">Username</label>
                <input id="username" name="username" type="text" class="form-control" placeholder="Username" />
            </div>
            <div class="form-group">
                <label for="password" class="control-label">Password</label>
                <input id="password" name="password" type="password" class="form-control" placeholder="Password" />
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-primary">Register</button>
            </div>
        </form>
    </div>
</cfoutput>
```

Hit http://127.0.0.1:42518/registration/new

Now you will see the form.

### NavBar Updates

Add a register link to the navbar for our registration page

```html
<div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav ml-auto">
        <a href="#event.buildLink( "registration.new" )#" class="nav-link">Register</a>
    </ul>
</div>
```

The Nav bar is located in our Layout file `/layouts/Main.cfm`. Insert the code above, into the `<nav>` tag, before the closing `</nav>` .

Refresh your page, click Register and fill out the form. Submit the form and you will see an error
`Messages: The event: Registration.create is not a valid registered event.`

Next we'll create the saving action. Which is what our test was written for.

### Event Handler - create() action

```js
function create( event, rc, prc ) {
    //insert the user

    relocate( uri = "/" );
}
```

We need to inject the `UserService` into the handler. Add the following code to the top of the Registration.cfc handler.

```js
//handlers/Registration.cfc
property name="userService"		inject="UserService";
```

Remove `//insert the user` and replace with

```js
var generatedKey = userService.create( rc.email, rc.username, rc.password );
flash.put( "notice", {
    type : "success",
    message : "The user #encodeForHTML( rc.username )# with id: #generatedKey# was created!"
} );
```
#### Update Layout With Flash

What is new to you here? Flash scope baby! Let's open the `layouts/Main.cfm` and create the visualization of our flash messages:

```html
<cfif flash.exists( "notice" )>
    <div class="alert alert-#flash.get( "notice" ).type#">
    #flash.get( "notice" ).message#
    </div>
</cfif>
```

### Model Updates

Do not ever use a password that is un-encrypted, it is not secure, so lets use `BCrypt`. On ForgeBox, there is a module for that and easily installable with CommandBox.

#### Add [BCyrpt](https://github.com/coldbox-modules/cbox-bcrypt)

```sh
install bcrypt
```

Update the `UserService` to use BCrypt `/models/UserService.cfc`
We are adding the DI Injection for the BCrypt Module.

```js
component singleton accessors="true"{

	// Properties
	property name="bcrypt" inject="@BCrypt";
```

#### Let's create the `create` method in the UserService

Create the `create` function, that has 3 arguments, and write the query, including wrapping the password in a call to bcrypt to encrypt the password.

```js
/**
 * Create a new user
 *
 * @email
 * @username
 * @password
 *
 * @return The created id of the user
 */
numeric function create(
    required string email,
    required string username,
    required string password
){
    queryExecute(
        "
            INSERT INTO `users` ( `email`, `username`, `password` )
            VALUES ( ?, ?, ? )
        ",
        [
            arguments.email,
            arguments.username,
            bcrypt.hashPassword( arguments.password )
        ],
        {
            result : 'local.result'
        }
    );

    return local.result.generatedkey;
}
```

#### Verify Registration

Hit the url: http://127.0.0.1:42518//registration/new and add a new user.

If you didn't reinit the framework, you will see the following error `Messages: variable [BCRYPT] doesn't exist` Dependency Injection changes require a framework init.

Now hit the url with frame reinit: http://127.0.0.1:42518//registration/new?fwreinit=1

Add a new user, and see that the password is now encrypted. Bcrypt encrypted passwords look like the following:

`$2a$12$/w/nkNrV6W6qqZBNXdqb4OciGWNNS7PCv1psej5WTDiCs904Psa8S`

Check your tests, they should all pass again.

### Complete the steps and Register yourself

**SELF DIRECTED** (20 minutes)

What happens if you run the tests again? Where is your user?
