# Prerequisites

## Join the BoxTeam Slack Channel

Visit https://boxteam.ortussolutions.com to join our slack team.

## Download Software

Please have the following software on your computer before the workshop. If everyone is downloading the software at once, it will slow everyone down, and we want to make the most of our time together.

## A Modern Computer

Please make sure you have a computer that is modern. No running windows 95, 7 or something funky from the year 2000.  Make sure you have plenty of FREE RAM (at least 4gb) and with a modern processor (at least an i5).  Most of the hiccups in trainings are when people do not meet the appropriate requirements in their own machines.  We will be running CFML engines and docker containers, so make sure you can run them.

You can also alternatively use our Github devcontainer so you don't have to have anything installed locally.  Just go to our repository: https://github.com/ColdBox/coldbox-zero-to-hero, star it and fork it.  Once forked, click on the `<> Code` button then `Create Codespace`.  Let it run and build the space.

## [Git](https://git-scm.com)

* https://git-scm.com

## [Java](https://adoptium.net/) (Version 11)

This can be downloaded bundled with CommandBox if needed

* https://adoptium.net/
* https://www.ortussolutions.com/products/commandbox

## [CommandBox CLI](https://www.ortussolutions.com/products/commandbox#download) (Version 5.\*)

* https://www.ortussolutions.com/products/commandbox#download

### CommandBox Modules

Once CommandBox is installed we will need to install some global modules. Start by opening a box shell by typing `box`.  Once in the shell you can type:

```bash
install commandbox-dotenv,commandbox-migrations,commandbox-cfconfig,coldbox-cli
```

## MySQL Server (8) or Docker

You need to have a running MySQL Server 8+ either via [Docker](https://www.docker.com/community-edition#/download) or download [MySQL](https://dev.mysql.com/downloads/mysql/) for your operating system.

We have included a `docker-compose.yml` file in the `db` directory you can use to startup your database via Docker.

**IMPORTANT: Please run this command before the workshop to download the files in advance.**

```bash
docker-compose up
docker-compose stop
docker-compose start
```

The docker compose uses port `4306`.

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
