# 6 - Intro to Models

Models are at the core of ColdBox. We could teach you how to write legacy style code, but we want to teach the `right` way from the start. We still start with creating a `User Service` that will be managing users in our SoapBox.  We will be also using this service to provide authentication capabilities to our application once we secure it with [CBSecurity](https://forgebox.io/view/cbsecurity).

What we need now is the following story: `I want to be able to list all users in my system`. This is our requirement, so let's scaffold what we need via CommandBox.

```bash
coldbox create model name="UserService" methods="list" persistence="singleton"
```

This  will create the `UserService.cfc` in the `models` folder and a companion **unit** test in `tests/specs/unit/UserServiceTest.cfc`.  Use `ctrl|cmd + click` to open the files in your terminal in VScode.

## BDD - Let's write our tests first

Open up the test `/tests/specs/unit/UserServiceTest.cfc` and this is what we will see:

```js
function run() {
    describe( "UserService Suite", function(){

        it( "should list", function(){
            expect( false ).toBeTrue();
        });


    });
}
```

Hit the url: http://127.0.0.1:42518/tests/runner.cfm to run your tests. The test will run and fail as expected. As we use BDD we will write the real test.

## Watchers

Let's start another test watcher, but this time let's limit it to JUST execute the bundle we are working on:

```bash
testbox watch bundles="tests.specs.unit.UserServiceTest" recurse=false
```

The `bundles` argument can pinpoint which test bundle to execute, the `recurse` is needed so it doesn't execute anything else.

> Hint: Use `testbox watch ?` to get help around this useful command

## Mind Focus

We want to write two specifications:

1. One that verifies that the component compiles and can be created
2. One that satisfies our original story: `I want to be able to list all users in my system`

```js
function run() {

    describe( "User Service", function() {

        it( "can be created", function(){
            expect( model ).toBeComponent();
        });

        it( "can list all users", function() {
            fail( "coming soon." );
        } );

    } );

}
```

Run your tests `/tests/runner.cfm`

## Lets create the `list()` function

As of now, since we don't have any data in our database, let's just think about what this list should do and the expected result.

```js
it( "can list all users", function() {
    var aResults = model.list();
    expect( aResults ).toBeArray();
} );
```

Lets create the `list()` function in the service now:

```js
function list(){
    return "";
}
```

Ok, what was wrong?  Types are wrong, ok, let's fix it with what we will expect:

## Querying our Database

```js
function list(){
    return queryExecute( "select * from users", {}, { returntype = "array" } );
}
```

Run the tests, and the test should pass.

> Note: There might be the case that the server does not have the datasource defined yet.  Just do a `server restart` and it should absorb the changes in your `.env`.

## Mock Data Seeders

Ok, we tested with no data, so why not create some mock data. Let's create a database seeder we can use to populate our database with mock/fake data so our tests can cover those scenarios.

> Hint: Our mock generator is called `MockdataCFC` and is bundled with our `cfmigrations` and also with `TestBox`: https://github.com/ortus-solutions/mockdatacfc

Go to the shell and execute our seeder creation:

```bash
migrate seed create TestFixtures
```

Open the seeder: [resources/database/seeds/TestFixtures.cfc](../src/resources/database/seeds/TestFixtures.cfc).  The seeder method `run()` receives an instance of `qb` and `mockdata` so we can use for building out our database.

```js
component {

	// The bcrypt equivalent of the word test.
	bcrypt_test = "$2a$12$5d31nX1hRnkvP/8QMkS/yOuqHpPZSGGDzH074MjHk6u2tYOG5SJ5W";

    function run( qb, mockdata ) {
        qb.table( "users" ).insert(
			mockdata.mock(
                $num = 25,
                "id": "autoincrement",
                "name": "name",
                "email": "email",
                "password": "oneOf:#bcrypt_test#"
            )
		);
    }

}
```

This will populate the `users` table with 25 mocked users.  Please note that we use a `bcrypt_test`, this is the bcrypt equivalent of the word `test`.  How did we generate that?  Well here is a great online bcrypt generator: https://bcrypt.online/

To run this seeder, just do:

```bash
migrate seed run **TestFixtures**
```

And now we got data, verify the database that these records where created.

## Automated Seeding

Now that we know our seeder works and we can add data to our database for testing, let's automate it in our test harness.  Open the `BaseIntegrationSpec.cfc` and let's remove all the code concering the migrations.  We will refactor this to the `/tests/Application.cfc` so it's done once per test run.  The final code should be:

```js
/**
 * Base test bundle for our application
 *
 * @see https://coldbox.ortusbooks.com/testing/testing-coldbox-applications/integration-testing
 */
component extends="coldbox.system.testing.BaseTestCase" autowire {

	/**
	 * --------------------------------------------------------------------------
	 * Dependency Injections
	 * --------------------------------------------------------------------------
	 */

	/**
	 * --------------------------------------------------------------------------
	 * Integration testing controls
	 * --------------------------------------------------------------------------
	 * - We want the ColdBox virtual application to load once per request and get destroyed at the end of the request.
	 */
	this.loadColdBox   = true;
	this.unloadColdBox = false;

	/**
	 * Run Before all tests
	 */
	function beforeAll(){
		super.beforeAll();
	}

	/**
	 * This function is tagged as an around each handler.  All the integration tests we build
	 * will be automatically rolledbacked so we don't corrupt the database with our tests
	 *
	 * @aroundEach
	 */
	function wrapInTransaction( spec ){
		transaction action="begin" {
			try {
				arguments.spec.body( argumentCollection = arguments );
			} catch ( any e ) {
				rethrow;
			} finally {
				transaction action="rollback";
			}
		}
	}

}
```

Now let's open the [`tests/Application.cfc`](../src/tests/Application.cfc) and let's add our migrations code by adding a new private function called `seedDatabase()`:

```js
private function seedDatabase(){
    var controller       = request.coldBoxVirtualApp.getController();
    var migrationService = controller
        .getWireBox()
        .getInstance(
            name         : "MigrationService@cfmigrations",
            initArguments: {
                migrationsDirectory : "/root/resources/database/migrations",
                seedsDirectory      : "/root/resources/database/seeds",
                properties          : {
                    datasource     : "soapbox",
                    defaultGrammar : "AutoDiscover@qb",
                    schema         : "soapbox"
                }
            }
        );

    var sTime = getTickCount();
    systemOutput( "Refreshing Database...", true );
    migrationService.reset();
    migrationService.install( runAll: true );
    systemOutput( "Database Refreshed in #numberFormat( getTickCount() - sTime )#", true );

    var sTime = getTickCount();
    systemOutput( "Seeding Database...", true );
    migrationService.seed( "TestFixtures" );
    systemOutput( "Database seeded in #numberFormat( getTickCount() - sTime )#", true );
}
```

Now let's change up the `onRequestStart()` to this:

```js
public boolean function onRequestStart( targetPage ){
    // Set a high timeout for long running tests
    setting requestTimeout   ="9999";
    // New ColdBox Virtual Application Starter
    request.coldBoxVirtualApp= new coldbox.system.testing.VirtualApp( appMapping = "/root" );

    // Reload for fresh results
    if ( structKeyExists( url, "fwreinit" ) ) {
        if ( structKeyExists( server, "lucee" ) ) {
            pagePoolClear();
        }
        // ormReload();
        request.coldBoxVirtualApp.restart();
    }

    // If hitting the runner or specs, prep our virtual app
    if ( getBaseTemplatePath().replace( expandPath( "/tests" ), "" ).reFindNoCase( "(runner|specs)" ) ) {
        request.coldBoxVirtualApp.startup();
        seedDatabase();
    }

    return true;
}
```

We moved our `restart` code right before we call any tests or runners and then after the virtual application starts up, we call the `seedDatabase()` function. Ok, this will completely refresh our database structure and run our migrations before each tests.  Go execute the tests and let's see if they work!

## Refactor Tests

Ok, now that we have our first fixture data, let's update our `list()` test:

```js
it( "can list all users", function() {
    var aResults = model.list();
    expect( aResults ).toBeArray().notToBeEmpty();
} );
```

Verify it.
