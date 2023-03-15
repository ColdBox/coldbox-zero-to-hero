## 2 - Intro to ColdBox MVC

### Development Settings

* Configure the `configure()` method for production
* Verify the `environment` structures
* Add the `development()` method settings

```js
function development(){
    coldbox.customErrorTemplate = "/coldbox/system/exceptions/Whoops.cfm";
    coldbox.handlersIndexAutoreload = true;
    coldbox.reinitPassword = "";
    coldbox.handlerCaching = false;
    coldbox.viewCaching = false;
    coldbox.eventCaching = false;
}
```

* Open the `layouts/Main.cfm` and add a tag for the environment

```html
<div class="badge badge-info">
    #getSetting( "environment" )#
</div>
```

* Where does the `getSetting()` method come from?
* Go back again to the UML Diagram of Major Classes (https://coldbox.ortusbooks.com/the-basics/models/super-type-usage-methods)
* Reinit the framework

> http://localhost:42518?fwreinit=1

* What is cached?
* Singletons
* Handlers
* View/Event Caching

```bash
coldbox reinit
```

* Change the environments, test the label


### Show routes file. Explain routing by convention.

### Explain `event`, `rc`, and `prc`.

### Show `Main.index`.

### Explain views. Point out view conventions.

### Briefly touch on layouts.

### Show how `rc` and `prc` are used in the views.

### Add an about page

```bash
coldbox create view about/index
```

#### Add an `views/about/index.cfm`. Hit the url `/about/index` and it works!

```html
<cfoutput>
    <h1>About us!</h1>
</cfoutput>
```
#### Add an `about` handler, change to non-existent view, does it work?

```bash
coldbox create handler name="about" actions="index" views=false
```

#### Set it back to the `index` view, does it work?

#### Execute the tests, we have more tests now

* Explain Integration Testing, BDD Specs, Expectations
* Fix the tests

```js
it( "can render the about page", function(){
    //var event = execute( event="about.index", renderResults=true );
    //var event = execute( route="/about/index", renderResults=true );
    var event = GET( "/about" );

    expect(	event.getRenderedContent() ).toInclude( "About Us" );
});
```

### Assignment: Add a Links page

### Assignment: Change `prc.welcome` in the `handlers/main.cfc` and update the integration tests to pass.
