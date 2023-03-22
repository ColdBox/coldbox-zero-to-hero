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

## Visualizing The Settings - `FrameworkSuperType` Intro

* Open the `layouts/Main.cfm` and add a tag for the environment so we can see it.

Add the JavaScript so we can use tooltips to the bottom after the footer:

```html
<script>
    // self executing function here
    (function() {
    // your page initialization code here
    // the DOM will be available here
        const aTooltips = document.querySelectorAll( '[data-bs-toggle="tooltip"]' );
        const tooltipList = [...aTooltips ].map( el => new bootstrap.Tooltip( el ) );
    })();
</script>
```

Now let's add a few badges to our footer so it can assist us during development.

```html
<footer class="w-100 bottom-0 position-fixed border-top py-3 mt-5 bg-light">
    <div class="container">
        <p class="float-end">
            <a href="##" class="btn btn-info rounded-circle shadow" role="button">
                <i class="bi bi-arrow-bar-up"></i> <span class="visually-hidden">Top</span>
            </a>
        </p>
        <p>
            <a href="https://github.com/ColdBox/coldbox-platform/stargazers">ColdBox Platform</a> is a copyright-trademark software by
            <a href="https://www.ortussolutions.com">Ortus Solutions, Corp</a>
        </p>

        <span
            class="badge rounded-pill text-bg-dark"
            data-bs-toggle="tooltip"
            title="Environment"
        >
            <i class="bi bi-hdd-stack"></i>
            #getSetting( "environment" )#
        </span>

        <span
            class="badge rounded-pill text-bg-dark"
            data-bs-toggle="tooltip"
            title="Debug Mode"
        >
            <i class="bi bi-bug"></i>
            #isDebugMode()#
        </span>

        <span
            class="badge rounded-pill text-bg-dark"
            data-bs-toggle="tooltip"
            title="Request Date/Time"
        >
            <i class="bi bi-calendar"></i>
            #getIsoTime()#
        </span>
    </div>
</footer>
```

* Where does the methods `getSetting(), isDebugMode(), getIsoTime()` method come from?
* Go back again to the UML Diagram of Major Classes (https://coldbox.ortusbooks.com/the-basics/models/super-type-usage-methods)
* Visualize the labels

## Routing

Open the [`config/Router.cfc`](../src/config/Router.cfc) and let's understand how routing works: https://coldbox.ortusbooks.com/the-basics/routing.

## Handlers

![request context bus](https://2327111203-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-LA-UVvJIdbk5Kfk3bDs%2F-LDfsMlLZNOBetOxbOpo%2F-LDfsVNFLpJa0J0ipVoy%2FRequestCollectionDataBus.jpg?generation=1527597114288895&alt=media "Request Context Bus")

Open [`Main.index` ](../src/handlers/Main.cfc) let's discover the request context object (`event`) and the request collections modeled inside of the event.

* `event`   - Request Context Object (Lives in `request` scope)
* `rc`      - Public request collection (FORM-URL)
* `prc`     - Private request collection

## Views

* Introduction to the `event.setView()` command.
* Remove that line and see that eveerything still works by convention.
* Open the views and check out the `rc` and `prc` scopes, they are injected for you.

### Add an about page

```bash
coldbox create view about/index
```

Hit the url `/about/index` and it works!  This is virtual views!  Let's open it and add the following:

```html
<cfoutput>
	<div class="text-center card shadow-sm bg-light border border-5 border-white">
		<div class="card-body">
			<div>
				<h1 class="display-1">
					<i class="bi bi-boombox"></i>
				</h1>
			</div>

			<h1 class="display-5 fw-bold">
				Welcome to SoapBox!
			</h1>

			<div class="col-lg-6 mx-auto">
				<p class="lead mb-4">
					SoapBox is a simple micro-blogging platform built with ColdBox!
				</p>
			</div>
		</div>
	</div>
</cfoutput>
```

Add an `about` handler:

```bash
coldbox create handler name="about" actions="index" views=false
```

* This command will generate the `handlers/about.cfc` and the `tests/specs/integration/aboutTest.cfc`
* Test the request again
* Change the view now to this `event.setView( "about/test" )`, does it work?
  * Why did it work? Metadata is cached, so let's reinit
* Set it back to the `index` view, does it work?
* Let's open the [tests now](../src/tests/specs/integration/aboutTest.cfc)
* Execute the tests, we have more tests now: `testbox run`
* Time to open our tests cases and get even more familiar with testing
    * Go over unit and integration differences
    * Go over the TestBox BDD Testing DSL
    * Add tests for our about page


```js
it( "can render the about page", function(){
    //var event = execute( event="about.index", renderResults=true );
    //var event = execute( route="/about/index", renderResults=true );
    var event = GET( "/about" );
    expect(	event.getRenderedContent() ).toInclude( "Welcome to SoapBox!" );
});
```

Remember that in integration testing mode you can execute the live virtual application:

* Execute events
* Execute routes
* Execute RESTFul Routes
* Execute database calls
* The whole shabang!

## Assignments

Here are some assignments for you:

* Change `prc.welcome` in the `handlers/Main.cfc` to your liking.
* Run the tests
* Fix the tests
* Let's see how [CFFormat](https://www.forgebox.io/view/commandbox-cfformat) can format our source code automatically for us.  Open the shell and type: `run-script format:watch`.  This starts a watcher for our source code.  Every time we make a change and save, it will automatically format it for us.
  * The magic rules are done by the `.cfformat` file in the web root.
