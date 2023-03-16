# 2 - Intro to ColdBox MVC

Open the `config/Coldbox.cfc` so we can start configuring our [application](../src/config/Coldbox.cfc):

## Development Settings

* Configure the `configure()` method for production
* Verify the `environment` structures
* Add the `development()` method settings

```js
function development(){
    coldbox.debugMode               = true;
    coldbox.customErrorTemplate     = "/coldbox/system/exceptions/Whoops.cfm";
    coldbox.handlersIndexAutoreload = true;
    coldbox.reinitPassword          = "";
    coldbox.handlerCaching          = false;
    coldbox.viewCaching             = false;
    coldbox.eventCaching            = false;
}
```

### Reiniting The Framework

Please note that every time we make changes to the `config` folder we will most likely need to reinitialize our application. ColdBox caches the contents of this file upon startup. So if you need the changes to take effect you must reinitialize the application.  But how you say?

* Hard Reset : issue a server reset command in CommandBox: `server restart`
* ColdBox CLI Reinit : issue a ColdBox reinit via CommandBox: `coldbox reinit`
* ColdBox URL Reinit : use the `http://localhost:42518?fwreinit=1` url action in your app

> You can secure the `fwreinit` by using the `reinitPassword` setting in your configuration. https://coldbox.ortusbooks.com/getting-started/configuration/coldbox.cfc/configuration-directives/coldbox#development-settings

What is cached?

* Configuration
* Singletons
* Handlers
* View/Event Caching

## Visualizing The Settings - FrameworkSuperType Intro

* Open the `layouts/Main.cfm` and add a tag for the environment so we can see it.

```html
<div class="badge badge-info">
    #getSetting( "environment" )#
</div>
```

* Where does the `getSetting()` method come from?
* Go back again to the UML Diagram of Major Classes (https://coldbox.ortusbooks.com/the-basics/models/super-type-usage-methods)
* Visualize the label



## Routing 

Open the `config/Router.cfc`.

## Handlers

Open `Main.index`  let's discover the request context object and request collections:

* `event` - Request Context Object
* `rc` - Public request collection
* `prc` - Private request collection 

## Views

* Introduction to the `event.setView()` command.
* Remove that line and see that eveerything still works by convention.
* Open the views and check out the `rc` and `prc` scopes


### Add an about page

```bash
coldbox create view about/index
```

Hit the url `/about/index` and it works!  This is virtual views!

```html
<cfoutput>
    <h1>About us!</h1>
</cfoutput>
```

Add an `about` handler, change to non-existent view, does it work?

```bash
coldbox create handler name="about" actions="index" noViews
```

* Set it back to the `index` view, does it work?
* Execute the tests, we have more tests now
* Time to open our tests cases and get even more familiar with testing
    * Go over unit and integration differences
    * Go over the TestBox BDD Testing DSL
    * Add tests for our about page


```js
it( "can render the about page", function(){
    //var event = execute( event="about.index", renderResults=true );
    //var event = execute( route="/about/index", renderResults=true );
    var event = GET( "/about" );

    expect(	event.getRenderedContent() ).toInclude( "About Us" );
});
```

Remebmer that in integration testing mode you can execute the live virtual application:

* Execute events
* Execute routes
* Execute RESTFul Routes


### Assignment: Add a Links page

### Assignment: Change `prc.welcome` in the `handlers/main.cfc` and update the integration tests to pass.
