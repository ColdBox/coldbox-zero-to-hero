(All commands assume we are in the `box` shell unless stated otherwise.)

1.  Create a folder for your app on your hard drive called `soapbox`.
2.  Scaffold out a new Coldbox application with TestBox included.

```sh
coldbox create app soapbox --installTestBox
```

3.  Start up a local server

```sh
start port=42518
```

4.  Open `http://localhost:42518/` in your browser. You should see the default ColdBox app template.

5.  Open `/tests` in your browser. You should see the TestBox test browser.
    This is useful to find a specific test or group of tests to run _before_ running them.

6.  Open `/tests/runner.cfm` in your browser. You should see the TestBox test runner for our project.
    This is running all of our tests by default. We can create our own test runners as needed.

All your tests should be passing at this point. 😉

7.  Show routes file. Explain routing by convention.
8.  Show `Main.index`.
9.  Explain `event`, `rc`, and `prc`.
10. Explain views. Point out view conventions.
11. Briefly touch on layouts.
12. Show how `rc` and `prc` are used in the views.

13. Add an about page
    a. Add an `views/about/index.cfm`. Hit the url /about/index and it works!
    b. Add an `about` handler. Use a non existing view and see if it breaks. Talk about reinits.
    c. Add an `index` action. Back to working!

Reinits
What is cached?

*   Singletons

14. Copy in simple bootstrap theme / layout to replace the existing main.cfm layout.

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

Insert the following CSS into a new file: /includes/css/app.css
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

15. Install [commandbox-migrations](https://www.forgebox.io/view/commandbox-migrations)

```sh
install commandbox-migrations
```

You should see a list of available commands with `migrate ?`.

16. Initalize migrations using `migrate init`

17. Change the grammar in your box.json to `MySQLGrammar`

(Bonus. Not needed since we are using `queryExecute` directly.)

```sh
package set cfmigrations.defaultGrammar=MySQLGrammar
```

17. Install [commandbox-dotenv](https://www.forgebox.io/view/commandbox-dotenv)

18. Create a `/.env` file. Fill it in appropraitely. (We'll fill it in with our
    Docker credentials from before.)

```
DB_CLASS=org.gjt.mm.mysql.Driver
DB_CONNECTIONSTRING=jdbc:mysql://localhost:3306/soapbox?useUnicode=true\&characterEncoding=UTF-8\&useLegacyDatetimeCode=true
DB_USER=root
DB_PASSWORD=soapbox
```

19. Reload your shell in your project root. (`reload` or `r`)

20. Install cfmigrations using `migrate install`. (This will also test that you can connect to your database.)

21. Create a users migration

```sh
migrate create create_users_table
```

22. Fill in the migration. 
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

23. Run the migration up.

```sh
migrate up
```

QB will be optional

24. Install `qb`

```sh
install qb
```

25. Configure `qb` 

Add the following settings to your `/config/Coldbox.cfc` file. You can place this modules setting struct under the settings struct.

```js
// config/ColdBox.cfc
moduleSettings = {
    qb = {
        defaultGrammar = "MySQLGrammar"
    }
};
```

Next add the following settings into your `/Application.cfc` file.

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

26. Play around grabbing data from the database using queryExecute and  `qb` for bonus points.

```
// handlers/Main.cfc

// property name="query" inject="provider:QueryBuilder@qb";

function index( event, rc, prc ) {
    // prc.users = query.from( "users" ).get();
    prc.users = queryExecute( "SELECT * FROM users", {}, { returntype = "array-of-entities" } );
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

27. Start Register flow. The next series of steps will build the Register flow, including BDD and TDD.

28. Delete the MainBDDTest

29. Install `cfmigrations` as a dev dependency. `install cfmigrations --saveDev`

30. Configure `tests/Application.cfc`

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

31. Create a `tests/resources/BaseIntegrationSpec.cfc`

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

32. Create a `tests/specs/integration/RegistrationSpec.cfc`

```
component extends="tests.resources.BaseIntegrationSpec" {

    function run() {
        describe( "registration", function() {
            it( "can register a user", function() {
                fail( "test not implemented yet" );
            } );
        } );
    }

}
```

33. Fill in the test

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

34. Write the production code

```
// config/Routes.cfm

resources("registration");
```

```
// handlers/registration.cfc
component {

    property name="query" inject="provider:QueryBuilder@qb";

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

35. Create a route to populate this form

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

36. Add a register link to the navbar

```html
<div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav ml-auto">
        <a href="#event.buildLink( "registration.new" )#" class="nav-link">Register</a>
    </ul>
</div>
```

Bonus points for tests first for next part

37. Add [BCyrpt](https://github.com/coldbox-modules/cbox-bcrypt)

```sh
install bcyrpt
```

38. Bcrypt the password

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

39. Try it again (will probably want a migrate fresh)

TODO: We probably want a WireBox intro somewhere. Just the basics. Breeze past most of it.

Add log in

```
// config/Routes.cfm
addRoute( "/login", "sessions", { "GET" = "new", "POST" = "create" } );
addRoute( "/logout", "sessions", { "DELETE" = "delete" } );
```

```
// handlers/sessions.cfc
component {

    property name="messagebox" inject="MessageBox@cbmessagebox";

    function new( event, rc, prc ) {
        return event.setView( "sessions/new" );
    }

    function create( event, rc, prc ) {
        try {
            auth().authenticate( rc.username, rc.password )
            return relocate( uri = "/" );
        }
        catch ( InvalidCredentials e ) {
            messagebox.setMessage( type = "warn", message = e.message );
            return relocate( uri = "/login" );
        }
    }

    function delete( event, rc, prc ) {
        auth().logout();
        return relocate( uri = "/" );
    }

}
```

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

40. Create rants migrations

```
migrate create create_rants_table
```

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

41. Create a Rant object

```
// Rant.cfc
component accessors="true" {

    property name="UserService" inject="id";

    property name="id";
    property name="body";
    property name="createdDate";
    property name="modifiedDate";
    property name="userId";

    function getUser() {
        return userSerivce.retrieveUserById( getUserId() );
    }

}
```

42. Create RantService.cfc

```
component {

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
                INSERT INTO `rants` (`body`, `updatedDate`, `userId`)
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

43. Rants CRUD

```
// config/routes.cfm
resources( "rants" );
```

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

cbsecurity

```
install cbsecurity
```

Configure

```
// config/ColdBox.cfc

cbsecurity = {
    rulesFile = "/config/security.json",
    rulesSource = "json",
    validatorModel = "UserService"
};
```

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

```
// models/services/UserService.cfc

property name="authenticationService" inject="AuthenticationService@cbauth";

function userValidator( rule, controller ) {
    return authenticationService.isLoggedIn();
}
```

View a user's rants

Create a users profile page

```
// config/Routes.cfm
addRoute( "/users/:username", "users", { "GET" = "show" } );
```

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

```
// views/404.cfm
Whoops!  That page doesn't exist.
```

```
// views/users/show.cfm
<cfoutput>
    <h1>#prc.user.getUsername()#</h1>
    <h4>Rants</h4>
    <ul>
        <cfloop array="#prc.user.getRants()#" item="rant">
            #renderView( "partials/_rant", { rant = rant } )#
        </cfloop>
    </ul>
</cfoutput>
```

```
// views/partials/_rant.cfm
<cfoutput>
    <div class="card mb-3">
        <div class="card-header">
            <strong><a href="#event.buildLink( "users.#args.rant.getUser().getId()#" )#">#args.rant.getUser().getUsername()#</a></strong>
            said at #dateTimeFormat( args.rant.getCreatedDate(), "h:nn:ss tt" )#
            on #dateFormat( args.rant.getCreatedDate(), "mmm d, yyyy")#
        </div>
        <div class="panel card-body">
            #args.rant.getBody()#
        </div>
    </div>
</cfoutput>
```

(Also use the partial in `rants/index`)

Link to the user from `partials/_rant`

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

Add 👊 and 💩 actions

```
migrate create create_bumps_table
```

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

```
migrate create create_poops_table
```

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

Display bumps on the rant partial

```
// /views/partials/_rant.cfm

<div class="card-footer">
    <button class="btn btn-outline-dark">
        #args.rant.getBumps().len()# 👊
    </button>
    <button class="btn btn-outline-dark">
        #args.rant.getPoops().len()# 💩
    </button>
</div>
```

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

Make buttons clickable

```
// views/partials/_rant.cfm

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
