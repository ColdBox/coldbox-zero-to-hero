# Prerequisites

Please have the following software on your computer before the workshop. If everyone is downloading the software at once, it will slow everyone down, and we want to make the most of our time together.

## [Git](https://git-scm.com)

## [Java](https://www.java.com/en/) (Version 7 or 8)

This can be downloaded bundled with CommandBox.

## [CommandBox CLI](https://www.ortussolutions.com/products/commandbox#download) (Version 4.\*)

## MySQL Server

You need to have a running MySQL Server locally.
If you don't have one already on your system, you can get started easily with
[Docker](https://www.docker.com/community-edition#/download).

You can use Docker-compose with from the directory with docker-compose.yml.
Or downloadable from [docker-compose.yml](https://gist.github.com/gpickin/e724fc54b0fff733e46dda318772dbc8)

*Please run this command before the workshop to download the files in advance.*

```
docker-compose up
docker-compose stop
docker-compose start
```

The docker compose uses port 3306. If you have MySQL already running on your machine, you can update the port in the docker compose by changing the port line to this and now your port will be 33306 instead of the usual 3306.

```
- "127.0.0.1:33306:3306"
```


You can also use the following command will start a MySQL Server with docker.

```
docker run -d --name soapbox -p 3306:3306 -e MYSQL_DATABASE=soapbox -e MYSQL_ROOT_PASSWORD=soapbox mysql

```
After you have created the container, you can start and stop it using the following commands:

```
docker start soapbox
docker stop soapbox
```
Note: Without a volume, your data will only last as long as your container does... this is why we recommend the Docker Compose, since it will automatically create and use a volume for you.

## MySQL Client

You will want a SQL client to inspect and interact with your database.
You can use any client you would like. Here are a few we like ourselves:

* [Sequel Pro](https://sequelpro.com) (Mac, Free)
* [Heidi SQL](https://www.heidisql.com) (Windows, Free)
* [Data Grip](https://www.jetbrains.com/datagrip/) (Cross Platform, Commercial / Free Trial)

# Useful Resources
