
### Steps to go from ColdBox Zero to Hero

(All commands assume we are in the `box` shell unless stated otherwise.)

## 1 - Create the base app

1.1.  Create a folder for your app on your hard drive called `soapbox`.
1.2  Scaffold out a new Coldbox application with TestBox included.

```sh
coldbox create app soapbox --installTestBox --installColdBoxBE
```

1.3  Start up a local server

```sh
start cfengine=lucee@5 port=42518
```

1.4 Open `http://localhost:42518/` in your browser. You should see the default ColdBox app template.

1.5 Open `/tests` in your browser. You should see the TestBox test browser.
    This is useful to find a specific test or group of tests to run _before_ running them.

1.6 Open `/tests/runner.cfm` in your browser. You should see the TestBox test runner for our project.
    This is running all of our tests by default. We can create our own test runners as needed.

All your tests should be passing at this point. 😉

## 2 - MVC - Routes, Handlers, Views
2.1 Show routes file. Explain routing by convention.
2.2 Show `Main.index`.
2.3 Explain `event`, `rc`, and `prc`.
2.4 Explain views. Point out view conventions.
2.5 Briefly touch on layouts.
2.6 Show how `rc` and `prc` are used in the views.

2.7 Add an about page<br>

* 2.7.1 Add an `views/about/index.cfm`. Hit the url /about/index and it works!
```html
<cfoutput>
    <h1>About us!</h1>
</cfoutput>
```
* 2.7.2 Add an `about` handler. Use a non existing view and see if it breaks. Talk about reinits.
* 2.7.3 Add an `index` action. Back to working!

2.8 Reinit the framework
* What is cached?

*   Singletons

## 3 - Layouts

3.1. Copy in simple bootstrap theme / layout to replace the existing main.cfm layout.

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

3.2 Insert the following CSS into a new file: `/includes/css/app.css`
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

4.1. Install [commandbox-migrations](https://www.forgebox.io/view/commandbox-migrations)

```sh
install commandbox-migrations
```

You should see a list of available commands with `migrate ?`.

4.2 Initalize migrations using `migrate init`

4.3 Install [commandbox-dotenv](https://www.forgebox.io/view/commandbox-dotenv)

4.4 Create a `/.env` file. Fill it in appropraitely. (We'll fill it in with our
    Docker credentials from before.)

```
DB_CLASS=org.gjt.mm.mysql.Driver
DB_CONNECTIONSTRING=jdbc:mysql://localhost:3306/soapbox?useUnicode=true\&characterEncoding=UTF-8\&useLegacyDatetimeCode=true\&useSSL=false
DB_USER=root
DB_PASSWORD=soapbox
```

4.5 Reload your shell in your project root. (`reload` or `r`)

4.6 Install cfmigrations using `migrate install`. (This will also test that you can connect to your database.)

4.7 Create a users migration

```sh
migrate create create_users_table
```

4.8 Fill in the migration.
The migration file was created by the last command, and the file location was output by commandbox.

```
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

4.9 Run the migration up.

```sh
migrate up
```

4.11.2 Next add the following settings into your `/Application.cfc` file.

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

4.11.3 Play around grabbing data from the database using queryExecute and  `qb` for bonus points.

Discuss WireBox and Dependency Injection.

```
// handlers/Main.cfc

// property name="query" inject="provider:QueryBuilder@qb";

function index( event, rc, prc ) {
    // prc.users = query.from( "users" ).get();
    prc.users = queryExecute( "SELECT * FROM users", {}, { returntype = "array" } );
    event.setView( "main/index" );
}
```

```html
// views/Main/index.cfm

<cfoutput>
    <cfdump var="#prc.users#" label="users" />
</cfoutput>
```
Insert data directly in to the database and show it returning.
Notice the return type. This is a Lucee 4.5 syntax. CF11+ and Lucee5+ use `returnformat="array"`

## 5 - Building the Registration Flow

Start Register flow. The next series of steps will build the Register flow, including BDD and TDD.

5.1 Delete the MainBDDTest

5.2 Install `cfmigrations` as a dev dependency. `install cfmigrations --saveDev`

5.3 Configure `tests/Application.cfc`

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

5.4 Create a `tests/resources/BaseIntegrationSpec.cfc`

```
component extends="coldbox.system.testing.BaseTestCase" {

    property name="migrationService" inject="MigrationService@cfmigrations";

    this.loadColdBox = true;
    this.unloadColdBox = false;

    function beforeAll() {
        super.beforeAll();
        application.wirebox.autowire( this );
        if ( ! request.keyExists( "migrationsRan" ) ) {
            migrationService.setMigrationsDirectory( "/root/resources/database/migrations" );
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

5.5 Create a `tests/specs/integration/RegistrationSpec.cfc`

```
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

5.6 Replace the `can register a user` test with the following

```
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

5.7 Write the production code

Update the `/config/Routes.cfm` file - insert a resources definition.
```
// config/Routes.cfm

resources("registration");
```

Create a new Handler
```
// handlers/Registration.cfc
component {

    function create( event, rc, prc ) {
        queryExecute( "
                INSERT INTO `users` ( `email`, `username`, `password` )
                VALUES ( ?, ?, ? )
            ",
            [ rc.email, rc.username, rc.password ]
        );

        relocate( uri = "/" );
    }

}
```

5.8 Create a route to populate this form

```js
function new( event, rc, prc ) {
    return event.setView( "registration/new" );
}
```

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

5.9 Add a register link to the navbar

```html
<div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav ml-auto">
        <a href="#event.buildLink( "registration.new" )#" class="nav-link">Register</a>
    </ul>
</div>
```
The Nav bar is located in our Layout file `/layouts/Main.cfm`. Insert the code above, into the `<nav>` tag, before the closing `</nav>` .

Refresh your page, click Registration and fill out the form. Your new user will be listed in your dump.
This isn't very secure, to have your password un-encrypted, so lets use BCrypt.

Bonus points for tests first for next part

5.10 Add [BCyrpt](https://github.com/coldbox-modules/cbox-bcrypt)

```sh
install bcrypt
```

5.11 Bcrypt the password

Update the registration handler to use BCrypt `/handlers/Registration.cfc`
We are adding the DI Injection for the BCrypt Module and updating the query to wrap the password in a call to bcrypt to encrypt the password.

```
component {

    property name="bcrypt" inject="@BCrypt";

    function create( event, rc, prc ) {
        queryExecute( "
                INSERT INTO `users` ( `email`, `username`, `password` )
                VALUES ( ?, ?, ? )
            ",
            [ rc.email, rc.username, bcrypt.hashPassword( rc.password ) ]
        );

        relocate( uri = "/" );
    }
}
```

5.12 Add a new user, and see that the password is now encrypted. Bcrypt encrypted passwords look like the following:

`$2a$12$/w/nkNrV6W6qqZBNXdqb4OciGWNNS7PCv1psej5WTDiCs904Psa8S`

## 6 - Build the Login & Logout Flow

6.1 - Install CBMessageBox via Commandbox

`install cbmessagebox`

6.2 - Add the following into your existing `/config/Routes.cfm` file
```
// config/Routes.cfm
addRoute( "/login", "sessions", { "POST" = "create", "GET" = "new" } );
delete( "/logout" ).to( "sessions.delete" );
```

6.3 Create a new `/handler/Sessions.cfc` handler
```
// handlers/sessions.cfc
component {

    property name="messagebox" inject="MessageBox@cbmessagebox";

    // new / login form page
    function new( event, rc, prc ) {
        return event.setView( "sessions/new" );
    }

}
```

6.4 Create a new view `/views/sesions/new.cfm`
```
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

6.5 Once all of these changes have been made. Reinit the app to update the routes. ( 'http://127.0.0.1:42518/login?fwreinit=1' )

6.6 Hit `http://127.0.0.1:42518/login` in your browser
You can now see the login screen. Let's build the login action next.

6.7 Install CBAuth and Configure

6.7.1 Install CBAuth

`install cbauth`

6.7.2 Config CBAuth - add this code to the Module Setting struct in the `/config/Coldbox.cfc` file.

```
moduleSettings = {
    cbauth = {
        userServiceClass = "UserService"
    }
};
```

6.8 - Create a User Service and User Object

Specify a userServiceClass in your config/ColdBox.cfc inside moduleSettings.cbauth.userServiceClass. This component needs to have three methods:
    isValidCredentials( username, password )
    retrieveUserByUsername( username )
    retrieveUserById( id )
Additionally, the user component returned by the retrieve methods needs to respond to getId().

https://www.forgebox.io/view/cbauth

Create a new Model `/models/User.cfc`
```
component accessors="true" {

    property name="id";
    property name="username";
    property name="email";
    property name="password";

}
```

6.9 - Create the User Service

We need to create a User Service for CBAuth to function. It requires 3 function.
Create a new model in `/models/UserService.cfc`
Explain `wirebox.getInstance` and `populator`
```
component {

    property name="populator" inject="wirebox:populator";
    property name="wirebox" inject="wirebox";
    property name="bcrypt" inject="@BCrypt";

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

}
```

6.10 - Update Sessions.cfc for login and logout actions

Update the Sessions.cfc
```
// handlers/sessions.cfc
    property name="auth" inject="authenticationService@cbauth";

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

6.11
Update the main layout to show and hide the register / login / logout buttons.

```
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

6.12 - Refactor Registration to use the User Service

Add save function to User Service.
```
function save( user ) {
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

6.13 - Update Registration.cfc handler to use User Service instead of inline queryExecute

Add the DI Injection for the UserService

`property name="userService" inject="UserService";`

Replace the Create function with the following
```
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

6.14 - Test the login and logout.

When registering, it might be nice to automatically log the user in.
Replace the Create function with the following code

```
property name="auth" inject="authenticationService@cbauth";

function create( event, rc, prc ) {
    var user = populateModel( getInstance( "User" ) );
    userService.save( user );
    auth.login( user );
    relocate( uri = "/" );
}
```
Now register and you will be automatically logged in.

6.15 - Login incorrectly and you'll see an error message.
Use this snippet to make MessageBox prettier.

6.15.1 - Add to ColdBox Config as its own struct
```
messagebox = {
    template = "/views/_partials/_messagebox.cfm"
};
```

6.15.2 - Add `/views/_partials/_messagebox.cfm`
```
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
6.15.4 Let's update our main layout, Instead of
```
<main role="main" class="container">
    #renderView()#
</main>
```

we need to add a line and make it

```
<main role="main" class="container">
    #getInstance( "MessageBox@cbmessagebox" ).renderIt()#
    #renderView()#
</main>
```

6.15.5 Reinit the framework, and test it out.

## 7 - Rants

7.1 Create rants migrations

```
migrate create create_rants_table
```

7.1.1 In the file that was created by the previous command, put this piece of code in there
```
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
7.1.2 Now, migrate your rants

```
migrate up
```


7.2 Create a Rant object in the models folder

```
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

7.3 Create RantService.cfc

```
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

    function save( rant ) {
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

7.4 Rants CRUD

7.4.1 Add the rants resources in the `routes.cfm` file

```
// config/routes.cfm
resources( "rants" );
```

7.4.2 Create a rants handler

```
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
        rantService.save( rant );
        relocate( "rants" );
    }

}
```

7.4.3 Create an index view

```
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

7.4.4 Set the default event to `rants.index`
```
coldbox = {
    defaultEvent = "rants.index"
};
```

7.4.5 Create a new view

```
// views/rants/new.cfm
<cfoutput>
    <div class="card">
        <h4 class="card-header">Start a Rant</h4>
        <form class="form panel card-body" method="POST" action="#event.buildLink( "rants" )#">
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

7.4.6 Update the main layout

```
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

7.5 Install cbsecurity by running the following command

```
install cbsecurity
```

7.5.1 Configure cbsecurity, add the settings in your `ColdBox.cfc` as a root level struct

```
// config/ColdBox.cfc

cbsecurity = {
    rulesFile = "/config/security.json",
    rulesSource = "json",
    validatorModel = "UserService"
};
```

7.6 Create a `security.json` file inside the config folder
```
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

7.7 Create the userValidator function in `UserService.cfc`

```
// models/services/UserService.cfc

property name="authenticationService" inject="AuthenticationService@cbauth";

function userValidator( rule, controller ) {
    return authenticationService.isLoggedIn();
}
```

7.8 Reinit the framework

7.9 Hit the page while logged out. if you hit `start a rant` link, you should redirect to the login page

7.10 Now log in and make sure you see the rant page.

## 8 - View a user's rants

8.1 Create a users profile page, for that we need to create a route in our `Routes.cfm` file

```
// config/Routes.cfm
get( "/users/:username" ).to( "users.show" );
```

8.2 Create a `users` handler

```
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
8.3 Create a `404.cfm` view

```
// views/404.cfm
Whoops!  That page doesn't exist.
```

8.4 Create a `show.cfm` view
```
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

8.5 Create a `views/_partials/_rant.cfm` view
```
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

8.6 Edit the `views/rants/index.cfm` file and replace the content of the loop to render the `_partials/_rant` view

```
<cfloop array="#prc.rants#" item="rant">
    #renderView( "_partials/_rant", { rant = rant } )#
</cfloop>
```

8.7 Update your `User.cfc`
8.7.1 Inject the rantService
```
property name="rantService" inject="id";
```
8.7.2 Create a getRants function
```
function getRants() {
    return rantService.getForUserId( getId() );
}
```

8.7.2 Create a `getForUserId` function in `RantService`

```
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

8.8 Reinitialize the application

8.9 Test it out in the browser

## 9. Add 👊 and 💩 actions

9.1.1 Migrate `bumps` table

```
migrate create create_bumps_table
```

9.1.2 Fill the file you just create with the following functions

```
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

9.2.1 Migrate `poops` table
```
migrate create create_poops_table
```

9.2.2 Fill the file you just create with the following functions

```
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

9.3 Now run the function `up`

```
migrate up
```

9.4 Display bumps on the rant partial, add this footer in `/views/_partials/_rant.cfm`

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

9.5 Update `Rant.cfc`

9.5.1 Create `ReactionService.cfc` in `models/services/`

```
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

9.5.2 Inject reactionService and create the following functions

```
// models/Rant.cfc

property name="reactionService" inject="id";

function getBumps() {
    return reactionService.getBumpsForRant( this );
}

function getPoops() {
    return reactionService.getPoopsForRant( this );
}
```

9.6 Reinitialize the framework

9.7 Try the site, and realize its broken, but why?

```
Event: rants.index
Routed URL: rants/
Layout: N/A (Module: )
View: N/A
Timestamp: 04/13/2018 09:54:07 AM
Type: Builder.DSLDependencyNotFoundException
Messages: The DSL Definition {REF={null}, REQUIRED={true}, ARGNAME={}, DSL={id}, JAVACAST={null}, NAME={reactionService}, TYPE={any}, VALUE={null}, SCOPE={variables}} did not produce any resulting dependency The target requesting the dependency is: 'Rant'
```

This is a WireBox DSL injection error. Saying the RANT module is having trouble asking for the

## 10 - Wirebox Conventions vs Configuration

Dependency Injection is Magic - Not really

Did you notice anything different when we create my Service??
We created a services folder inside of Models, to organize our Models better.

Wirebox is very powerful, but it is not magic, it runs by conventions, and you can configure it to run differently if you have differing opinions on the conventions.

So you have to tell it what you want it to do if you want to do something more. In this case, instead of just using model paths (automatic convention), we can tell Wirebox to map models and all of its subfolders.

10.1 Open the WireBox.cfc

10.2 Scroll to the bottom of the file and insert the following

```
// Map Bindings below
mapDirectory( "models" );
```

This will make the models folder recursively, now allowing you to organize your folders however you see fit.

10.3 Reinitialize the framework

10.4 Test out the site... no errors now.

## 11 - Make Rant Reactions Functional

11.1 Make buttons clickable

11.1.1 Update your `_rant.cfm`

```
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

11.2 Update your `User.cfc`, inject the reactionService and add the following functions

```
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

11.3 Update your `ReactionService.cfc`, add the following functions

```
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

11.4 Create new handlers

11.4.1 Add the routes before the resources

```
addRoute( "rants/:id/bumps", "Bumps", { "POST" = "create", "DELETE" = "delete" } );
addRoute( "rants/:id/poops", "Poops", { "POST" = "create", "DELETE" = "delete" } );
```

11.4.2 Create `bumps` handler

```
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

11.4.3 Create `poops` handler

```
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

11.5 Update your `ReactionService.cfc` with the following functions

```
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

11.9 Add the Bump Model

```
// models/Bump.cfc
component accessors="true" {

    property name="userId";
    property name="rantId";

}
```

11.10 Add the Poop Model

```
// models/Poop.cfc
component accessors="true" {

    property name="userId";
    property name="rantId";

}
```

11.11 Reinialize the Framework and Test the Site

11.12 - You're done!!

12 - Extra Credit

+ Don't let a user poop and bump the same rant
+ CSRF tokens for login, register, and new rant
+ Move `queryExecute` to `qb`

Other Ideas:
+ Environments in ColdBox.cfc
+ Domain Names in CommandBox

11.1 Install `qb`

```sh
install qb
```

11.2 Configure `qb`

11.2.1 Add the following settings to your `/config/Coldbox.cfc` file. You can place this modules setting struct under the settings struct.

```js
// config/ColdBox.cfc
moduleSettings = {
    qb = {
        defaultGrammar = "MySQLGrammar"
    }
};
```
