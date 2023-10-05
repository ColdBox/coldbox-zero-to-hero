# 5 - Setup the Test Harness and Base Spec

## Install `cfmigrations` as a dev dependency

CF Migrations is different than `commandbox-migrations`. It allows you to run the migrations from a running CFML engine and NOT CommandBox. Usually, you can use them for testing purposes or delivering updates in your apps. However, for today, this is a **development** dependency only.

CommandBox can track production and development dependencies for you via the `--saveDev` flag.

```sh
install cfmigrations --saveDev
```

## Configure `Application.cfc`

In step 4 we added the datasource to your Application.cfc. Confirm that the datasource is `soapbox`, not the default for the template of `coldbox`.

```js
this.datasource = "soapbox";
```

## Configure `tests/Application.cfc`

Add `soapbox` as our default datasource:

```js
this.datasource = "soapbox";
```

## Create a `tests/resources/BaseIntegrationSpec.cfc`

We will create a base test bundle so we can tap into TestBox's life-cycle events and provide uniformity to all our tests. Remember that in ColdBox Testing we can also use dependency injection by tagging our components with the `autowire` annotation:

```js
/**
 * Base test bundle for our application
 *
 * @see https://coldbox.ortusbooks.com/testing/testing-coldbox-applications/integration-testing
 */
component extends="coldbox.system.testing.BaseTestCase" autowire{

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
    this.loadColdBox    = true;
    this.unloadColdBox  = false;

    /**
     * Run Before all tests
     */
    function beforeAll() {
        super.beforeAll();

        // Check if migrations ran before all tests, if not, prep our database
        if ( ! request.keyExists( "migrationsRan" ) ) {
            var migrationService = getInstance( name : "MigrationService@cfmigrations", initArguments  : {
                migrationsDirectory : "/root/resources/database/migrations",
                seedsDirectory : "/root/resources/database/seeds",
                properties : {
                    datasource : "soapbox"
                }
            });

            migrationService.runAllMigrations( "down" );
            migrationService.runAllMigrations( "up" );
            request.migrationsRan = true;
        }
    }

    /**
     * This function is tagged as an around each handler.  All the integration tests we build
     * will be automatically rolledbacked so we don't corrupt the database with our tests
     *
     * @aroundEach
     */
    function wrapInTransaction( spec ) {
        transaction action="begin" {
            try {
                arguments.spec.body( argumentCollection = arguments );
            } catch ( any e ){
                rethrow;
            } finally {
                transaction action="rollback";
            }
        }
    }

}
```

Go update the specs you have by adding the `extends="tests.resources.BaseIntegrationSpec"` and let's run the tests again and make sure they pass!
