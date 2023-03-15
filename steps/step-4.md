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
    "migrationsDirectory":"resources/database/migrations",
    "schema":"${DB_SCHEMA}",
    "connectionInfo":{
        "bundleName":"${DB_BUNDLENAME}",
        "bundleVersion":"${DB_BUNDLEVERSION}",
        "password":"${DB_PASSWORD}",
        "connectionString":"${DB_CONNECTIONSTRING}",
        "class":"${DB_CLASS}",
        "username":"${DB_USER}"
    },
    "defaultGrammar":"AutoDiscover@qb"
}
```

Which is needed so migrations can talk to your database!

### Install [commandbox-dotenv](https://www.forgebox.io/view/commandbox-dotenv)

To make our migration setup more secure, we're going to use environment variables. In local development, we can do this easily with a commandbox module, DotEnv.

```sh
install commandbox-dotenv
```

### Update the existing `/.env` file. Fill it in appropraitely. (We'll fill it in with our Docker credentials from before.)

This assumes you are using MySQL with CommandBox 5 or greater, which the newer version of Lucee requires a BundleName and BundleVersion and a new class for the driver.

```sh
DB_CONNECTIONSTRING=jdbc:mysql://127.0.0.1:3306/soapbox?useSSL=false&useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&useLegacyDatetimeCode=true
DB_CLASS=com.mysql.cj.jdbc.Driver
DB_BUNDLENAME=com.mysql.cj
DB_BUNDLEVERSION=8.0.15
DB_DRIVER=MySQL
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=soapbox
DB_SCHEMA=soapbox
DB_USER=root
DB_PASSWORD=soapbox
```

Once the `.env` file is seeded, reload CommandBox so it can pickup the environment: `reload`

### Test our environment variable with an echo command

```sh
echo ${DB_BUNDLEVERSION}
```

You should see no output, because DotEnv has not loaded the variables from our file.

### Reload your shell in your project root. (`reload` or `r`)

```sh
r
echo ${DB_BUNDLEVERSION}
```

You should now see `8.0.15`, your `DB_BUNDLEVERSION` output when you run that `echo` command.

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
