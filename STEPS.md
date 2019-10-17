# Steps to go from ColdBox Zero to Hero

(All commands assume we are in the `box` shell unless stated otherwise.)

## 1 - Create the base app

### Create a folder for your app on your hard drive called `soapbox`

### Scaffold out a new Coldbox application with TestBox included

```sh
coldbox create app soapbox
```
`

### Start up a local server

```sh
start port=42518
```

### Open `http://localhost:42518/` in your browser. You should see the default ColdBox app template

### Open `/tests` in your browser. You should see the TestBox test browser

This is useful to find a specific test or group of tests to run _before_ running them.

### Open `/tests/runner.cfm` in your browser. You should see the TestBox test runner for our project

This is running all of our tests by default. We can create our own test runners as needed.

All your tests should be passing at this point. 😉

### Let's run the Tests via CommandBox

```sh
testbox run "http://localhost:42518/tests/runner.cfm"
```

### Lets add this url to our server.json

We can set the testbox runner into our server.json, and then we can easily run the tests at a later stage without having to type out the whole url. To do so, we use the `package set` command.

```sh
package set testbox.runner="http://localhost:42518/tests/runner.cfm"
testbox run
```

### Use CommandBox Test Watchers

CommandBox now supports Test Watchers. This allows you to automatically run your tests run as you make changes to tests or cfcs. You can start CommandBox Test watchers with the following command

```sh
testbox watch
```

You can also control what files to watch.

```sh
testbox watch **.cfc
```

`ctl-c` will escape and stop the watching.

## 2 - Intro to ColdBox MVC

### Development Settings

* Configure the `configure()` method for production
* Verify the `environment` structures
* Add the `development()` method settings

```js
function development(){
    coldbox.customErrorTemplate = "/coldbox/system/includes/BugReport.cfm";
    coldbox.handlersIndexAutoreload = true;
    coldbox.reinitPassword = "";
    coldbox.handlerCaching = false;
    coldbox.viewCaching = false;
    coldbox.eventCaching = false;
}
```

* Open the `layouts/Main.cfm` and add a tag for the environment

```html
<div class="badge badge-info">
    #getSetting( "environment" )#
</div>
```

* Where does the `getSetting()` method come from?
* Go back again to the UML Diagram of Major Classes (https://coldbox.ortusbooks.com/the-basics/models/super-type-usage-methods)
* Reinit the framework 

> http://localhost:42518?fwreinit=1

* What is cached?
* Singletons
* Handlers
* View/Event Caching

```bash
coldbox reinit
```

* Change the environments, test the label


### Show routes file. Explain routing by convention.

### Explain `event`, `rc`, and `prc`.

### Show `Main.index`.

### Explain views. Point out view conventions.

### Briefly touch on layouts.

### Show how `rc` and `prc` are used in the views.

### Add an about page

```bash
coldbox create view about/index
```

#### Add an `views/about/index.cfm`. Hit the url `/about/index` and it works!

```html
<cfoutput>
    <h1>About us!</h1>
</cfoutput>
```
#### Add an `about` handler, change to non-existent view, does it work?

```bash
coldbox create handler name="about" actions="index" views=false
```

#### Set it back to the `index` view, does it work?

#### Execute the tests, we have more tests now

* Explain Integration Testing, BDD Specs, Expectations
* Fix the tests

```js
it( "can render the about page", function(){
    //var event = execute( event="about.index", renderResults=true );
    //var event = execute( route="/about/index", renderResults=true );
    var event = GET( "/about" );

    expect(	event.getRenderedContent() ).toInclude( "About Us" );
});
```

### Assignment: Add a Links page

### Assignment: Change `prc.welcome` in the `handlers/main.cfc` and update the integration tests to pass.

## 3 - Layouts

### Copy in simple bootstrap theme / layout to replace the existing `/layouts/main.cfm` layout.

```html
<cfoutput>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <title>SoapBox</title>

        <base href="#event.getHTMLBaseURL()#" />

	    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <link rel="stylesheet" href="/includes/css/app.css">

        <script defer src="https://use.fontawesome.com/releases/v5.0.6/js/all.js"></script>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top main-navbar">
            <a class="navbar-brand" href="#event.buildLink( url = "/" )#">
                <i class="fas fa-bullhorn mr-2"></i>
                SoapBox
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="##navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
        </nav>

        <main role="main" class="container">
            #renderView()#
        </main>

        <footer class="border-top py-3 mt-5">
		<div class="container">
			<p class="float-right">
				<a href="##"><i class="fas fa-arrow-up"></i> Back to top</a>
			</p>

			<div class="badge badge-info">
				#getSetting( "environment" )#
			</div>

			<p>
				<a href="http://www.coldbox.org">ColdBox Platform</a> is a copyright-trademark software by
				<a href="http://www.ortussolutions.com">Ortus Solutions, Corp</a>
			</p>
			<p>
				Design thanks to
				<a href="http://getbootstrap.com/">Twitter Boostrap</a>
			</p>
		</div>
	</footer>

        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    </body>
</html>
</cfoutput>
```

### Insert the following CSS into a new file: `/includes/css/app.css`

```css
/* includes/css/app.css */

/* For fixed navbar */
body {
    font-family: "Lato", sans-serif;

    min-height: 75rem;
    padding-top: 4.5rem;
}

.main-navbar {
    box-shadow: 0 15px 30px 0 rgba(0, 0, 0, 0.11), 0 5px 15px 0 rgba(0, 0, 0, 0.08);
}
```

## 4 - Database and CBMigrations

### Install [commandbox-migrations](https://www.forgebox.io/view/commandbox-migrations)

```sh
install commandbox-migrations
```

You should see a list of available commands with `migrate ?`.

### Initalize migrations using `migrate init`

This adds the following to your `box.json` file:

```js
"cfmigrations":{
    "schema":"${DB_DATABASE}",
    "connectionInfo":{
        "password":"${DB_PASSWORD}",
        "connectionString":"${DB_CONNECTIONSTRING}",
        "class":"${DB_CLASS}",
        "username":"${DB_USER}"
    },
    "defaultGrammar":"AutoDiscover"
}
```

Which is needed so migrations can talk to your database!

### Install [commandbox-dotenv](https://www.forgebox.io/view/commandbox-dotenv)

To make our migration setup more secure, we're going to use environment variables. In local development, we can do this easily with a commandbox module, DotEnv.

```sh
install commandbox-dotenv
```

### Create a `/.env` file. Fill it in appropraitely. (We'll fill it in with our Docker credentials from before.)

```sh
DB_DATABASE=soapbox
DB_CLASS=org.gjt.mm.mysql.Driver
DB_CLASS=com.mysql.jdbc.Driver
DB_CONNECTIONSTRING=jdbc:mysql://localhost:3306/soapbox?useUnicode=true\&characterEncoding=UTF-8\&useLegacyDatetimeCode=true\&useSSL=false
DB_USER=root
DB_PASSWORD=soapbox
```

Once the `.env` file is seeded, reload CommandBox so it can pickup the environment: `reload`

### Test our environment variable with an echo command

```sh
echo ${DB_USER}
```

You should see no output, because DotEnv has not loaded the variables from our file.

### Reload your shell in your project root. (`reload` or `r`)

```sh
r
echo ${DB_USER}
```

You should now see `root`, your `DB_USER` output when you run that `echo` command.

### Install cfmigrations using `migrate install`. (This will also test that you can connect to your database.)

```sh
migrate install
```

If the table does not exist, this will create the table in your db. If you refresh your db, you should see the table. If you run the command again, it will let you know it is already installed. Try it!

### Create a users migration

```sh
migrate create create_users_table
```

All migration resources are CFCs and are stored under `resources/database/migrations/**.cfc`.  Make sure these are in version control. They can save your life!

### Fill in the migration.

The migration file was created by the last command, and the file location was output by commandbox.
If you are using VS Code, you can just `Ctrl` + Click to open the file.

```java
component {

    function up( schema ) {
        queryExecute( "
            CREATE TABLE `users` (
                `id` INTEGER UNSIGNED NOT **NULL** AUTO_INCREMENT,
                `username` VARCHAR(255) NOT NULL UNIQUE,
                `email` VARCHAR(255) NOT NULL UNIQUE,
                `password` VARCHAR(255) NOT NULL,
                `createdDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                `modifiedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                CONSTRAINT `pk_users_id` PRIMARY KEY (`id`)
            )
        " );

        // schema.create( "users", function( table ) {
        //     table.increments( "id" );
        //     table.string( "username" ).unique();
        //     table.string( "email" ).unique();
        //     table.string( "password" );
        //     table.timestamp( "createdDate" );
        //     table.timestamp( "modifiedDate" );
        // } );
    }

    function down( schema ) {
        queryExecute( "DROP TABLE `users`" );

        // schema.drop( "users" );
    }

}
```

* Go over file and describe the options you can have to create the schemas.
* QB Schema Builder Docs: https://qb.ortusbooks.com/schema-builder/schema-builder

### Run the migration up.

```sh
migrate up
```

Check your database, and you should see the database table. You can migrate `up` and `down` to test both functions. Go for it, tear it down: `migrate down`, and now back up: `migrate up`.

> If all else fails: `migrate fresh` is your best bet! (https://www.forgebox.io/view/commandbox-migrations)

### Next add the following settings into your `/Application.cfc` file

This will add the datasource to your CFML engine.  There are other ways, but this is the easiest and portable.

```js
this.datasource = "soapbox";
```

### Refresh your app, and you will see an error.

`Could not find a Java System property or Env setting with key [DB_CLASS].`

This is because although we reloaded the CLI so migrations is able to read those values... we did not restart our server, so Java does not have those variables.

`server restart`

Now when you restart, Java is passed all of those variables automatically by the DotEnv module, and now this will work.
You will need to restart your server whenever you add, remove, or change environment variables.

### Ensure your app and your tests are running

Hit `/` in your browser
Hit `/tests/runner.cfm` in your browser

## 5 - Setup the Test Harness and Base Spec

### Install `cfmigrations` as a dev dependency. 

CF Migrations is different than `commandbox-migrations`. It allows you to run the migrations from a running CFML engine and NOT CommandBox.  Usually, you can use them for testing purposes or delivering updates in your apps.  However, for today, this is a development dependency only.

```sh
install cfmigrations --saveDev
```

### Configure `tests/Application.cfc`

```js
// tests/Application.cfc
this.datasource = "soapbox";
```

### Create a `tests/resources/BaseIntegrationSpec.cfc`

```js
component extends="coldbox.system.testing.BaseTestCase" {

    property name="migrationService" inject="MigrationService@cfmigrations";

    this.loadColdBox    = true;
    this.unloadColdBox  = false;

    /**
     * Run Before all tests
     */
    function beforeAll() {
        super.beforeAll();
        // Wire up this object
        application.wirebox.autowire( this );

        // Check if migrations ran before all tests
        if ( ! request.keyExists( "migrationsRan" ) ) {
            migrationService.setMigrationsDirectory( "/root/resources/database/migrations" );
	        migrationService.setDefaultGrammar( "MySQLGrammar" );
            migrationService.setDatasource( "soapbox" );
            migrationService.runAllMigrations( "down" );
            migrationService.runAllMigrations( "up" );
            request.migrationsRan = true;
        }
    }

    /**
     * This function is tagged as an around each handler.  All the integration tests we build
     * will be automatically rolledbacked
     * 
     * @aroundEach
     */
    function wrapInTransaction( spec ) {
        transaction action="begin" {
            try {
                arguments.spec.body();
            } catch ( any e ){
                rethrow;
            } finally {
                transaction action="rollback";
            }
        }
    }

}
```

Let's run the tests again!

## 6 - Intro to Models - User Service

Models are at the core of ColdBox. We could teach you how to write legacy style code, but we want to teach the `right` way from the start. We still start with creating a `User Service` that will be managing users in our SoapBox.

```bash
coldbox create model name="UserService" persistence="singleton"
```

This  will create the `UserService.cfc` in the `models` folder and a companion test in `tests/specs/unit/UserServiceTest.cfc`.

### BDD - Let's write our tests first

Open up the test `/tests/specs/unit/UserServiceTest.cfc`

```js
function run() {
    describe( "User Service", function() {
        it( "can list all users", function() {
            fail( "test not implemented yet" );
        } );
    } );
}
```

Hit the url: http://127.0.0.1:42518/tests/runner.cfm to run your tests. The test will run and fail as expected. As we use BDD we will write the real test.

### Let's write the real test - step 1

```js
    function run() {
        
        describe( "User Service", function() {
			
			it( "can be created", function(){
				expect( model ).toBeComponent();
			});

            it( "can list all users", function() {
			} );
			
        } );

    }
```

Run your tests `/tests/runner.cfm` 

### Lets create the `list()` function

Lets test the `list()` function exists

Update the `/tests/specs/integration/UserServiceTest.cfc`, adding the content to the following `it` block.

```js
it( "can list all users", function() {
    var aResults = model.list();
} );
```

Run the tests and you'll get the following error `component [models.UserService] has no function with name [list]`

Lets create the `list()` function

```js
function list(){
    return "";
}
```

Run the tests and you'll see you tests pass.

### Lets make the `list()` function return the data

Update the `/tests/specs/integration/UserServiceTest.cfc`, adding the content to the following `it` block. This will check the return type, to ensure the return is an array.

```js
it( "can list all users", function() {
    var aResults = model.list();
	expect( aResults ).toBeArray();
} );
```

Run the tests, and they will fail with the following error. `Actual data [] is not of this type: [Array]`

```js
function list(){
    return queryExecute( "select * from users", {}, { returntype = "array" } );
}
```

Run the tests, and the test should pass.

## 7 - Using Models in Handlers and Views

### Inject the `UserService` into your Main Handler.

Add the injection into your `/handlers/Main.cfc` 

```js
property name="userService"		inject="UserService";
```

### Use the `userService.list()` call to retrieve the user list

Call the userService.list() function and store it in a prc variable.

```js
function index(event,rc,prc){
    prc.userList = userService.list();
    prc.welcomeMessage = "Welcome to ColdBox!";
    event.setView("main/index");
}
```

Hit `/` in your browser, and you'll get an error - `Messages: variable [USERSERVICE] doesn't exist.`  What happened? Who can tell me why are we getting this error?


### Reinit the Framework

Hit '/?fwreinit=1' and now you will not see the error.

### Check the List call is working

Add a writeDump in the handler, to ensure the call is succeeding.

```js
writeDump( prc.userList );abort;
```

You'll see something like this

```sh
Array (from Query)
Template: /YourAppDirectory/models/UserService.cfc 
Execution Time: 1.08 ms 
Record Count: 0 
Cached: No 
SQL: 
select * from users 
```

### Access the data from the View

Remove the `writeDump` from the handler.

Add the following into the `/views/main/index.cfm` file, replacing the contents completely.

```html
<cfdump var="#prc.userList#">
```

Reload your `/` page, and you'll see the layout ( which wasn't present in the handler dump ) and the dump of an empty array.

Now we can build our registration flow.

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
				var event = post( route="registration.create", params={} );
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

    return local.result;
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
    "cbauth" = {
        "userServiceClass" = "UserService"
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

## 10 - Rants

### Migrations

```sh
migrate create create_rants_table
```

In the file that was created by the previous command, put this piece of code in there

```js
component {
    
    function up( schema, queryBuilder ) {
        schema.create( "rants", function( table ){
            table.increments( "id" );
            table.text( "body" );
            table.timestamp( "createdDate" );
            table.timestamp( "modifiedDate" );
            table.unsignedInteger( "userId" );
            table.foreignKey( "userId" ).references( "id" ).onTable( "users" );
        } );
    }

    function down( schema, queryBuilder ) {
        schema.drop( "rants" );
    }

}

```

Now, migrate your rants

```
migrate up
```

### BDD

Now, let's do some BDD as we have to build the CRUD for rants. Let's start by generating the tests, handlers and supporting files:

```bash
coldbox create handler name="rants" actions="index,new,create"
# delete the create view, it's not necessary
delete views/rants/create.cfm --force
```

Open the integration tests and start coding:

```js
component extends="tests.resources.BaseIntegrationSpec"{
	
	property name="query" 		inject="provider:QueryBuilder@qb";
	property name="bcrypt" 		inject="@BCrypt";
	property name="auth" 		inject="authenticationService@cbauth";

	/*********************************** LIFE CYCLE Methods ***********************************/

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
		// do your own stuff here
		super.afterAll();
		query.from( "users" )
			.where( "username", "=", "testuser" )
			.delete();
	}

	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( "rants Suite", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			});

			it( "can display all rants", function(){
				var event = get( route="/rants", params={} );
				// expectations go here.
				expect( event.getPrivateValue( "aRants") ).toBeArray();
				expect( event.getRenderedContent() ).toInclude( "All Rants" );
			});

			it( "can display the rants index when no rants exists", function(){
				prepareMock( getInstance( "RantService" ) )
					.$( "getAll", [] );
				var event = get( route="/rants", params={} );
				
				getWireBox().clearSingletons();

				expect( event.getPrivateValue( "aRants") ).toBeEmpty();
				expect( event.getRenderedContent() ).toInclude( "No rants yet" );
			});

			it( "can display the new rant form", function(){
				var event = get( route="/rants/new" );
				// expectations go here.
				expect( event.getRenderedContent() ).toInclude( "Rant About It" );
			});

			it( "can stop a rant from being created from an invalid user", function(){
				expect( function(){
					var event = post( route="rants.create", params={
						body = "Test Rant"
					} );
				}).toThrow( type="NoUserLoggedIn" );
			});
			
			it( "can create a rant from a valid user", function(){

				// Log in user
				auth.authenticate( "testuser", "password" );

				var event = post( route="rants.create", params={
					body = "Test Rant"
				} );

				expect( event.getValue( "relocate_URI" ) ).toBe( "/rants" );
			});

		
		});

	}

}
```

### Resources Router

Add the rants resources in the `Router.cfc` file

```js
// config/Router.cfc
resources( "rants" );
```

### Event Handler

Let's build it out.

```js
// handlers/rants.cfc

/**
* I am a new handler
*/
component{
	
	property name="rantService" 	inject;
	property name="messagebox" 		inject="MessageBox@cbmessagebox";
		
	/**
	* index
	*/
	function index( event, rc, prc ){
		prc.aRants = rantService.getAll()
		event.setView( "rants/index" );
	}

	/**
	* new
	*/
	function new( event, rc, prc ){
		event.setView( "rants/new" );
	}

	/**
	* create
	*/
	function create( event, rc, prc ){
		var oRant = populateModel( "Rant" );

		oRant.setUserId( auth().getUserId() );

		rantService.create( oRant );

		messagebox.info( "Rant created!" );
		relocate( URI="/rants" );
	}


	
}
```


### Model: `Rant`

Run the following to create your Rant object with a constructor and a few methods `getUser(),isLoaded()` method we will fill out later.  Please note the unit test is created as well.

```bash
coldbox create model name="Rant" properties="id,body,createdDate:date,modifiedDate:date,userID" methods="getUser,isLoaded"
```

Let's open the model and modify it a bit

```js
/**
* I am a new Rant Object
*/
component accessors="true"{

	// DI
	property name="userService" inject;
	
	// Properties
	property name="id"           type="string" default = "";
	property name="body"         type="string" default = "";
	property name="createdDate"  type="date";
	property name="modifiedDate" type="date";
	property name="userID"       type="string" default = "";
	

	/**
	 * Constructor
	 */
	Rant function init(){
		variables.createdDate = now();
		return this;
	}
	
	/**
	* getUser
	*/
	function getUser(){
		// Lazy loading the relationship
		return userService.retrieveUserById( getuserId() );
	}

	/**
	* isLoaded
	*/
	boolean function isLoaded(){
		return( !isNull( variables.id ) && len( variables.id ) );
	}


}
```

Work on the unit test, what will you test?

```js
/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.BaseIntegrationSpec"{
	
	property name="query" 		inject="provider:QueryBuilder@qb";
	property name="bcrypt" 		inject="@BCrypt";

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		model = getInstance( "Rant" );
		
		cleanUserFixture();
		testUserId = query.from( "users" )
			.insert( values = {
				username : "testuser",
				email : "testuser@tests.com",
				password : bcrypt.hashPassword( "password" )
			} ).result.generatedKey;

		model.setUserId( testUserId );
	}

	function afterAll(){
		cleanUserFixture();
		super.afterAll();
	}

	function cleanUserFixture(){
		query.from( "users" )
			.where( "username", "=", "testuser" )
			.delete();
	}

	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( "Rant Suite", function(){
			
			it( "can create the Rant", function(){
				
				expect(	model ).toBeComponent();
				
			});

			it( "should getUser", function(){
				var oUser = model.getUser();

				expect( oUser.getId() ).toBe( testUserId );
			});


		});

	}

}
```

### Model: `RantService`

Let's create our rant service and work on it with a few methods: `getAll(),create(),new()`

```bash
coldbox create model name="RantService" persistence="singleton" methods="getAll,create,new"
```

Now open it and let's modify it a bit for our purposes.  Also update the unit tests.

```js
/**
* I am a new Model Object
*/
component singleton accessors="true"{
	
	// Properties
	property name="populator" inject="wirebox:populator";

	/**
	 * Constructor
	 */
	RantService function init(){
		
		return this;
	}

	/**
	 * Provider of Rant objects
	 */
	Rant function new() provider="Rant"{}
	
	/**
	 * Get all rants
	 */
	array function getAll(){
		return queryExecute(
            "SELECT * FROM `rants` ORDER BY `createdDate` DESC",
            [],
            { returntype = "array" }
        ).map( function ( rant ) {
            return populator.populateFromStruct(
                new(),
                rant
            );
        } );
	}

	/**
	 * Create a rant
	 */
	function create( required rant ){
		rant.setModifiedDate( now() );
        queryExecute(
            "
                INSERT INTO `rants` (`body`, `modifiedDate`, `userId`)
                VALUES (?, ?, ?)
            ",
            [
                rant.getBody(),
                { value = rant.getModifiedDate(), cfsqltype = "TIMESTAMP" },
                rant.getUserId()
            ],
            { result = "local.result" }
        );
        rant.setId( result.GENERATED_KEY );
		
		return rant;
	}

}
```

```js
describe( "RantService Suite", function(){
			
    it( "can be created", function(){
        expect( model ).toBeComponent();
    });

});
```

Why not create more unit tests?

### The `index` view

```html
<!-- views/rants/index.cfm -->
<cfoutput>
    <cfif prc.aRants.isEmpty()>
        <h3>No rants yet</h3>
        <a href="#event.buildLink( "rants.new" )#" class="btn btn-primary">Start one now!</a>
    <cfelse>
        <a href="#event.buildLink( "rants.new" )#" class="btn btn-primary">Start a new rant!</a>
        <cfloop array="#prc.aRants#" item="rant">
            <div class="card mb-3">
                <div class="card-header">
                    <strong>#rant.getUser().getUsername()#</strong> said at #dateTimeFormat( rant.getCreatedDate(), "h:nn:ss tt" )# on #dateFormat( rant.getCreatedDate(), "mmm d, yyyy")#
                </div>
                <div class="panel card-body">
                    #rant.getBody()#
                </div>
            </div>
        </cfloop>
    </cfif>
</cfoutput>
```

### Set the default event to `rants.index`

We want our rants to be the homepage instead of the default one.

```js
// inside the coldbox struct
coldbox = {
    defaultEvent = "rants.index",
    ...
};
```

Hit http://127.0.0.1:42518/ and you'll see the main.index with the dump. ColdBox settings require a framework reinit.

Reinit the framework, then you'll see the Rant index.

### The `new` view

```html
<!-- views/rants/new.cfm -->
<cfoutput>
    <div class="card">
        <h4 class="card-header">Start a Rant</h4>
        <form class="form panel card-body" method="POST" action="#event.buildLink( "rants.create" )#">
            <div class="form-group">
                <textarea name="body" class="form-control" placeholder="What's on your mind?" rows="10"></textarea>
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-primary">Rant About It!</button>
            </div>
        </form>
    </div>
</cfoutput>
```

### Update the main layout

```html
<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top main-navbar">
    <a class="navbar-brand" href="#event.buildLink( url = "/" )#">
        <i class="fas fa-bullhorn mr-2"></i>
        SoapBox
    </a>

    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="##navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <cfif auth().isLoggedIn()>
    <ul class="navbar-nav">
        <li><a href="#event.buildLink( "rants.new" )#" class="nav-link">Start a Rant</a></li>
    </ul>
    </cfif>

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

</nav>
```

Hit http://127.0.0.1:42518/ and click on Start a rant and you'll see the form.
Log out and try, and you can still see the form. Try to create a rant and you'll see an error!
We need to secure the form, to ensure the user is logged in before they can send a rant.

## 11 - Install `cbsecurity` by running the following command

```sh
install cbsecurity
```

### 11.1 - Configure `cbsecurity`, add the settings in your `ColdBox.cfc` as a root level struct

```js
// config/ColdBox.cfc
"cbsecurity" = {
    "rulesFile" = "/config/security.json.cfm",
    "rulesSource" = "json",
    "validatorModel" = "UserService"
};
```

### 11.2 - Create a `security.json.cfm` file inside the config folder
```js
// config/security.json

[
    {
        "whitelist": "",
        "securelist": "rants/new",
        "match": "url",
        "roles": "",
        "redirect": "login"
    }
]
```

### 11.3 - Create the `userValidator` function in `UserService.cfc`

```js
// models/UserService.cfc

property name="authenticationService" inject="AuthenticationService@cbauth";

function userValidator( rule, controller ) {
    return authenticationService.isLoggedIn();
}
```

Then let's change this function to add a messagebox:

```js
var isLoggedIn = authenticationService.isLoggedIn();

if( !isLoggedIn ){
    controller.getWireBox().getInstance( "messagebox@cbMessageBox" )
        .error( "You don't have access, please log in." );
}

return isLoggedIn;
```

### 11.4 - Reinit the framework

`coldbox reinit`

### 11.5 - Hit the page while logged out. if you hit `start a rant` link, you should redirect to the login page

### 11.6 - Now log in and make sure you see the rant page.

## 12 - View a user's rants

### 12.1 - Create a users profile page, for that we need to create a route in our `Router.cfc` file

```js
// config/Router.cfc
get( "/users/:username" ).to( "users.show" );
```


### 12.2 - Create a `users` handler

`coldbox create handler name="users" actions="show"`

Now work on the BDD and implementation

```js
// handlers/users.cfc
component {

    property name="userService" inject;

    function show( event, rc, prc ) {
        event.paramValue( "username", "" );

        prc.user = userService.retrieveUserByUsername( rc.username );
        if ( !prc.user.isLoaded() ) {
            relocate( "404" );
        }
        event.setView( "users/show" );
    }

}
```


### 12.3 - Create a `404.cfm` view

```sh
// views/404.cfm
Whoops!  That page doesn't exist.
```

### 12.4 - Create a `show.cfm` view

```html
// views/users/show.cfm
<cfoutput>
    <h1>#prc.user.getUsername()#</h1>
    <h4>Rants</h4>
    <ul>
        <cfloop array="#prc.user.getRants()#" item="rant">
            #renderView( "_partials/_rant", { rant = rant } )#
        </cfloop>
    </ul>
</cfoutput>
```

### 12.5 - Create a `views/_partials/_rant.cfm` view

```html
<cfoutput>
    <div class="card mb-3">
        <div class="card-header">
            <strong><a href="#event.buildLink( "users.#args.rant.getUser().getUsername()#" )#">#args.rant.getUser().getUsername()#</a></strong>
            said at #dateTimeFormat( args.rant.getCreatedDate(), "h:nn:ss tt" )#
            on #dateFormat( args.rant.getCreatedDate(), "mmm d, yyyy")#
        </div>
        <div class="panel card-body">
            #args.rant.getBody()#
        </div>
    </div>
</cfoutput>
```

### 12.6 - Edit the `views/rants/index.cfm` file and replace the content of the loop to render the `_partials/_rant` view

```html
<cfloop array="#prc.rants#" item="rant">
    #renderView( "_partials/_rant", { rant = rant } )#
</cfloop>
```

### 12.7 - Update your `User.cfc` Model

To be able to pull the rants for a user, we need to update our User object, to be able to access the Rant Service.

#### 12.7.1 - Inject the rantService

```
property name="rantService" inject;
```

#### 12.7.2 - Create a `getRants` function

```js
function getRants() {
    return rantService.getForUserId( variables.id );
}
```

#### 12.7.3 - Create a `getForUserId` function in `RantService`

```js
function getForUserId( required userId ) {
    return queryExecute(
        "SELECT * FROM `rants` WHERE `userId` = ? ORDER BY `createdDate` DESC",
        [ userId ],
        { returntype = "array" }
    ).map( function ( rant ) {
        return populator.populateFromStruct(
            new(),
            rant
        );
    } );
}
```

### 12.8 - Reinitialize the application

`coldbox reinit`

### 12.9 - Test it out in the browser



## 13. Add 👊 and 💩 actions

#### 13.1.1 - Migrate `bumps` table

```
migrate create create_bumps_table
```

#### 13.1.2 - Fill the file you just create with the following functions

```js
component {

    function up( schema ) {
        queryExecute( "
            CREATE TABLE `bumps` (
                `userId` INTEGER UNSIGNED NOT NULL,
                `rantId` INTEGER UNSIGNED NOT NULL,
                CONSTRAINT `pk_bumps`
                    PRIMARY KEY (`userId`, `rantId`),
                CONSTRAINT `fk_bumps_userId`
                    FOREIGN KEY (`userId`)
                    REFERENCES `users` (`id`)
                    ON UPDATE CASCADE
                    ON DELETE CASCADE,
                CONSTRAINT `fk_bumps_rantId`
                    FOREIGN KEY (`rantId`)
                    REFERENCES `rants` (`id`)
                    ON UPDATE CASCADE
                    ON DELETE CASCADE
            )
        " );
    }

    function down( schema ) {
        queryExecute( "DROP TABLE `bumps`" );
    }

}
```

#### 13.2.1 - Migrate `poops` table
```
migrate create create_poops_table
```

#### 13.2.2 - Fill the file you just create with the following functions

```js
component {

    function up( schema ) {
        queryExecute( "
            CREATE TABLE `poops` (
                `userId` INTEGER UNSIGNED NOT NULL,
                `rantId` INTEGER UNSIGNED NOT NULL,
                CONSTRAINT `pk_poops`
                    PRIMARY KEY (`userId`, `rantId`),
                CONSTRAINT `fk_poops_userId`
                    FOREIGN KEY (`userId`)
                    REFERENCES `users` (`id`)
                    ON UPDATE CASCADE
                    ON DELETE CASCADE,
                CONSTRAINT `fk_poops_rantId`
                    FOREIGN KEY (`rantId`)
                    REFERENCES `rants` (`id`)
                    ON UPDATE CASCADE
                    ON DELETE CASCADE
            )
        " );
    }

    function down( schema ) {
        queryExecute( "DROP TABLE `poops`" );
    }

}
```

### 13.3 - Now run the function `up`

```
migrate up
```

### 13.4 - Display bumps on the rant partial, add this footer in `/views/_partials/_rant.cfm`

```
// /views/_partials/_rant.cfm

<div class="card-footer">
    <button class="btn btn-outline-dark">
        #args.rant.getBumps().len()# 👊
    </button>
    <button class="btn btn-outline-dark">
        #args.rant.getPoops().len()# 💩
    </button>
</div>
```

### 13.5 - Update `Rant.cfc`

#### 13.5.1 - Create `ReactionService.cfc` in `models/services/`

```bash
coldbox create model name="ReactionService" methods="getBumpsForRant,getPoopsForRant"
```

Then update the model

```js
// models/services/ReactionService.cfc
component {

    property name="populator" inject="wirebox:populator";
    property name="wirebox" inject="wirebox";

    function newBump() provider="Bump";
    function newPoop() provider="Poop";

    function getBumpsForRant( rant ) {
        return queryExecute(
            "SELECT * FROM `bumps` WHERE `rantId` = ?",
            [ rant.getId() ],
            { returntype = "array" }
        ).map( function( bump ) {
            return populator.populateFromStruct(
                newBump(),
                bump
            )
        } );
    }

    function getPoopsForRant( rant ) {
        return queryExecute(
            "SELECT * FROM `poops` WHERE `rantId` = ?",
            [ rant.getId() ],
            { returntype = "array" }
        ).map( function( bump ) {
            return populator.populateFromStruct(
                newPoop(),
                bump
            )
        } );
    }

}
```

#### 13.5.2 - Inject `reactionService` and create the following functions in the `Rant` object

```js
// models/Rant.cfc

property name="reactionService" inject="id";

function getBumps() {
    return reactionService.getBumpsForRant( this );
}

function getPoops() {
    return reactionService.getPoopsForRant( this );
}
```

### 13.6 - Reinitialize the framework

### 13.7 - Try the site, and realize its broken, but why?

```js
Event: rants.index
Routed URL: rants/
Layout: N/A (Module: )
View: N/A
Timestamp: 04/13/2018 09:54:07 AM
Type: Builder.DSLDependencyNotFoundException
Messages: The DSL Definition {REF={null}, REQUIRED={true}, ARGNAME={}, DSL={id}, JAVACAST={null}, NAME={reactionService}, TYPE={any}, VALUE={null}, SCOPE={variables}} did not produce any resulting dependency The target requesting the dependency is: 'Rant'
```

This is a WireBox DSL injection error. Saying the RANT module is having trouble asking for the reactionService




## 14 - Wirebox Conventions vs Configuration

Dependency Injection is Magic - Not really

Did you notice anything different when we created the Service??
We created a services folder inside of Models, to organize our Models better.

Wirebox is very powerful, but it is not magic, it runs by conventions, and you can configure it to run differently if you have differing opinions on the conventions.

So you have to tell it what you want it to do if you want to do something more. In this case, instead of just using model paths (automatic convention), we can tell Wirebox to map models and all of its subfolders.

Note - This recursive search of the models folder is the default in modules, and this convention will be modified for the main models folder very soon in ColdBox.

### 14.1 - Open the WireBox.cfc

Located in the /config folder.

### 14.2 - Scroll to the bottom of the file and insert the following

```js
// Map Bindings below
mapDirectory( "models" );
```

This will make the models folder recursively, now allowing you to organize your folders however you see fit.

### 14.3 - Reinitialize the framework

### 14.4 - Test out the site... no errors now.

## 15 - Make Rant Reactions Functional

### 15.1 - Make buttons clickable

#### 15.1.1 - Update your the footer of `_rant.cfm`

```html
// views/_partials/_rant.cfm
<div class="card-footer">
    <cfif auth().guest()>
        <button disabled class="btn btn-outline-dark">
            #args.rant.getBumps().len()# 👊
        </button>
    <cfelseif auth().user().hasBumped( args.rant )>
        <form method="POST" action="#event.buildLink( "rants.#args.rant.getId()#.bumps" )#" style="display: inline;">
            <input type="hidden" name="_method" value="DELETE" />
            <button class="btn btn-dark">
                #args.rant.getBumps().len()# 👊
            </button>
        </form>
    <cfelse>
        <form method="POST" action="#event.buildLink( "rants.#args.rant.getId()#.bumps" )#" style="display: inline;">
            <button class="btn btn-outline-dark">
                #args.rant.getBumps().len()# 👊
            </button>
        </form>
    </cfif>

    <cfif auth().guest()>
        <button disabled class="btn btn-outline-dark">
            #args.rant.getPoops().len()# 💩
        </button>
    <cfelseif auth().user().hasPooped( args.rant )>
        <form method="POST" action="#event.buildLink( "rants.#args.rant.getId()#.poops" )#" style="display: inline;">
            <input type="hidden" name="_method" value="DELETE" />
            <button class="btn btn-dark">
                #args.rant.getPoops().len()# 💩
            </button>
        </form>
    <cfelse>
        <form method="POST" action="#event.buildLink( "rants.#args.rant.getId()#.poops" )#" style="display: inline;">
            <button class="btn btn-outline-dark">
                #args.rant.getPoops().len()# 💩
            </button>
        </form>
    </cfif>
</div>
```

### 15.2 - Update your `User.cfc`, inject the `reactionService` and add the following functions

```js
// models/User.cfc

property name="reactionService" inject="id";

function hasBumped( rant ) {
    if ( isNull( variables.bumps ) ) {
        variables.bumps = reactionService.getBumpsForUser( this );
    }
    return ! variables.bumps.filter( function( bump ) {
        return bump.getRantId() == rant.getId();
    } ).isEmpty();
}

function hasPooped( rant ) {
    if ( isNull( variables.poops ) ) {
        variables.poops = reactionService.getPoopsForUser( this );
    }
    return ! variables.poops.filter( function( poop ) {
        return poop.getRantId() == rant.getId();
    } ).isEmpty();
}
```

### 15.3 - Update your `ReactionService.cfc`, add the following functions

```js
// models/services/ReactionService.cfc

function getBumpsForUser( user ) {
    return queryExecute(
        "SELECT * FROM `bumps` WHERE `userId` = ?",
        [ user.getId() ],
        { returntype = "array" }
    ).map( function( bump ) {
        return populator.populateFromStruct(
            newBump(),
            bump
        )
    } );
}

function getPoopsForUser( user ) {
    return queryExecute(
        "SELECT * FROM `poops` WHERE `userId` = ?",
        [ user.getId() ],
        { returntype = "array" }
    ).map( function( poop ) {
        return populator.populateFromStruct(
            newPoop(),
            poop
        )
    } );
}
```

### 15.4 - Create new handlers

#### 15.4.1 - Add the routes before the resources

```js
addRoute( "rants/:id/bumps", "Bumps", { "POST" = "create", "DELETE" = "delete" } );
addRoute( "rants/:id/poops", "Poops", { "POST" = "create", "DELETE" = "delete" } );
```

#### 15.4.2 - Create `bumps` handler

```bash
coldbox create handler name="bumps" actions="create,delete"
```

```js
// handlers/bumps.cfc
component {

    property name="reactionService" inject="id";

    function create( event, rc, prc ) {
        reactionService.bump( rc.id, auth().getUserId() );
        relocate( "rants" );
    }

    function delete( event, rc, prc ) {
        reactionService.unbump( rc.id, auth().getUserId() );
        relocate( "rants" );
    }

}
```

#### 15.4.3 - Create `poops` handler

```bash
coldbox create handler name="poops" actions="create,delete"
```

```js
// handlers/poops.cfc
component {

    property name="reactionService" inject="id";

    function create( event, rc, prc ) {
        reactionService.poop( rc.id, auth().getUserId() );
        relocate( "rants" );
    }

    function delete( event, rc, prc ) {
        reactionService.unpoop( rc.id, auth().getUserId() );
        relocate( "rants" );
    }

}
```

### 15.5 - Update your `ReactionService.cfc` with the following functions

```js
// models/services/ReactionService.cfc
function bump( rantId, userId ) {
    queryExecute(
        "INSERT INTO `bumps` VALUES (?, ?)",
        [ userId, rantId ]
    );
}

function unbump( rantId, userId ) {
    queryExecute(
        "DELETE FROM `bumps` WHERE `userId` = ? AND `rantId` = ?",
        [ userId, rantId ]
    );
}

function poop( rantId, userId ) {
    queryExecute(
        "INSERT INTO `poops` VALUES (?, ?)",
        [ userId, rantId ]
    );
}

function unpoop( rantId, userId ) {
    queryExecute(
        "DELETE FROM `poops` WHERE `userId` = ? AND `rantId` = ?",
        [ userId, rantId ]
    );
}
```

### 15.6 - Add the Bump Model

```js
// models/Bump.cfc
component accessors="true" {

    property name="userId";
    property name="rantId";

}
```

### 15.7 - Add the Poop Model

```js
// models/Poop.cfc
component accessors="true" {

    property name="userId";
    property name="rantId";

}
```

### 15.8 - Reinialize the Framework and Test the Site

### 15.9 - You're done!!



## 16 - Extra Credit

+ Don't let a user poop and bump the same rant
+ When you bump or poop from the user profile page - take the user back to that page, not the main rant page. Ie - return them to where they started
+ Convert the bump and poop to AJAX calls
+ CSRF tokens for login, register, and new rant
+ Move `queryExecute` to `qb`

Other Ideas:
+ Environments in ColdBox.cfc
+ Domain Names in CommandBox


### 17.1 - Install `qb`

```sh
install qb
```

### 17.2 - Configure `qb`

#### 13.2.1 - Add the following settings to your `/config/Coldbox.cfc` file. You can place this modules setting struct under the settings struct.

```js
// config/ColdBox.cfc
moduleSettings = {
    qb = {
        defaultGrammar = "MySQLGrammar"
    }
};
```
