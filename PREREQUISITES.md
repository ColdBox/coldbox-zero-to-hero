# Prerequisites

## Join the BoxTeam Slack Channel

Visit boxteam.herokuapp.com and invite yourself to the Slack.

## Download Software

Please have the following software on your computer before the workshop. If everyone is downloading the software at once, it will slow everyone down, and we want to make the most of our time together.

## A Modern Computer

Please make sure you have a computer that is modern. No running windows 95, 7 or something funky from the year 2000.  Make sure you have plenty of FREE RAM (at least 4gb) and with a modern processor (at least an i5).  Most of the hiccups in trainings are when people do not meet the appropriate requirements in their own machines.  We will be running CFML engines and docker containers, so make sure you can run them.

## [Git](https://git-scm.com)

* https://git-scm.com

### [Java](https://www.java.com/en/) (Version 8)

This can be downloaded bundled with CommandBox if needed
* https://www.java.com/en/
* https://www.ortussolutions.com/products/commandbox

### [CommandBox CLI](https://www.ortussolutions.com/products/commandbox#download) (Version 4.\*)

* https://www.ortussolutions.com/products/commandbox#download

#### CommandBox Modules

Once CommandBox is installed we will need to install some global modules. Start by opening a box shell by typing `box`.  Once in the shell you can type:

```bash
install commandbox-dotenv,commandbox-migrations,commandbox-cfconfig
```

### MySQL Server (5.7)

You need to have a running MySQL Server locally.
If you don't have one already on your system, you can get started easily with
[Docker](https://www.docker.com/community-edition#/download) or download [MySQL](https://dev.mysql.com/downloads/mysql/) for your operating system.

> **Important** : Please make sure you have version 5.7 and not 5.8.  The JDBC drivers in Lucee and ACF have conflicting issues with MySQL version 5.8.

You can use the `docker-compose` command from the root directory with `docker-compose.yml` file
Or downloadable from [docker-compose.yml](https://gist.github.com/gpickin/e724fc54b0fff733e46dda318772dbc8)

**IMPORTANT: Please run this command before the workshop to download the files in advance.**

```bash
docker-compose up
docker-compose stop
docker-compose start
```

The docker compose uses port `3306`. If you have MySQL already running on your machine, you can update the port in the docker compose by changing the port line to this and now your port will be `33306` instead of the usual `3306`.

```bash
- "127.0.0.1:33306:3306"
```

You can also use the following command will start a MySQL Server with docker.

```bash
docker run -d --name soapbox -p 3306:3306 -e MYSQL_DATABASE=soapbox -e MYSQL_ROOT_PASSWORD=soapbox mysql:5.7
```

After you have created the container, you can start and stop it using the following commands:

```bash
docker start soapbox
docker stop soapbox
```

**Note**: Without a volume, your data will only last as long as your container does... this is why we recommend the Docker Compose, since it will automatically create and use a volume for you.

## MySQL Client

You will want a SQL client to inspect and interact with your database.
You can use any client you would like. Here are a few we like ourselves:

* [Sequel Pro](https://sequelpro.com) (Mac, Free)
* [Heidi SQL](https://www.heidisql.com) (Windows, Free)
* [TablePlus](https://tableplus.io/) (Cross Platform, Commercial / Free Trial)
* [Data Grip](https://www.jetbrains.com/datagrip/) (Cross Platform, Commercial / Free Trial)

## IDE 

We recommend the following IDEs for development for this workshop

* [Microsoft VSCode](https://code.visualstudio.com/)
* [Sublime](https://www.sublimetext.com/)

If using VS Code, please install the following extensions:

* CFML - KamasamaK
* vscode-coldbox
* vscode-testbox
* Docker
* Yaml

If using Sublime, please install the following extensions:

* ColdBox Platform
* CFML
* CFMLDocPlugin
* Enhanced HTML and CFML
* DockerFile Syntax Highlighting
* Yaml

## Useful Resources

* ColdBox Api Docs: https://apidocs.ortussolutions.com/coldbox/5.2.0/index.html
* ColdBox Docs: https://coldbox.ortusbooks.com
* WireBox Docs: https://wirebox.ortusbooks.com
* TestBox Docs: https://testbox.ortusbooks.com
* TestBox Api Docs: https://apidocs.ortussolutions.com/testbox/2.8.0+191/index.html
* Migrations: https://www.forgebox.io/view/commandbox-migrations
