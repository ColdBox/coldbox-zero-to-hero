# 4 - Database and Migrations

Just like you can version your source code, we can also version the database structure, and data by using database migrations.  The migrations project is divided into two modules that work together in unison.

- **CommandBox Migrations** (`commandbox-migrations`) which is the CLI module that will allow you to init, run, remove, etc migrations from your CLI using CommandBox: https://forgebox.io/view/commandbox-migrations
- **CFMigrations** (`cfmigrations`) which is the module that powers all the migrations system.  The CommandBox Migrations module actually uses this module as a dependency.  You can also use the migrations programmatically in your ColdBox applications as a module: https://forgebox.io/view/cfmigrations

Migrations are a way of providing version control for your application's database schema. Changes to the schema are kept in timestamped files that are ran in order `up` and `down`.  In the `up` function, you describe the changes to apply your migration. In the `down` function, you describe the changes to undo your migration.

```js
component {

    function up( schema, qb ) {
    	schema.create( "users", function( t ) {
            t.increments( "id" );
            t.string( "email" );
            t.string( "password" );
        } );
    }

    function down( schema, qb ) {
        schema.drop( "users" );
    }

}
```

Please note that migrations leverages also the `qb` module which allows you to do not only fluent queries, but also has an amazing `schema` builder.  The `qb` schema builder is incredibly powerful as it can abstract the creation, altering, modification of any construct in any database.  Keep this URL handy for documentation purposes: https://qb.ortusbooks.com/schema-builder/schema-builder

## Install CLI Migrations

Let's start by installing the migrations in CommandBox

```sh
install commandbox-migrations
```

You should see a list of available commands with `migrate ?`. Explore them.

## Initalize Migrations With `migrate init`

This will create a `.cfmigrations` in your root.  This file is used to describe where your migrations live and the connection details.  Please note that as of v4 of cfmigrations, you can use this file to maintain multiple managers.  Meaning you can create multiple migrations with different configurations.

```js
{
    "default": {
        "manager": "cfmigrations.models.QBMigrationManager",
        "migrationsDirectory": "resources/database/migrations/",
        "seedsDirectory": "resources/database/seeds/",
        "properties": {
            "defaultGrammar": "AutoDiscover@qb",
            "schema": "${DB_SCHEMA}",
            "migrationsTable": "cfmigrations",
            "connectionInfo": {
                "password": "${DB_PASSWORD}",
                "connectionString": "${DB_CONNECTIONSTRING}",
                "class": "${DB_CLASS}",
                "username": "${DB_USER}",
                "bundleName": "${DB_BUNDLENAME}",
                "bundleVersion": "${DB_BUNDLEVERSION}"
            }
        }
    }
}
```

We will use this file as is and just create the necessary environment variables in our [`.env`](../src/.env) file:

```sh
# Database Information
DB_CONNECTIONSTRING=jdbc:mysql://127.0.0.1:4306/soapbox?useSSL=false&useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&useLegacyDatetimeCode=true
DB_CLASS=com.mysql.jdbc.Driver
DB_BUNDLENAME=com.mysql.cj
DB_BUNDLEVERSION=8.0.30
DB_DRIVER=MySQL
DB_HOST=127.0.0.1
DB_PORT=4306
DB_DATABASE=soapbox
DB_USER=root
DB_PASSWORD=soapbox
```

### Test the Environment

Issue the following command in your shell:

```sh
echo ${DB_BUNDLEVERSION}
```

It should output `8.0.30`.  If it doesn't, then try reloading the CommandBox shell using the `reload` command.

## Start Our Database

We have provided a MySQL container for this project: [`db/docker-compose.yml`](../db/docker-compose.yml).  Just make sure you have docker installed and execute:

```bash
cd db
docker compose up
```

This will startup the MySQL 8 instance and store all the necessary files for persistence in the `/db/data` folder.  You should see a succesful deploy with the following logs:

```
❯ docker compose up
[+] Running 2/2
 ⠿ Network db_default    Created                                                                                                                     0.1s
 ⠿ Container db-mysql-1  Created                                                                                                                     0.1s
Attaching to db-mysql-1
db-mysql-1  | 2023-03-22 18:12:44+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.23-1debian10 started.
db-mysql-1  | 2023-03-22 18:12:45+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
db-mysql-1  | 2023-03-22 18:12:45+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.23-1debian10 started.
db-mysql-1  | 2023-03-22 18:12:46+00:00 [Note] [Entrypoint]: Initializing database files
db-mysql-1  | 2023-03-22T18:12:46.663211Z 0 [System] [MY-013169] [Server] /usr/sbin/mysqld (mysqld 8.0.23) initializing of server in progress as process 108
db-mysql-1  | 2023-03-22T18:12:46.692347Z 0 [Warning] [MY-010159] [Server] Setting lower_case_table_names=2 because file system for /var/lib/mysql/ is case insensitive
db-mysql-1  | 2023-03-22T18:12:46.768910Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
db-mysql-1  | 2023-03-22T18:12:46.813238Z 1 [ERROR] [MY-012585] [InnoDB] Linux Native AIO interface is not supported on this platform. Please check your OS documentation and install appropriate binary of InnoDB.
db-mysql-1  | 2023-03-22T18:12:46.814133Z 1 [Warning] [MY-012654] [InnoDB] Linux Native AIO disabled.
db-mysql-1  | 2023-03-22T18:12:52.951928Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
db-mysql-1  | 2023-03-22T18:12:59.769185Z 6 [Warning] [MY-010453] [Server] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
db-mysql-1  | 2023-03-22 18:13:09+00:00 [Note] [Entrypoint]: Database files initialized
db-mysql-1  | 2023-03-22 18:13:09+00:00 [Note] [Entrypoint]: Starting temporary server
db-mysql-1  | 2023-03-22T18:13:10.232120Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.23) starting as process 159
db-mysql-1  | 2023-03-22T18:13:10.260866Z 0 [Warning] [MY-010159] [Server] Setting lower_case_table_names=2 because file system for /var/lib/mysql/ is case insensitive
db-mysql-1  | 2023-03-22T18:13:10.367165Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
db-mysql-1  | 2023-03-22T18:13:10.539613Z 1 [ERROR] [MY-012585] [InnoDB] Linux Native AIO interface is not supported on this platform. Please check your OS documentation and install appropriate binary of InnoDB.
db-mysql-1  | 2023-03-22T18:13:10.540581Z 1 [Warning] [MY-012654] [InnoDB] Linux Native AIO disabled.
db-mysql-1  | 2023-03-22T18:13:11.992005Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
db-mysql-1  | 2023-03-22T18:13:12.864771Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Socket: /var/run/mysqld/mysqlx.sock
db-mysql-1  | 2023-03-22T18:13:13.654297Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
db-mysql-1  | 2023-03-22T18:13:13.656133Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
db-mysql-1  | 2023-03-22T18:13:13.676388Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
db-mysql-1  | 2023-03-22T18:13:13.897659Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.23'  socket: '/var/run/mysqld/mysqld.sock'  port: 0  MySQL Community Server - GPL.
db-mysql-1  | 2023-03-22 18:13:13+00:00 [Note] [Entrypoint]: Temporary server started.
db-mysql-1  | Warning: Unable to load '/usr/share/zoneinfo/iso3166.tab' as time zone. Skipping it.
db-mysql-1  | Warning: Unable to load '/usr/share/zoneinfo/leap-seconds.list' as time zone. Skipping it.
db-mysql-1  | Warning: Unable to load '/usr/share/zoneinfo/zone.tab' as time zone. Skipping it.
db-mysql-1  | Warning: Unable to load '/usr/share/zoneinfo/zone1970.tab' as time zone. Skipping it.
db-mysql-1  | 2023-03-22 18:13:33+00:00 [Note] [Entrypoint]: Creating database soapbox
db-mysql-1  |
db-mysql-1  | 2023-03-22 18:13:33+00:00 [Note] [Entrypoint]: Stopping temporary server
db-mysql-1  | 2023-03-22T18:13:33.823948Z 11 [System] [MY-013172] [Server] Received SHUTDOWN from user root. Shutting down mysqld (Version: 8.0.23).
db-mysql-1  | 2023-03-22T18:13:36.221449Z 0 [System] [MY-010910] [Server] /usr/sbin/mysqld: Shutdown complete (mysqld 8.0.23)  MySQL Community Server - GPL.
db-mysql-1  | 2023-03-22 18:13:36+00:00 [Note] [Entrypoint]: Temporary server stopped
db-mysql-1  |
db-mysql-1  | 2023-03-22 18:13:36+00:00 [Note] [Entrypoint]: MySQL init process done. Ready for start up.
db-mysql-1  |
db-mysql-1  | 2023-03-22T18:13:37.350404Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.23) starting as process 1
db-mysql-1  | 2023-03-22T18:13:37.376801Z 0 [Warning] [MY-010159] [Server] Setting lower_case_table_names=2 because file system for /var/lib/mysql/ is case insensitive
db-mysql-1  | 2023-03-22T18:13:37.475775Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
db-mysql-1  | 2023-03-22T18:13:37.565400Z 1 [ERROR] [MY-012585] [InnoDB] Linux Native AIO interface is not supported on this platform. Please check your OS documentation and install appropriate binary of InnoDB.
db-mysql-1  | 2023-03-22T18:13:37.566479Z 1 [Warning] [MY-012654] [InnoDB] Linux Native AIO disabled.
db-mysql-1  | 2023-03-22T18:13:38.891839Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
db-mysql-1  | 2023-03-22T18:13:39.691801Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
db-mysql-1  | 2023-03-22T18:13:40.206269Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
db-mysql-1  | 2023-03-22T18:13:40.207877Z 0 [System] [MY-013602] [Server] Channel mysql_main configured to support TLS. Encrypted connections are now supported for this channel.
db-mysql-1  | 2023-03-22T18:13:40.228577Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
db-mysql-1  | 2023-03-22T18:13:40.482956Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.23'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
```

## VSCode SQL Tools

We highly encourage you install the SQL Tools module from VSCode: https://vscode-sqltools.mteixeira.dev/en/home/.  We have included in the project in the `.vscode` folder a connection already for this container: [`.vscode/settings.json`](../.vscode/settings.json)

```js
{
    "sqltools.connections": [
        {
            "mysqlOptions": {
                "authProtocol": "xprotocol"
            },
            "previewLimit": 50,
            "server": "localhost",
            "port": 43060,
            "driver": "MySQL",
            "name": "soapbox",
            "database": "soapbox",
            "username": "root",
            "connectionTimeout": 2000,
            "askForPassword": true
        }
    ]
}
```

> Please note the port has an extra 0 at the end.  This is needed by any tool connecting to MySQL using their new authentication protocols.

Just open the tools, double click the `soapbox` connection and if succesful then we are ready to init our database.

## Install Migrations

Now let's install the migrations table in our database: `migrate install`.  If this is successful then our credentials in our `.env` are correct.  If not, check the console for debugging information.

```bash
❯ migrate install
Migration table installed!
```

If the table does not exist, this will create the table in your db. If you refresh your db, you should see the table. If you run the command again, it will let you know it is already installed. Try it!

## Create the `users` migration

```sh
migrate create create_users_table
```

All migration resources are stored by default under `resources/database/migrations/**.cfc`.  Make sure these are in version control. They can save your life!  The migration file was created by the last command, and the file location was output by commandbox.  If you are using VS Code, you can just `Ctrl|cmd` + Click to open the file.

Let's now create the `users` table.  In the example below you can see a MySQL specific query execution and also a DB agnostic creation using the Schema Builder.  The Schema Builder is the best approach as it abstracts the database.

```java
component {

    function up( schema ) {
        // queryExecute( "
        //     CREATE TABLE `users` (
        //         `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
        //         `username` VARCHAR(255) NOT NULL UNIQUE,
        //         `email` VARCHAR(255) NOT NULL UNIQUE,
        //         `password` VARCHAR(255) NOT NULL,
        //         `createdDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        //         `modifiedDate` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        //         CONSTRAINT `pk_users_id` PRIMARY KEY (`id`)
        //     )
        // " );

        schema.create( "users", function( table ) {
            table.increments( "id" )
            table.string( "name" )
            table.string( "email" ).unique()
            table.string( "password" )
            table.timestamps()
        } );
    }

    function down( schema ) {
        //queryExecute( "DROP TABLE `users`" );
        schema.drop( "users" )
    }

}
```

> QB Schema Builder Docs: https://qb.ortusbooks.com/schema-builder/schema-builder, your new best friend.

Now let's run it!

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

## Reinit Server

We are ready for more coding. However, before we do that our web server has no clue we changed the `.env` environment variables.  A restart should fix that!

```bash
server restart
```

You will need to restart your server whenever you add, remove, or change environment variables.

## Ensure Application

Verify that we did not break our app:

- Let's use another cool command: `server open` to open the webroot
- But we can also use it to open any URI: `server open tests/runner.cfm`

Everything should be <span style="color: green">Green!</span>
