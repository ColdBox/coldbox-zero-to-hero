# 8 - User Registration

Let's build our user registration system.  For this, let's review our user acceptance criteria stories:

```html
- I want to be able to display the new user registration form
- I want to be able to register users in the system
```

So what would we need to complete these stories, make an inventory:

- [ ] A `User` object to model our user.  We already created a migration for it.
- [ ] Update our `UserService` so we can retrieve new users (`new()`) and save new users (`create()`)
- [ ] A handler and routing to control the display of our new registration form and the saving of such form.
- [ ] Hmm, since we are storing users now, we don't want to store passwords in plain text, so I guess we need to update our story to showcase storing secure passwords.

```html
- I want to be able to display the new user registration form
- I want to be able to register users in the system securely using bcrypt
```

## Install [BCyrpt](https://github.com/coldbox-modules/cbox-bcrypt)

Let's instally `bcrypt` since it's already a nice ColdBox module:

```bash
install bcrypt
```

> You can configure this module to do many work factors or custom salts. Read the readme for much more information on how to configure this module: https://github.com/coldbox-modules/bcrypt#bcrypt-settings

Now we have access to a `@BCrypt` model which has some [methods](https://github.com/coldbox-modules/bcrypt#bcrypt-mixins) we can use:

```js
/**
 * Hashes an incoming input string according to work factor and salt
 *
 * @password The input password to encrypt
 * @workFactor Optional work factor
 *
 * @return The bcrypted password
 */
string function bcryptHash(
	required string password,
	workFactor,
	salt
)

/**
 * Check if the incoming candidate is the same as a bcrypthash, usually the best check for comparing them.
 *
 * @candidate The plain text string to compare against the encrypted hash
 * @bCryptHash The bCrypt hash to compare it to
 *
 * @return True - if the match, false if they dont!
 */
boolean function bcryptCheck( required string candidate, required string bCryptHash )
```

Now that we have our module installed, let's continue.

## User Model

Let's create our `User` object:

```bash
coldbox create model name="User" properties="id,email,password,createdDate,modifiedDate"
```

This will create the `models/User.cfc` but also the unit test.  Open them both and let's add some compile validations and some nice helpers:

### `User.cfc`

```js
/**
 * I am a user in SoapBox
 */
component accessors="true" {

	// Properties
	property name="id"           type="numeric";
    property name="name"         type="string";
	property name="email"        type="string";
	property name="password"     type="string";
	property name="createdDate"  type="date";
	property name="modifiedDate" type="date";

	/**
	 * Constructor
	 */
	User function init(){
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

### `UserTest.cfc`

```js
describe( "User Suite", function(){
    it( "can be created", function(){
        expect( model ).toBeComponent();
    } );

    it( "can check if it's a new user", function(){
        expect( model.isLoaded() ).toBeFalse();
    } );

    it( "can check if it's a persisted user", function(){
        expect( model.setId( 1 ).isLoaded() ).toBeTrue();
    } );
} );
```

This is good enough for now, it validates that a user can be created and it can check if the `isLoaded()` works.

## User Service

In this step, we will NOT be doing any unit tests.  Why? Well, we will focus on the stories above.  The stories don't really care how it is implemented as long as it is implemented.  This approach remember is called BDD (Behavior Driven Development), we focus on what a system should do and not on how it does it.  We will test the entire flow via our integration tests.

So what would we need for registration:

- A way to build `User` objects
- A way to store a `User` object

### Injection

```js
// Properties
property name="bcrypt" inject="@BCrypt";
```

### New User

We will use a WireBox feature called virtual method providers.  It's really just a shortcut to calling `getInstance( "User" )` to produce `User` objects (https://wirebox.ortusbooks.com/advanced-topics/providers/virtual-provider-lookup-methods) so we don't have to type much:

```js
/**
 * Create a new empty User
 */
User function new() provider="User"{}
```

This will tell WireBox to provide `User` objects whenever the `new()` method is called.

### Create User

Now we need to create the user using a secure password:

```js
/**
 * Create a new user
 *
 * @user The user to persist
 *
 * @returns The persisted user
 */
User function create( required user ){
    // Store timestamps
    var now = now();
    arguments.user
        .setModifiedDate( now )
        .setCreatedDate( now )
    // Persist: You can use positional or named arguments
    queryExecute(
        "
            INSERT INTO `users` (`name`, `email`, `password`, `createdDate`, `modifiedDate`)
            VALUES (?, ?, ?, ?, ?)
        ",
        [
            arguments.user.getName(),
            arguments.user.getEmail(),
            bcrypt.hashPassword( arguments.user.getPassword() ),
            { value : arguments.user.getCreatedDate(), type : "timestamp" },
            { value : arguments.user.getModifiedDate(), type : "timestamp" }
        ],
        { result = "local.result" }
    );
    // Seed id and return
    return arguments.user.setId( result.generatedKey );
}
```

Go verify the tests, let's see if we broke something.  Remember we are NOT building unit tests for these.

> Question: Do you need to do the timestamps?

We have completed our models, let's move on to our resourceful events and views.

## Resourceful Event Handlers

For the majority of our handler concerns we will use the standard called resourceful routes (https://coldbox.ortusbooks.com/the-basics/routing/routing-dsl/resourceful-routes).  This is a standard that exists in many MVC freameworks in many languages.  It allows a framework to keep routing, controllers and actions very consistent.

Resourceful routes are convention based to help you create routing with less boilerplate.  You declare your resources in your routers and ColdBox will take care of creating the routes for you.  In your router you can use the `resources()` or the `apiResources()` methods.  Let's check out what a simple router call can do:

```js
resources( "photos" );
```

### Created Routes

| HTTP Verb | Route                 | Event             |
|-----------|-----------------------|-------------------|
| GET       | `/photos`             | `photos.index`    |
| GET       | `/photos/new`         | `photos.new`      |
| POST      | `/photos`             | `photos.create`   |
| GET       | `/photos/:id`         | `photos.show`     |
| GET       | `/photos/:id/edit`    | `photos.edit`     |
| PUT/PATCH | `/photos/:id`         | `photos.update`   |
| DELETE    | `/photos/:id`         | `photos.delete`   |

This convention allows us to make very similar structures which can be easily grasped by anybody new to an MVC framework.

### Registration Resource

Let's create our registration flow.  We won't use all of the resourceful actions, so we can use the `actions` argument to select which ones we want.

```bash
coldbox create handler name="registration" actions="new,create"
```

- The `create` action does not have a view, so let's clean that up: `delete views/registration/create.cfm`
- Update the [`/config/Router.cfc`](../src/config/Router.cfc) file - insert a resources definition:

```js
resources( resource : "registration", only : "new,create" );
```

When working with routes it is essential to visualize them as they can become very complex.  We have just the module for that. Go to your shell and install our awesome route visualizer: `install route-visualizer --saveDev`.  Now issue a reinit: `coldbox reinit` and refresh your browser.  You can navigate to: http://localhost:42518/route-visualizer and see all your wonderful routes.

### BDD

Ok, we have generated our controller and added our routing.  Let's now begin to satisfy two stories:

```html
- I want to be able to display the new user registration form
- I want to be able to register users in the system securely using bcrypt
```

- Those look great, but also remember that stories can have multiple scenarios.  Can you think of some scenarios?
- Open [`tests/specs/integration/RegistrationTest.cfc`](../src/tests/specs/integration/RegistrationTest.cfc) and modify it accordingly:
  - Update the `extends` to match our base test case
  - Create our stories and the happy path
  - Create any scenarios you can think of

> Remember to create our test watcher for this test : `testbox watch bundles="tests.specs.integration.RegistrationTest" recurse=false`

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
				expect( event.getRenderedContent() ).toInclude( "SoapBox Registration" );
			});

			story( "I want to register users", function(){

				given( "valid data", function(){
					then( "I should register a new user", function() {
						expect(
							queryExecute(
								"select * from users where email = :email",
								{ email : "testadmin@soapbox.com" }
							)
						).toBeEmpty();

						var event = POST(
							"/registration",
							{
								name                 : "BDD Test",
								email                : "testadmin@soapbox.com",
								password             : "password",
								passwordConfirmation : "password"
							}
						);
						var prc = event.getPrivateCollection();

						// expectations go here.
						expect( event.getValue( "relocate_URI" ) ).toBe( "/" );
						expect( prc.oUser.getEmail() ).toBe( "testadmin@soapbox.com" );
						expect( prc.oUser.isLoaded() ).toBeTrue();
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

			} );


		});

	}

}
```

Run the tests, fail!!! Now let's move to solve the failures.

### Event Handler `new()` Action

Revise the actions in the Registration Handler [`handlers/registration.cfc`](../src/handlers/registration.cfc)

```js
/**
 * User registration handler
 */
component {

	/**
	 * Show registration screen
	 */
	function new( event, rc, prc ){
		event.setView( "registration/new" );
	}

	/**
	 * Register a new user
	 */
	function create( event, rc, prc ){
	}

}
```

### Update the `new` View

Add the following into the registration form [`views/registration/new.cfm`](../src/views/registration/new.cfm)

```html
<cfoutput>
<div class="vh-100 d-flex justify-content-center align-items-center">
	<div class="container">
		<div class="d-flex justify-content-center">
			<div class="col-8">
				<div class="card">
					<div class="card-header">
						SoapBox Registration
					</div>
					<div class="card-body">
						#html.startForm( action : "registration" )#

                            #html.inputField(
								name : "name",
								class : "form-control",
								placeholder : "Robert Box",
								groupWrapper : "div class='mb-3'",
								label : "Full Name",
								labelClass : "form-label"
							)#

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

							#html.passwordField(
								name : "confirmPassword",
								class : "form-control",
								groupWrapper : "div class='mb-3'",
								label : "Confirm Password",
								labelClass : "form-label"
							)#

							<div class="form-group">
								<button type="submit" class="btn btn-primary">Register</button>
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

Hit http://127.0.0.1:42518/registration/new

Now you will see the form.

### NavBar Updates

Add a register link to the `navigation` partial for our registration page

```html
<div class="collapse navbar-collapse" id="navbarSupportedContent">
    <!--- Left Aligned --->
    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
            <a
                class="nav-link #event.urlMatches( "registration/new" ) ? 'active' : ''#"
                href="#event.buildLink( 'registration.new' )#"
                >
                Register
            </a>
        </li>
    </ul>

    <!--- Right Aligned --->
    <div class="ms-auto d-flex">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <li class="nav-item">
                <a
                    class="nav-link #event.routeIs( "about" ) ? 'active' : ''#"
                    href="#event.buildLink( 'about' )#"
                    >
                    About
                </a>
            </li>
        </ul>
    </div>
</div>
```

Refresh your page, click Register and fill out the form. Submit the form and you will see an error
`Messages: The event: Registration.create is not a valid registered event.`

Next we'll create the saving action. Which is what our test was written for.

### Event Handler `create()` action

We need to inject the `UserService` into the handler.

```js
// DI
property name="userService" inject;
```

Before we code, let's pseudo code it:

```js
- Get a new user object
- Populate it with the form data
- Send it to the service to be created
- Have a message that the can show the creation
- Relocate
```

Let's introduce another framework super type method: `populate()`.  This framework method is super handy. It allows for the framework to populate objects with form/request data as long as the keys in the incoming `rc` (request collection) match the names of the properties in the target object.  It can even build ORM relationships for you.  Here is the signature of this magical method:

```js
/**
 * Populate an object from the incoming request collection
 *
 * @model                The name of the model to get and populate or the acutal model object. If you already have an instance of a model, then use the populateBean() method
 * @scope                Use scope injection instead of setters population. Ex: scope=variables.instance.
 * @trustedSetter        If set to true, the setter method will be called even if it does not exist in the object
 * @include              A list of keys to include in the population
 * @exclude              A list of keys to exclude in the population
 * @ignoreEmpty          Ignore empty values on populations, great for ORM population
 * @nullEmptyInclude     A list of keys to NULL when empty
 * @nullEmptyExclude     A list of keys to NOT NULL when empty
 * @composeRelationships Automatically attempt to compose relationships from memento
 * @memento              A structure to populate the model, if not passed it defaults to the request collection
 * @jsonstring           If you pass a json string, we will populate your model with it
 * @xml                  If you pass an xml string, we will populate your model with it
 * @qry                  If you pass a query, we will populate your model with it
 * @rowNumber            The row of the qry parameter to populate your model with
 * @ignoreTargetLists    If this is true, then the populator will ignore the target's population include/exclude metadata lists. By default this is false.
 *
 * @return The instance populated
 */
function populate(
    required model,
    scope                        = "",
    boolean trustedSetter        = false,
    include                      = "",
    exclude                      = "",
    boolean ignoreEmpty          = false,
    nullEmptyInclude             = "",
    nullEmptyExclude             = "",
    boolean composeRelationships = false,
    struct memento               = getRequestCollection(),
    string jsonstring,
    string xml,
    query qry,
    boolean ignoreTargetLists = false
)
```

> Please note that you can populate objects from the request collection, custom structs, XML, queries and even JSON data.

Ok, let's try it now:

```js
/**
 * Register a new user
 */
function create( event, rc, prc ){
    prc.oUser = userService.create( populateModel( "User" ) );

    flash.put(
        "notice",
        {
            type    : "success",
            message : "The user #encodeForHTML( prc.oUser.getEmail() )# with id: #prc.oUser.getId()# was created!"
        }
    );

    relocate( "/" );
}
```

Look at that, very clean.  The `populateModel()` even accepts a WireBox ID, so it will even create the `User` object for you.  However, what's also new?  The `flash` scope right?

The purpose of the Flash RAM is to allow variables to be persisted seamlessly from one request and be picked up in a subsequent request(s) by the same user. This allows you to hide implementation variables and create web flows or conversations in your ColdBox applications. So why not just use session or client variables? Well, most developers forget to clean them up and sometimes they just end up overtaking huge amounts of RAM and no clean cut definition is found for them. With Flash RAM, you have the facility already provided to you in an abstract and encapsulated format. This way, if you need to change your flows storage scope from session to client scope, the change is seamless and painless.

> More info here: https://coldbox.ortusbooks.com/digging-deeper/flash-ram

### Update Layout With Flash

What is new to you here? Flash scope baby! Let's open the `layouts/Main.cfm` and create the visualization of our flash messages:

```html
<cfif flash.exists( "notice" )>
	<div class="alert alert-#flash.get( "notice" ).type#" role="alert">
        #flash.get( "notice" ).message#
    </div>
</cfif>
```

Let's do a reinit and test again: `coldbox reinit`

### Verify Registration

Hit the url: http://127.0.0.1:42518//registration/new and add a new user.

If you didn't reinit the framework, you will see the following error `Messages: variable [BCRYPT] doesn't exist` Dependency Injection changes require a framework init.

Now hit the url with frame reinit: http://127.0.0.1:42518//registration/new?fwreinit=1

Add a new user, and see that the password is now encrypted. Bcrypt encrypted passwords look like the following:

`$2a$12$/w/nkNrV6W6qqZBNXdqb4OciGWNNS7PCv1psej5WTDiCs904Psa8S`

Check your tests, they should all pass again.

## Final Steps

**SELF DIRECTED**

We did not validate, naughty naughty naughty!  This is really important and we completely forgot.  This is going to be a self directed excercise:

- Uncomment the stories in the BDD test so we can test different validation scenarios
- Install `cbvalidation` https://coldbox-validation.ortusbooks.com/overview/installation
- Add constraints to the `User.cfc` https://coldbox-validation.ortusbooks.com/overview/declaring-constraints/domain-object
- Update the `registration` handler to validate the user once popualed: https://coldbox-validation.ortusbooks.com/overview/validating-constraints
- Update the `new.cfm` view to showcase the errors if any: https://coldbox-validation.ortusbooks.com/overview/displaying-errors
