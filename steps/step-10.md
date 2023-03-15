## 10 - Rants

### Migrations

```sh
migrate create create_rants_table
```

In the file that was created by the previous command, put this piece of code in there

```js
component {

    function up( schema, queryBuilder ) {
        schema.create( "rants", function( table ){
            table.increments( "id" );
            table.text( "body" );
            table.timestamp( "createdDate" );
            table.timestamp( "modifiedDate" );
            table.unsignedInteger( "userId" );
            table.foreignKey( "userId" ).references( "id" ).onTable( "users" );
        } );
    }

    function down( schema, queryBuilder ) {
        schema.drop( "rants" );
    }

}

```

Now, migrate your rants

```
migrate up
```

### BDD

Now, let's do some BDD as we have to build the CRUD for rants. Let's start by generating the tests, handlers and supporting files:

```bash
coldbox create handler name="rants" actions="index,new,create"
# delete the create view, it's not necessary
delete views/rants/create.cfm --force
```

Open the integration tests and start coding:

```js
//tests/specs/integration/rantsTest.cfc

component extends="tests.resources.BaseIntegrationSpec"{

	property name="query" 		inject="provider:QueryBuilder@qb";
	property name="bcrypt" 		inject="@BCrypt";
	property name="auth" 		inject="authenticationService@cbauth";

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		query.from( "users" )
			.insert( values = {
				username : "testuser",
				email : "testuser@tests.com",
				password : bcrypt.hashPassword( "password" )
			} );
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
		query.from( "users" )
			.where( "username", "=", "testuser" )
			.delete();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "rants Suite", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			});

			it( "can display all rants", function(){
				var event = get( route="/rants", params={} );
				// expectations go here.
				expect( event.getPrivateValue( "aRants") ).toBeArray();
				expect( event.getRenderedContent() ).toInclude( "All Rants" );
			});

			it( "can display the rants index when no rants exists", function(){
				prepareMock( getInstance( "RantService" ) )
					.$( "getAll", [] );
				var event = get( route="/rants", params={} );

				getWireBox().clearSingletons();

				expect( event.getPrivateValue( "aRants") ).toBeEmpty();
				expect( event.getRenderedContent() ).toInclude( "No rants yet" );
			});

			it( "can display the new rant form", function(){
				var event = get( route="/rants/new" );
				// expectations go here.
				expect( event.getRenderedContent() ).toInclude( "Rant About It" );
			});

			it( "can stop a rant from being created from an invalid user", function(){
				auth.logout();
				expect( function(){
					var event = post( route="rants", params={
						body = "Test Rant"
					} );
				}).toThrow( type="NoUserLoggedIn" );
			});

			it( "can create a rant from a valid user", function(){

				// Log in user
				auth.authenticate( "testuser", "password" );

				var event = post( route="rants", params={
					body = "Test Rant"
				} );

				expect( event.getValue( "relocate_URI" ) ).toBe( "/rants" );
			});


		});

	}

}
```

### Resources Router

Add the rants resources in the `Router.cfc` file

```js
// config/Router.cfc
resources( "rants" );
```

### Event Handler

Let's build it out.

```js
// handlers/rants.cfc

/**
* I am a new handler
*/
component{

	property name="rantService" 	inject;
	property name="messagebox" 		inject="MessageBox@cbmessagebox";

	/**
	* index
	*/
	function index( event, rc, prc ){
		prc.aRants = rantService.getAll()
		event.setView( "rants/index" );
	}

	/**
	* new
	*/
	function new( event, rc, prc ){
		event.setView( "rants/new" );
	}

	/**
	* create
	*/
	function create( event, rc, prc ){
		var oRant = populateModel( "Rant" );

		oRant.setUserId( auth().getUserId() );

		rantService.create( oRant );

		messagebox.info( "Rant created!" );
		relocate( URI="/rants" );
	}



}
```


### Model: `Rant`

Run the following to create your Rant object with a constructor and a few methods `getUser(),isLoaded()` method we will fill out later.  Please note the unit test is created as well.

```bash
coldbox create model name="Rant" properties="id,body,createdDate:date,modifiedDate:date,userID" methods="getUser,isLoaded"
```

Let's open the model and modify it a bit

```js
//models/Rant.cfc
/**
* I am a new Rant Object
*/
component accessors="true"{

	// DI
	property name="userService" inject;

	// Properties
	property name="id"           type="string" default = "";
	property name="body"         type="string" default = "";
	property name="createdDate"  type="date";
	property name="modifiedDate" type="date";
	property name="userID"       type="string" default = "";


	/**
	 * Constructor
	 */
	Rant function init(){
		variables.createdDate = now();
		return this;
	}

	/**
	* getUser
	*/
	function getUser(){
		// Lazy loading the relationship
		return userService.retrieveUserById( getuserId() );
	}

	/**
	* isLoaded
	*/
	boolean function isLoaded(){
		return( !isNull( variables.id ) && len( variables.id ) );
	}


}
```

Work on the unit test, what will you test?

```js
//tests/specs/unit/RantTest.cfc
/**
* The base model test case will use the 'model' annotation as the instantiation path
* and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
* responsibility to update the model annotation instantiation path and init your model.
*/
component extends="tests.resources.BaseIntegrationSpec"{

	property name="query" 		inject="provider:QueryBuilder@qb";
	property name="bcrypt" 		inject="@BCrypt";

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		model = getInstance( "Rant" );

		cleanUserFixture();
		testUserId = query.from( "users" )
			.insert( values = {
				username : "testuser",
				email : "testuser@tests.com",
				password : bcrypt.hashPassword( "password" )
			} ).result.generatedKey;

		model.setUserId( testUserId );
	}

	function afterAll(){
		cleanUserFixture();
		super.afterAll();
	}

	function cleanUserFixture(){
		query.from( "users" )
			.where( "username", "=", "testuser" )
			.delete();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Rant Suite", function(){

			it( "can create the Rant", function(){

				expect(	model ).toBeComponent();

			});

			it( "should getUser", function(){
				var oUser = model.getUser();

				expect( oUser.getId() ).toBe( testUserId );
			});


		});

	}

}
```

### Model: `RantService`

Let's create our rant service and work on it with a few methods: `getAll(),create(),new()`

```bash
coldbox create model name="RantService" persistence="singleton" methods="getAll,create,new"
```

Now open it and let's modify it a bit for our purposes.  Also update the unit tests.

```js
//models/RantService.cfc
/**
* I am a new Model Object
*/
component singleton accessors="true"{

	// Properties
	property name="populator" inject="wirebox:populator";

	/**
	 * Constructor
	 */
	RantService function init(){

		return this;
	}

	/**
	 * Provider of Rant objects
	 */
	Rant function new() provider="Rant"{}

	/**
	 * Get all rants
	 */
	array function getAll(){
		return queryExecute(
            "SELECT * FROM `rants` ORDER BY `createdDate` DESC",
            [],
            { returntype = "array" }
        ).map( function ( rant ) {
            return populator.populateFromStruct(
                new(),
                rant
            );
        } );
	}

	/**
	 * Create a rant
	 */
	function create( required rant ){
		rant.setModifiedDate( now() );
        queryExecute(
            "
                INSERT INTO `rants` (`body`, `modifiedDate`, `userId`)
                VALUES (?, ?, ?)
            ",
            [
                rant.getBody(),
                { value = rant.getModifiedDate(), cfsqltype = "TIMESTAMP" },
                rant.getUserId()
            ],
            { result = "local.result" }
        );
        rant.setId( result.GENERATED_KEY );

		return rant;
	}

}
```

```js
//tests/specs/unit/RantServiceTest.cfc

describe( "RantService Suite", function(){

    it( "can be created", function(){
        expect( model ).toBeComponent();
    });

});
```

Why not create more unit tests?

### The `index` view

```html
<!-- views/rants/index.cfm -->
<cfoutput>
    <h2>All Rants</h2>
    <cfif prc.aRants.isEmpty()>
        <h3>No rants yet</h3>
        <a href="#event.buildLink( "rants.new" )#" class="btn btn-primary">Start one now!</a>
    <cfelse>
        <a href="#event.buildLink( "rants.new" )#" class="btn btn-primary">Start a new rant!</a>
        <cfloop array="#prc.aRants#" item="rant">
            <div class="card mb-3">
                <div class="card-header">
                    <strong>#rant.getUser().getUsername()#</strong> said at #dateTimeFormat( rant.getCreatedDate(), "h:nn:ss tt" )# on #dateFormat( rant.getCreatedDate(), "mmm d, yyyy")#
                </div>
                <div class="panel card-body">
                    #rant.getBody()#
                </div>
            </div>
        </cfloop>
    </cfif>
</cfoutput>
```

### Set the default event to `rants.index`

We want our rants to be the homepage instead of the default one.

```js
//config/ColdBox.cfc
// inside the coldbox struct
coldbox = {
    defaultEvent = "rants.index",
    ...
};
```

Hit http://127.0.0.1:42518/ and you'll see the main.index with the dump. ColdBox settings require a framework reinit.

Reinit the framework, then you'll see the Rant index.

### The `new` view

```html
<!-- views/rants/new.cfm -->
<cfoutput>
    <div class="card">
        <h4 class="card-header">Start a Rant</h4>
        <form class="form panel card-body" method="POST" action="#event.buildLink( "rants" )#">
            <div class="form-group">
                <textarea name="body" class="form-control" placeholder="What's on your mind?" rows="10"></textarea>
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-primary">Rant About It!</button>
            </div>
        </form>
    </div>
</cfoutput>
```

### Update the main layout

```html
<!--- /layouts/Main.cfc --->
<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top main-navbar">
    <a class="navbar-brand" href="#event.buildLink( "/" )#">
        <i class="fas fa-bullhorn mr-2"></i>
        SoapBox
    </a>

    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="##navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <cfif auth().isLoggedIn()>
    <ul class="navbar-nav">
        <li><a href="#event.buildLink( "rants.new" )#" class="nav-link">Start a Rant</a></li>
    </ul>
    </cfif>

    <ul class="navbar-nav ml-auto">
        <cfif auth().isLoggedIn()>
            <form method="POST" action="#event.buildLink( "logout" )#">
                <input type="hidden" name="_method" value="DELETE" />
                <button type="submit" class="btn btn-link nav-link">Log Out</button>
            </form>
        <cfelse>
            <a href="#event.buildLink( "registration.new" )#" class="nav-link">Register</a>
            <a href="#event.buildLink( "login" )#" class="nav-link">Log In</a>
        </cfif>
    </ul>

</nav>
```

Hit http://127.0.0.1:42518/ and click on Start a rant and you'll see the form.
Log out and try, and you can still see the form. Try to create a rant and you'll see an error!
We need to secure the form, to ensure the user is logged in before they can send a rant.
