# Prerequisites

Please have the following software on your computer before the workshop.

## [Git](https://git-scm.com)

## [Java](https://www.java.com/en/) (Version 7 or 8)

This can be downloaded bundled with CommandBox.

## [CommandBox CLI](https://www.ortussolutions.com/products/commandbox#download) (Version 3.9.\* or later)

## MySQL Server

You need to have a running MySQL Server locally.
If you don't have one already on your system, you can get started easily with
[Docker](https://www.docker.com/community-edition#/download).

The following command will start a MySQL Server with docker.

```
docker run -d --name soapbox -p 3306:3306 -e MYSQL_DATABASE=soapbox -e MYSQL_ROOT_PASSWORD=soapbox mysql
```

After you have created the container, you can start and stop it using the following commands:

```
docker start soapbox
docker stop soapbox
```

## MySQL Client

You will want a SQL client to inspect and interact with your database.
You can use any client you would like. Here are a few we like ourselves:

* [Sequel Pro](https://sequelpro.com) (Mac, Free)
* [Heidi SQL](https://www.heidisql.com) (Windows, Free)
* [Data Grip](https://www.jetbrains.com/datagrip/) (Cross Platform, Commercial / Free Trial)

# Useful Resources
