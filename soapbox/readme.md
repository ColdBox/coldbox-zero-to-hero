<p align="center">
	<img src="https://www.ortussolutions.com/__media/coldbox-185-logo.png">
	<br>
	<img src="https://www.ortussolutions.com/__media/wirebox-185.png" height="125">
	<img src="https://www.ortussolutions.com/__media/cachebox-185.png" height="125" >
	<img src="https://www.ortussolutions.com/__media/logbox-185.png"  height="125">
</p>

<p align="center">
	<a href="https://github.com/ColdBox/coldbox-platform/actions/workflows/snapshot.yml"><img src="https://github.com/ColdBox/coldbox-platform/actions/workflows/snapshot.yml/badge.svg" alt="ColdBox Snapshots" /></a>
	<a href="https://forgebox.io/view/coldbox"><img src="https://forgebox.io/api/v1/entry/coldbox/badges/downloads" alt="Total Downloads" /></a>
	<a href="https://forgebox.io/view/coldbox"><img src="https://forgebox.io/api/v1/entry/coldbox/badges/version" alt="Latest Stable Version" /></a>
	<a href="https://forgebox.io/view/coldbox"><img src="https://img.shields.io/badge/License-Apache2-brightgreen" alt="Apache2 License" /></a>
</p>

<p align="center">
	Copyright Since 2005 ColdBox Platform by Luis Majano and Ortus Solutions, Corp
	<br>
	<a href="https://www.coldbox.org">www.coldbox.org</a> |
	<a href="https://www.ortussolutions.com">www.ortussolutions.com</a>
</p>

----

# ColdBox Elixir Application Template

This template can be your starting ground for your modern ColdFusion (cfml) web applications.  You must use [CommandBox](http://www.ortussolutions.com/products/commandbox) to track your dependencies and start embedded servers.

This template leverages ColdBox and the (ColdBox Elixir)[https://coldbox-elixir.ortusbooks.com] project for asset management and compilations.  You can place all your static assets in the `resources/assets` folder and Elixir will combine, version, copy, and even babelify your code to their appropriate location in the `includes` folder.

## Quick Installation

Install the template dependencies by running the `install` command:

```bash
box install
```

This will setup all the needed dependencies for each application template.  You can then start the embedded server:

```bash
box server start
```

Code to your liking and enjoy!

## Dockerfile

We have included a [`build/Dockerfile`](build/Dockerfile) so you can build docker containers from your source code.  We have also added two scripts in your `box.json` so you can build the docker image and run the docker image using our [CommandBox Docker](https://hub.docker.com/r/ortussolutions/commandbox) containers.

```bash
# Build a docker **container**
run-script docker:build
# Run the container
run-script docker:run
# Go into the container's bash prompt
run-script docker:bash
```

## Docker Compose Stack

We have included a [`build/docker-compose.yaml`](build/docker-compose.yml) stack that can be used to run the application in a container alongside a database.  We have included support for MySQL, PostgreSQL and MSSQL.  We have also included the `run-script docker:stack` command you so you compose the stack up or down.

```bash
run-script docker:stack up
run-script docker:stack down
```

## VSCode Helpers

We have included two vscode helpers for you:

* `.vscode/settings.json` - Includes introspection helpers for ColdBox and TestBox
* `.vscode/tasks.json` - Tasks to assist in running a Test Bundle and a CommandBox Task

We have included two custom tasks:

* `Run CommandBox Task` - Open a CommandBox task and run it
* `Run TestBox Bundle` - Open the bundle you want to test and then run it

To run the custom tasks open the command palette and choose `Tasks: Run Build Task` or the shortcut `⇧⌘B`

## Welcome to ColdBox

ColdBox *Hierarchical* MVC is the de-facto enterprise-level [HMVC](https://en.wikipedia.org/wiki/Hierarchical_model%E2%80%93view%E2%80%93controller) framework for ColdFusion (CFML) developers. It's professionally backed, conventions-based, modular, highly extensible, and productive. Getting started with ColdBox is quick and painless.  ColdBox takes the pain out of development by giving you a standardized methodology for modern ColdFusion (CFML) development with features such as:

* [Conventions instead of configuration](https://coldbox.ortusbooks.com/getting-started/conventions)
* [Modern URL routing](https://coldbox.ortusbooks.com/the-basics/routing)
* [RESTFul APIs](https://coldbox.ortusbooks.com/the-basics/event-handlers/rendering-data)
* [A hierarchical approach to MVC using ColdBox Modules](https://coldbox.ortusbooks.com/hmvc/modules)
* [Event-driven programming](https://coldbox.ortusbooks.com/digging-deeper/interceptors)
* [Async and Parallel programming constructs](https://coldbox.ortusbooks.com/digging-deeper/promises-async-programming)
* [Integration & Unit Testing](https://coldbox.ortusbooks.com/testing/testing-coldbox-applications)
* [Included dependency injection](https://wirebox.ortusbooks.com)
* [Caching engine and API](https://cachebox.ortusbooks.com)
* [Logging engine](https://logbox.ortusbooks.com)
* [An extensive eco-system](https://forgebox.io)
* Much More

## Learning ColdBox

ColdBox is the defacto standard for building modern ColdFusion (CFML) applications.  It has the most extensive [documentation](https://coldbox.ortusbooks.com) of all modern web application frameworks.


If you don't like reading so much, then you can try our video learning platform: [CFCasts (www.cfcasts.com)](https://www.cfcasts.com)

## ColdBox Sponsors

ColdBox is a professional open-source project and it is completely funded by the [community](https://patreon.com/ortussolutions) and [Ortus Solutions, Corp](https://www.ortussolutions.com).  Ortus Patreons get many benefits like a cfcasts account, a FORGEBOX Pro account and so much more.  If you are interested in becoming a sponsor, please visit our patronage page: [https://patreon.com/ortussolutions](https://patreon.com/ortussolutions)

### THE DAILY BREAD

 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
