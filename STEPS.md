# Steps to go from ColdBox Zero to Hero

(All commands assume we are in the `box` shell unless stated otherwise.)

## 1 - Create the base app

### 1.1 - Create a folder for your app on your hard drive called `soapbox`.
`
### 1.2  Scaffold out a new Coldbox application with TestBox included.

```sh
coldbox create app soapbox
```

### 1.2 bug Install testbox if the above command didn't work (CommandBox < 4.2)

```sh
install --dev
```


### 1.3 - Start up a local server

```sh
start cfengine=lucee@5 port=42518
```

### 1.4 - Open `http://localhost:42518/` in your browser. You should see the default ColdBox app template.

### 1.5 - Open `/tests` in your browser. You should see the TestBox test browser.
    This is useful to find a specific test or group of tests to run _before_ running them.

### 1.6 - Open `/tests/runner.cfm` in your browser. You should see the TestBox test runner for our project.
    This is running all of our tests by default. We can create our own test runners as needed.

All your tests should be passing at this point. 😉

### 1.7 - Let's run the Tests via CommandBox

```sh
testbox run "http://localhost:42518/tests/runner.cfm"
```

### 1.7.1 - Lets add this url to our server.json

We can set the testbox runner into our server.json, and then we can easily run the tests at a later stage without having to type out the whole url. To do so, we use the `package set` command.

```sh
package set testbox.runner="http://localhost:42518/tests/runner.cfm"
testbox run
```

### 1.8 - Use CommandBox Test Watchers

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

### 2.1 - ColdBox.cfc Intro

### 2.2 - Development Settings

### 2.3 - Show routes file. Explain routing by convention.

### 2.4 - Explain `event`, `rc`, and `prc`.

### 2.5 - Show `Main.index`.

### 2.6 - Explain views. Point out view conventions.

### 2.7 - Briefly touch on layouts.

### 2.8 - Show how `rc` and `prc` are used in the views.

### 2.9 - Add an about page<br>

#### 2.9.1 - Add an `views/about/index.cfm`. Hit the url `/about/index` and it works!
```html
<cfoutput>
    <h1>About us!</h1>
</cfoutput>
```
#### 2.9.2 - Add an `about` handler. Use a non existing view and see if it breaks. Talk about reinits.

#### 2.9.3 - Add an `index` action. Back to working!

### 2.10 - Reinit the framework

* What is cached?

* Singletons

### 2.11 Assignment: Add a Links page

### 2.12 Assignment: Change prc.welcome and update test to pass.

## 3 - Layouts

### 3.1 -  Copy in simple bootstrap theme / layout to replace the existing `/layouts/main.cfm` layout.

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

        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    </body>
</html>
</cfoutput>
```

### 3.2 - Insert the following CSS into a new file: `/includes/css/app.css`
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

### 4.1 - Install [commandbox-migrations](https://www.forgebox.io/view/commandbox-migrations)

```sh
install commandbox-migrations
```

You should see a list of available commands with `migrate ?`.

### 4.2 - Initalize migrations using `migrate init`

### 4.3 - Install [commandbox-dotenv](https://www.forgebox.io/view/commandbox-dotenv)

To make our migration setup more secure, we're going to use environment variables. In local development, we can do this easily with a commandbox module, DotEnv.

```sh
install commandbox-dotenv
```

### 4.4 - Create a `/.env` file. Fill it in appropraitely. (We'll fill it in with our
    Docker credentials from before.)

```sh
DB_DATABASE=soapbox
DB_CLASS=org.gjt.mm.mysql.Driver
DB_CONNECTIONSTRING=jdbc:mysql://localhost:3306/soapbox?useUnicode=true\&characterEncoding=UTF-8\&useLegacyDatetimeCode=true\&useSSL=false
DB_USER=root
DB_PASSWORD=soapbox
```

### 4.5 - Test our environment variable with an echo command

```sh
echo ${DB_USER}
```

You should see no output, because DotEnv has not loaded the variables from our file.

### 4.6 - Reload your shell in your project root. (`reload` or `r`)

```sh
r
echo ${DB_USER}
```

You should now see `root`, your `DB_USER` output when you run that `echo` command.

### 4.7 - Install cfmigrations using `migrate install`. (This will also test that you can connect to your database.)

```sh
migrate install
```
If the table does not exist, this will create the table in your db. If you refresh your db, you should see the table. If you run the command again, it will let you know it is already installed.

### 4.8 - Create a users migration

```sh
migrate create create_users_table
```

### 4.9 - Fill in the migration.
The migration file was created by the last command, and the file location was output by commandbox.
If you are using VS Code, you can just `Ctrl` + Click to open the file.

```js
component {

    function up( schema ) {
        queryExecute( "
            CREATE TABLE `users` (
                `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
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

### 4.10 - Run the migration up.

```sh
migrate up
```

Check your database, and you should see the database table. You can migrate up and down to test both functions.

### 4.11 - Next add the following settings into your `/Application.cfc` file

```js
// Application.cfc
variables.util = new coldbox.system.core.util.Util();

this.datasources = {
    "soapbox" = {
        "class" = util.getSystemSetting( "DB_CLASS" ),
        "connectionString" = util.getSystemSetting( "DB_CONNECTIONSTRING" ),
        "username" = util.getSystemSetting( "DB_USER" ),
        "password" = util.getSystemSetting( "DB_PASSWORD" )
    }
};
this.datasource = "soapbox";
```

### 4.12 - Refresh your app, and you will see an error.

`Could not find a Java System property or Env setting with key [DB_CLASS].`

This is because although we reloaded the CLI so migrations is able to read those values... we did not restart our server, so Java does not have those variables.

`server restart`

Now when you restart, Java is passed all of those variables automatically by the DotEnv module, and now this will work.
You will need to restart your server whenever you add, remove, or change environment variables.

### 4.13 - Ensure your app and your tests are running

Hit `/` in your browser
Hit `/tests/runner.cfm` in your browser

## 5 - Setup the Test Harness and Base Spec

### 5.1 - Delete the MainBDDTest

### 5.2 - Install `cfmigrations` as a dev dependency. 

```sh
install cfmigrations --saveDev
```

This is not the same as commandbox-migrations.

### 5.3 - Configure `tests/Application.cfc`

```js
// tests/Application.cfc
variables.util = new coldbox.system.core.util.Util();

this.datasources = {
    "soapbox" = {
        "class" = util.getSystemSetting( "DB_CLASS" ),
        "connectionString" = util.getSystemSetting( "DB_CONNECTIONSTRING" ),
        "username" = util.getSystemSetting( "DB_USER" ),
        "password" = util.getSystemSetting( "DB_PASSWORD" )
    }
};
this.datasource = "soapbox";

function onRequestStart() {
    structDelete( application, "cbController" );
}
```

### 5.4 - Create a `tests/resources/BaseIntegrationSpec.cfc`

```js
component extends="coldbox.system.testing.BaseTestCase" {

    property name="migrationService" inject="MigrationService@cfmigrations";

    this.loadColdBox = true;
    this.unloadColdBox = false;

    function beforeAll() {
        super.beforeAll();
        application.wirebox.autowire( this );
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
     * @aroundEach
     */
    function wrapInTransaction( spec ) {
        transaction action="begin" {
            try {
                spec.body();
            }
            catch ( any e ) {
                rethrow;
            }
            finally {
                transaction action="rollback";
            }
        }
    }

}
```

## 6 - Intro to Models

Models are at the core of ColdBox. We could teach you how to write legacy style code, but we want to teach the `right` way from the start. We still start with creating a `User Service`.

### 6.1 - TDD - Let's write our tests first

Create a new test `/tests/specs/integration/UserServiceTest.cfc`

```js
component extends="tests.resources.BaseIntegrationSpec" {

    function run() {
        describe( "User Service", function() {
            it( "can list all users", function() {
                fail( "test not implemented yet" );
            } );
        } );
    }

}
```

Hit the url: http://127.0.0.1:42518/tests/runner.cfm to run your tests. The test will run and fail as expected. As we use TDD we will write the real test.

### 6.2.1 - Let's write the real test - step 1

```js
component extends="tests.resources.BaseIntegrationSpec" {

    function run() {
        
        describe( "User Service", function() {

            beforeEach(function( currentSpec ){
                service = prepareMock( getInstance( "UserService" ) );
            });

            it( "can be created", function(){
				expect( service ).toBeComponent();
			});

            it( "can list all users", function() {
            } );
        } );
    }

}
```

Run your tests `/tests/runner.cfm` 

You will see an error message - `Requested instance not found: 'UserService'`

### 6.2.1 - Create the User Service

```sh
component{
}
```

Run the tests, and you'll see the test passes. The Service can be found.

### 6.3 - Lets create the `list()` function

#### 6.3.1 - Lets test the `list()` function exists

Update the `/tests/specs/integration/UserServiceTest.cfc`, adding the content to the following `it` block.

```js
it( "can list all users", function() {
    service.list();
} );
```

Run the tests and you'll get the following error `component [models.UserService] has no function with name [list]`

#### 6.3.2 - Lets create the `list()` function

```js
function list(){
    return "";
}
```

Run the tests and you'll see you tests pass.

### 6.4 Lets make the `list()` function return the data

#### 6.4.1 - Update our test for the `list()` function

Update the `/tests/specs/integration/UserServiceTest.cfc`, adding the content to the following `it` block. This will check the return type, to ensure the return is an array.

```js
it( "can list all users", function() {
    expect( service.list() ).toBeArray();
} );
```

Run the tests, and they will fail with the following error. `Actual data [] is not of this type: [Array]`

#### 6.4.2 - Let's make the `list()` function work

```js
function list(){
    return queryExecute( "select * from users", {}, { returntype = "array" } );
}
```

Run the tests, and the test should pass.

## 7 - Using Models in Handlers and Views

### 7.1 - Inject the `UserService` into your Main Handler.

Add the injection into your `/handlers/Main.cfc` 

```js
property name="userService"		inject="UserService";
```

### 7.2 Use the `userService.list()` call to retrieve the user list

Call the userService.list() function and store it in a prc variable.

```js
function index(event,rc,prc){
    prc.userList = userService.list();
    prc.welcomeMessage = "Welcome to ColdBox!";
    event.setView("main/index");
}
```

Hit `/` in your browser, and you'll get an error - `Messages: variable [USERSERVICE] doesn't exist
`

### 7.3 - Reinit the Framework

Hit '/?fwreinit=1' and now you will not see the error.

### 7.4 - Check the List call is working

Add a writeDump in the handler, to ensure the call is succeeding.

```js
writeDump( prc.userList );abort;
```

You'll see something like this

```sh
Array (from Query)
Template: /YourAppDirectory/models/UserService.cfc 
Execution Time: 1.54 ms 
Record Count: 0 
Cached: No 
SQL: 
select * from users 
```

### 7.5 - Access the data from the View

Remove the writeDump from the handler.

Add the following into the `/views/main/index.cfm` file, replacing the contents completely.

```html
<cfdump var="#prc.userList#">
```

Reload your `/` page, and you'll see the layout ( which wasn't present in the handler dump ) and the dump of an empty array.

Now we can build our registration flow.

## 8 - Building the Registration Flow

Start Register flow. The next series of steps will build the Register flow, including BDD and TDD.

### 8.1 - Create a `tests/specs/integration/RegistrationSpec.cfc`

```js
component extends="tests.resources.BaseIntegrationSpec" {

    property name="query" inject="provider:QueryBuilder@qb";

    function run() {
        describe( "registration", function() {
            it( "can register a user", function() {
                fail( "test not implemented yet" );
            } );
        } );
    }

}
```

Hit the url: http://127.0.0.1:42518/tests/runner.cfm to run your tests. The test will run and fail as expected. As we use TDD we will write the real test.

### 8.2 - Replace the `can register a user` test with the following

```js
it( "can register a user", function() {
    expect( queryExecute( "select * from users", {}, { returntype = "array" } ) ).toBeEmpty();

    var event = post( "/registration", {
        "username" = "elpete",
        "email" = "eric@elpete.com",
        "password" = "mypass1234",
        "passwordConfirmation" = "mypass1234"
    } );

    expect( event.getValue( "relocate_URI", "" ) ).toBe( "/" );

    var users = query.from( "users" ).get();
    expect( users ).toBeArray();
    expect( users ).toHaveLength( 1 );
    expect( users[ 1 ].username ).toBe( "elpete" );
} );
```

Hit the url: http://127.0.0.1:42518/tests/runner.cfm to run your tests. The test will run and error as expected. `The event: registration is not a valid registered event.`

Next we'll write the production code to make this test pass.

### 8.3 - Write the production code

**SHOW RESOURCES ROUTING TABLE. EXPLAIN WHY RESOURCES.**
https://coldbox.ortusbooks.com/the-basics/routing/routing-dsl/resourceful-routes

Update the `/config/Router.cfc` file - insert a resources definition.

```js
// config/Router.cfc
function configure(){
    setFullRewrites( true );
    resources("registration");
    route( ":handler/:action?" ).end();
}
```

Create a new Handler
```js
// handlers/Registration.cfc
component {

}
```

#### 8.3.1 - Add the action into the Registration Handler `handlers/Registration.cfc`

```js
function new( event, rc, prc ) {
    return event.setView( "registration/new" );
}
```

http://127.0.0.1:42518/registration/new?fwreinit=1
You will see an error `Messages: Page /views/registration/new.cfm [C:\www\soapbox\app\registration\new.cfm] not found`

#### 8.3.2 - Create the new view.

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

#### 8.3.3 - Add a register link to the navbar

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

### 8.4 - Add `create` action in the Registration.cfc handler

#### 8.4.1 - Pseudo Code our Create action
```js
function create( event, rc, prc ) {
    //insert the user

    relocate( uri = "/" );
}
```

#### 8.4.2 - To actually insert the User lets use the UserService

We need to inject the UserService into the handler. Add the following code to the top of the Registration.cfc handler.

```js
//handlers/Registration.cfc
property name="userService"		inject="UserService";
```

Reinit the framework so the injection is used.

#### 8.4.3 - Replace Psuedo Code with Real Code

Remove `//insert the user` and replace with

```js
userService.create( rc.email, rc.username, rc.password );
```

### 8.5 - Update UserService with a Create Method

Do not ever use a password that is un-encrypted, it is not secure, so lets use BCrypt. On ForgeBox, there is a module for that and easily installable with CommandBox.

#### 8.5.1 - Add [BCyrpt](https://github.com/coldbox-modules/cbox-bcrypt)

```sh
install bcrypt
```

### 8.5.2 - Inject Bcrypt into the UserService

Update the UserService to use BCrypt `/models/UserService.cfc`
We are adding the DI Injection for the BCrypt Module.

```js
component {

    property name="bcrypt" inject="@BCrypt";
```

#### 8.5.3 - Let's create the `create` method in the UserService

Create the `create` function, that has 3 arguments, and write the query, including wrapping the password in a call to bcrypt to encrypt the password.

```js
function create(
    required string email,
    required string username, 
    required string password
    ){
    return queryExecute( "
        INSERT INTO `users` ( `email`, `username`, `password` )
        VALUES ( ?, ?, ? )
    ",
        [ arguments.email, arguments.username, bcrypt.hashPassword( arguments.password ) ]
    );
}
```

#### 8.5.4

Hit the url: http://127.0.0.1:42518//registration/new and add a new user.
If you didn't reinit the framework, you will see the following error `Messages: variable [BCRYPT] doesn't exist` Dependency Injection changes require a framework init.

Now hit the url with frame reinit: http://127.0.0.1:42518//registration/new?fwreinit=1

Add a new user, and see that the password is now encrypted. Bcrypt encrypted passwords look like the following:

`$2a$12$/w/nkNrV6W6qqZBNXdqb4OciGWNNS7PCv1psej5WTDiCs904Psa8S`

#### 8.5.5

Check your tests, they should all pass again.

### 8.6 Complete the steps and Register yourself 

**SELF DIRECTED** (20 minutes)


## 9 - Build the Login & Logout Flow

### 9.1 - Build the Login Form

#### 9.1.1 - Install CBMessageBox via Commandbox

`install cbmessagebox`

#### 9.1.2 - Add the following into your existing `/config/Router.cfc` file

```js
// config/Router.cfc
function configure(){
    setFullRewrites( true );
    resources("registration");
    addRoute( "/login", "sessions", { "POST" = "create", "GET" = "new" } );
    delete( "/logout" ).to( "sessions.delete" );
	route( ":handler/:action?" ).end();
}
```

Hit the url: http://127.0.0.1:42518/login
You will see an error `Messages: The event: login is not a valid registered event.`
Changes to Routes require a framework reinit.

Hit the url: http://127.0.0.1:42518/login?fwreinit=1
You will now see an error `Messages: The event: Sessions.new is not a valid registered event.`

Now we'll build the sessions handler, and the new action.

#### 9.1.3 - Create a new `/handler/Sessions.cfc` handler
```js
// handlers/Sessions.cfc
component {

    property name="messagebox" inject="MessageBox@cbmessagebox";

    // new / login form page
    function new( event, rc, prc ) {
        return event.setView( "sessions/new" );
    }

}
```

Hit the url: http://127.0.0.1:42518/login
You will see an error `Messages: Page /views/sessions/new.cfm [YourAppPath\views\sessions\new.cfm] not found`


#### 9.1.4 - Create a new view `/views/sessions/new.cfm`

```html
// views/sessions/new.cfm
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

#### 9.1.5 - Hit `http://127.0.0.1:42518/login` in your browser
You can now see the login screen. Let's build the login action next.

### 9.2 - Build the Login Action

#### 9.2.1 - Install CBAuth and Configure

#### 9.2.2 - Install CBAuth

`install cbauth`

#### 9.2.3 - Config CBAuth - add this code to the Module Setting struct in the `/config/Coldbox.cfc` file.

Specify a userServiceClass in your `config/ColdBox.cfc` inside `moduleSettings.cbauth.userServiceClass.` This component needs to have three methods:
    isValidCredentials( username, password )
    retrieveUserByUsername( username )
    retrieveUserById( id )
Additionally, the user component returned by the retrieve methods needs to respond to getId().

https://www.forgebox.io/view/cbauth

```js
moduleSettings = {
    cbauth = {
        userServiceClass = "UserService"
    }
};
```

#### 9.2.4 - Create a User Object

Create a new Model `/models/User.cfc`

```js
component accessors="true" {

    property name="id";
    property name="username";
    property name="email";
    property name="password";

}
```

#### 9.2.5 - Update the User Service

We need to update our User Service for CBAuth to function. It requires 3 function.

**Explain `wirebox.getInstance` and `populator`**

Inject the new wirebox items into `/models/UserService.cfc`

```js
component {

    property name="populator" inject="wirebox:populator";
    property name="wirebox" inject="wirebox";
    property name="bcrypt" inject="@BCrypt";
```

Add the new methods to the `/models/UserService.cfc`

```js
    function retrieveUserById( id ) {
        return populator.populateFromQuery(
            wirebox.getInstance( "User" ),
            queryExecute( "SELECT * FROM `users` WHERE `id` = ?", [ id ] ),
            1
        );
    }

    function retrieveUserByUsername( username ) {
        return populator.populateFromQuery(
            wirebox.getInstance( "User" ),
            queryExecute( "SELECT * FROM `users` WHERE `username` = ?", [ username ] ),
            1
        );
    }

    function isValidCredentials( username, password ) {
        var users = queryExecute( "SELECT * FROM `users` WHERE `username` = ?", [ username ], { returntype = "array" } );
        if ( users.isEmpty() ) {
            return false;
        }
        return bcrypt.checkPassword( password, users[ 1 ].password );
    }
```

#### 9.2.6 - Update Sessions.cfc for login and logout actions

Update the `/handlers/Sessions.cfc` by injection cbauth

```js
// handlers/sessions.cfc
    property name="auth" inject="authenticationService@cbauth";
```

Update the `/handlers/Sessions.cfc` by adding new methods

```js
    // create / doLogin actLogin
    function create( event, rc, prc ) {
        try {
            auth.authenticate( rc.username, rc.password )
            return relocate( uri = "/" );
        }
        catch ( InvalidCredentials e ) {
            messagebox.setMessage( type = "warn", message = e.message );
            return relocate( uri = "/login" );
        }
    }

    // delete / logout
    function delete( event, rc, prc ) {
        auth.logout();
        return relocate( uri = "/" );
    }
```


#### 9.2.7 - Update the main layout to show and hide the register / login / logout buttons.

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

**Explain Interceptors via Modules**

### 9.3 - Refactor Registration to use the User Object

#### 9.3.1 - Update UserService `create` function to use User object

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
    user.setId( result.GENERATED_KEY );
    return user;
}
```

#### 9.3.2 - Update Registration.cfc handler to use User Object

Replace the Create function with the following

```js
// create / save User
function create( event, rc, prc ) {
    var user = populateModel( getInstance( "User" ) );
    userService.save( user );
    relocate( uri = "/login" );
}
```

**References**
* [`populateModel`](https://coldbox.ortusbooks.com/full/models/super_type_usage_methods#populatemodel())
* [`relocate`](https://coldbox.ortusbooks.com/full/event_handlers/relocating)

### 9.4 - Test the login and logout.

#### 9.4.1 - Test login and login

Hit the url: http://127.0.0.1:42518/?fwreinit=1

#### 9.4.2 - Auto login user when registering

When registering, it might be nice to automatically log the user in.
Replace the Create function with the following code

```js
property name="auth" inject="authenticationService@cbauth";

function create( event, rc, prc ) {
    var user = populateModel( getInstance( "User" ) );
    userService.save( user );
    auth.login( user );
    relocate( uri = "/" );
}
```

Now register and you will be automatically logged in.

#### 9.4.3 - Incorrect Logins are not user friendly

Login incorrectly and you'll see that the page is redirecting back tot he login page, but not showing an error message.

Let's use MessageBox to display messages where appropriate.


### 9.5 - Using and Configuring Messagebox

#### 9.5.1 - Let's update our main layout, Instead of

```html
<main role="main" class="container">
    #renderView()#
</main>
```

We need to add a line and make it look like below

```html
<main role="main" class="container">
    #getInstance( "MessageBox@cbmessagebox" ).renderIt()#
    #renderView()#
</main>
```

#### 9.5.2 - Reinit the framework, and test it out.

You should see an error message, but it is not the prettiest message ever. Next, we'll learn how to customize it.

#### 9.5.3 - Add to ColdBox Config as its own struct

```js
messagebox = {
    template = "/views/_partials/_messagebox.cfm"
};
```

#### 9.5.2 - Add `/views/_partials/_messagebox.cfm`

```html
<cfscript>
    switch( msgStruct.type ){
        case "info" : {
            local.cssType = " alert-info";
            local.iconType = "fas fa-info-circle";
            break;
        }
        case "error" : {
            local.cssType = " alert-danger";
            local.iconType = "far fa-frown";
            break;
        }
        default : {
            local.cssType = " alert-warning";
            local.iconType = "fas fa-exclamation-triangle";
        }
    }
</cfscript>
<cfoutput>
<div class="alert#local.cssType#" style="min-height: 38px">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <div class="row">
        <i class="#local.iconType# fa-2x pull-left"></i>
        <p class="col-10">#msgStruct.message#</p>
    </div>
</div>
</cfoutput>
```

#### 9.5.3 - Reinit Framework and test the output

Since the change was in the ColdBox.cfc in the config folder, we need to re-init to see the change.
When you login with incorrect username/details, you should see the style of the messagebox error has now changed.

## 10 - Rants

### 10.1 - Create rants migrations

```sh
migrate create create_rants_table
```

#### 10.1.1 - In the file that was created by the previous command, put this piece of code in there

```js
component {

    function up( schema ) {
        queryExecute( "
            CREATE TABLE `rants` (
                `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
                `body` TEXT NOT NULL,
                `createdDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                `modifiedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                `userId` INTEGER UNSIGNED NOT NULL,
                CONSTRAINT `pk_rants_id` PRIMARY KEY (`id`),
                CONSTRAINT `fk_rants_userId` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
            )
        " );
    }

    function down( schema ) {
        queryExecute( "DROP TABLE `rants`" );
    }

}
```

#### 10.1.2 - Now, migrate your rants

```
migrate up
```

### 10.2 - Create a Rant object in the models folder

```js
// Rant.cfc
component accessors="true" {

    property name="userService" inject="id";

    property name="id";
    property name="body";
    property name="createdDate";
    property name="modifiedDate";
    property name="userId";

    function getUser() {
        return UserService.retrieveUserById( getUserId() );
    }

}
```

### 10.3 - Create RantService.cfc

```js
component {

    property name="populator" inject="wirebox:populator";
    property name="wirebox"   inject="wirebox";

    function getAll() {
        return queryExecute(
            "SELECT * FROM `rants` ORDER BY `createdDate` DESC",
            [],
            { returntype = "array" }
        ).map( function ( rant ) {
            return populator.populateFromStruct(
                wirebox.getInstance( "Rant" ),
                rant
            );
        } );
    }

    function create( rant ) {
        rant.setModifiedDate( now() );
        queryExecute(
            "
                INSERT INTO `rants` (`body`, `modifiedDate`, `userId`)
                VALUES (?, ?, ?)
            ",
            [
                rant.getBody(),
                { value = rant.getModifiedDate(), cfsqltype = "CF_SQL_TIMESTAMP" },
                rant.getUserId()
            ],
            { result = "local.result" }
        );
        rant.setId( result.GENERATED_KEY );
        return rant;
    }

}
```

### 10.4 - Rants CRUD

#### 10.4.1 - Add the rants resources in the `Router.cfc` file

```js
// config/Router.cfc
resources( "rants" );
```

#### 10.4.2 - Create a rants handler

```js
// handlers/rants.cfc
component {

    property name="RantService" inject="id";

    function index( event, rc, prc ) {
        prc.rants = rantService.getAll();
        event.setView( "rants/index" );
    }

    function new( event, rc, prc ) {
        event.setView( "rants/new" );
    }

    function create( event, rc, prc ) {
        rc.userId = auth().getUserId();
        var rant = populateModel( getInstance( "Rant" ) );
        rantService.create( rant );
        relocate( "rants" );
    }

}
```

#### 10.4.3 - Create an index view

```html
// views/rants/index.cfm
<cfoutput>
    <cfif prc.rants.isEmpty()>
        <h3>No rants yet</h3>
        <a href="#event.buildLink( "rants.new" )#">Start one now!</a>
    <cfelse>
        <a href="#event.buildLink( "rants.new" )#" class="btn btn-link">Start a new rant!</a>
        <cfloop array="#prc.rants#" item="rant">
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

#### 10.4.4 - Set the default event to `rants.index`

```js
// inside the coldbox struct
coldbox = {
    defaultEvent = "rants.index",
    ...
};
```

Hit http://127.0.0.1:42518/ and you'll see the main.index with the dump. ColdBox settings require a framework reinit.

Reinit the framework, then you'll see the Rant index.

#### 10.4.5 - Create a new view

```html
// views/rants/new.cfm
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

#### 10.4.6 - Update the main layout

```html
// layouts/Main.cfm
<div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav">
        <li><a href="#event.buildLink( "rants.new" )#" class="nav-link">Start a Rant</a></li>
    </ul>
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
</div>
```

Hit http://127.0.0.1:42518/ and click on Start a rant and you'll see the form.
Log out and try, and you can still see the form. Try to create a rant and you'll see an error!
We need to secure the form, to ensure the user is logged in before they can send a rant.


## 11 - Install cbsecurity by running the following command

```sh
install cbsecurity
```

### 11.1 - Configure cbsecurity, add the settings in your `ColdBox.cfc` as a root level struct

```js
// config/ColdBox.cfc

cbsecurity = {
    rulesFile = "/config/security.json",
    rulesSource = "json",
    validatorModel = "UserService"
};
```

### 11.2 - Create a `security.json` file inside the config folder
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
### 11.3 - Create the userValidator function in `UserService.cfc`

```js
// models/UserService.cfc

property name="authenticationService" inject="AuthenticationService@cbauth";

function userValidator( rule, controller ) {
    return authenticationService.isLoggedIn();
}
```

### 11.4 - Reinit the framework

### 11.5 - Hit the page while logged out. if you hit `start a rant` link, you should redirect to the login page

### 11.6 - Now log in and make sure you see the rant page.


## 12 - View a user's rants
### 12.1 - Create a users profile page, for that we need to create a route in our `Router.cfc` file

```js
// config/Router.cfc
get( "/users/:username" ).to( "users.show" );
```


### 12.2 - Create a `users` handler

```js
// handlers/users.cfc
component {

    property name="userService" inject="id";

    function show( event, rc, prc ) {
        prc.user = userService.retrieveUserByUsername( rc.username );
        if ( prc.user.getId() == "" ) {
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
property name="rantService" inject="id";
```

#### 12.7.2 - Create a getRants function

```js
function getRants() {
    return rantService.getForUserId( getId() );
}
```

#### 12.7.3 - Create a `getForUserId` function in `RantService`

```js
function getForUserId( id ) {
    return queryExecute(
        "SELECT * FROM `rants` WHERE `userId` = ? ORDER BY `createdDate` DESC",
        [ id ],
        { returntype = "array" }
    ).map( function ( rant ) {
        return populator.populateFromStruct(
            wirebox.getInstance( "Rant" ),
            rant
        );
    } );
}
```

### 12.8 - Reinitialize the application

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

```js
// models/services/ReactionService.cfc
component {

    property name="populator" inject="wirebox:populator";
    property name="wirebox" inject="wirebox";

    function getBumpsForRant( rant ) {
        return queryExecute(
            "SELECT * FROM `bumps` WHERE `rantId` = ?",
            [ rant.getId() ],
            { returntype = "array" }
        ).map( function( bump ) {
            return populator.populateFromStruct(
                wirebox.getInstance( "Bump" ),
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
                wirebox.getInstance( "Poop" ),
                bump
            )
        } );
    }

}
```

#### 13.5.2 - Inject reactionService and create the following functions

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

### 15.2 - Update your `User.cfc`, inject the reactionService and add the following functions

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
            wirebox.getInstance( "Bump" ),
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
            wirebox.getInstance( "Poop" ),
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
