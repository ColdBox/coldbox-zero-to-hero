
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
