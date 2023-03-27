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

	bcrypt_test = "$2y$10$sgnxdXfMuffDAs3GkxRbVuwYsAg07nvly8Rr5uZ5zcnPAKz8kJnvS";

    function run( qb, mockdata ) {
        qb.table( "users" ).insert(
			mockdata.mock(
                $num = 25,
                "id": "autoincrement",
                "name": "name",
                "email": "email",
                "password": "oneOf:#bcrypt_test#"
            )
		)
    }

}
```

This will populate the `users` table with 25 mocked users.  Please note that we use a `bcrypt_test`, this is the bcrypt equivalent of the word `test`.  How did we generate that?  Well here is a great online bcrypt generator: https://bcrypt.online/

To run this seeder, just do:

```bash
migrate seed run TestFixtures
```

And now we got data, verify the database!

## Automated Seeding

Now that we know our seeder works and we can add data to our database for testing, let's automate it in our test harness.  Open the `BaseIntegrationSpec.cfc` and let's.
