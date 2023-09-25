# 10 - Rants

Let's move on to our rant blogging now.

## Migrations

```bash
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

```bash
migrate up
```

## Seeder

Let's update our `TestFixtures` seeder with some rant goodness!

```js
component {

	// The bcrypt equivalent of the word test.
	bcrypt_test = "$2a$12$5d31nX1hRnkvP/8QMkS/yOuqHpPZSGGDzH074MjHk6u2tYOG5SJ5W";

	function run( qb, mockdata ){
		// Create Users
		var aUsers = mockdata.mock(
			$num      = 10,
			"id"      : "autoincrement",
			"name"    : "name",
			"email"   : "email",
			"password": "oneOf:#bcrypt_test#"
		);
		qb.newQuery()
			.table( "users" )
			.insert( aUsers );

		// Create Rants
		var aRants = mockdata.mock(
			$num     = 25,
			"id"     : "autoincrement",
			"body"   : "sentence:1:3",
			"userId" : "num:1:#aUsers.len()#"
		);
		qb.newQuery()
			.table( "rants" )
			.insert( aRants );
	}

}
```

See something different? Let's see who can spot it?

Also, as our application progresses, it will be a little heavy-handed to be running the migrations and database seeding on EVERY test run. So let's update our code so it ONLY runs if we issue a `fwreinit` to the TEST application. Remember, this is a separate application from the root application; thus the separate `Application.cfc`

```js
// Reload for fresh results
if (structKeyExists(url, "fwreinit")) {
  if (structKeyExists(server, "lucee")) {
    pagePoolClear();
  }
  // ormReload();
  request.coldBoxVirtualApp.restart();
  // SEED DATABSE HERE
  seedDatabase();
}

// If hitting the runner or specs, prep our virtual app
if (
  getBaseTemplatePath()
    .replace(expandPath("/tests"), "")
    .reFindNoCase("(runner|specs)")
) {
  request.coldBoxVirtualApp.startup();
  // IT USED TO BE HERE
}
```

## BDD

Now, let's do some BDD as we have to build the CRUD for rants. Our stories will be done as we progress.

```bash
coldbox create resource rants
# delete the unused views
delete views/rants/create.cfm,views/rants/edit.cfm,views/rants/delete.cfm --force
```

Open the integration tests and start coding:

```js
/**
 * 	ColdBox Integration Test
 *
 * 	The 'appMapping' points by default to the '/root ' mapping created in  the test folder Application.cfc.  Please note that this
 * 	Application.cfc must mimic the real one in your root, including ORM  settings if needed.
 *
 *	The 'execute()' method is used to execute a ColdBox event, with the  following arguments
 *	- event : the name of the event
 *	- private : if the event is private or not
 *	- prePostExempt : if the event needs to be exempt of pre post interceptors
 *	- eventArguments : The struct of args to pass to the event
 *	- renderResults : Render back the results of the event
 *
 * You can also use the HTTP executables: get(), post(), put(), path(), delete(), request()
 **/
component extends="tests.resources.BaseIntegrationSpec" {

	// DI
	property name="qb"     inject="QueryBuilder@qb";
	property name="bcrypt" inject="@BCrypt";
	property name="auth"   inject="authenticationService@cbauth";

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
		variables.testUser     = qb.from( "users" ).first();
		variables.testPassword = "test";
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		feature( "Crud for rants", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				auth.logout();
			} );

			it( "can display all rants", function(){
				var event = get( "/rants" );
				expect( event.getPrivateValue( "aRants" ) ).toBeArray();
				expect( event.getRenderedContent() ).toInclude( "All Rants" );
			} );

			it( "can display the rants index when no rants exists", function(){
				prepareMock( getInstance( "RantsService" ) ).$( "list", [] );
				var event = get( "/rants" );

				getWireBox().clearSingletons();

				expect( event.getPrivateValue( "aRants" ) ).toBeEmpty();
				expect( event.getRenderedContent() ).toInclude( "No rants yet" );
			} );

			it( "can display the new rant form", function(){
				var event = get( "/rants/new" );
				expect( event.getRenderedContent() ).toInclude( "Start a Rant" );
			} );

			it( "can stop a rant from being created from an invalid user", function(){
				expect( function(){
					var event = post( route = "rants", params = { body : "Test Rant" } );
				} ).toThrow( type = "NoUserLoggedIn" );
			} );

			it( "can create a rant from a valid user", function(){
				// Log in user
				auth.authenticate( testUser.email, testPassword );
				var event = post( route = "rants", params = { body : "Test Rant" } );
				var prc   = event.getPrivateCollection();
				expect( prc.oRant.isLoaded() ).toBeTrue();
				expect( prc.oRant.getBody() ).toBe( "Test Rant" );
				expect( event.getValue( "relocate_event" ) ).toBe( "rants" );
			} );

            it( "can delete a rant if you are logged in", function(){
				// Log in user
				auth.authenticate( testUser.email, testPassword );
				var testId = qb
					.select( "id" )
					.from( "rants" )
					.first()
					.id;
				var event = delete( "/rants/#testId#" );
				expect( event.getValue( "relocate_event" ) ).toBe( "rants" );
			} );
		} );
	}

}
```

## Resources Router

Add the rants resources in the `Router.cfc` file

```js
resources("rants");
```

## Event Handler: `rants`

Let's build it out.

```js
/**
 * Manage rants
 * It will be your responsibility to fine tune this template, add validations, try/catch blocks, logging, etc.
 */
component extends="coldbox.system.EventHandler" {

	// DI
	property name="rantsService" inject;

	/**
	 * Display a list of rants
	 */
	function index( event, rc, prc ){
		prc.aRants = rantsService.list()
		event.setView( "rants/index" );
	}

	/**
	 * Return an HTML form for creating a rant
	 */
	function new( event, rc, prc ){
        prc.oRant = rantsService.new();
		event.setView( "rants/new" );
	}

	/**
	 * Create a rant
	 */
	function create( event, rc, prc ){
		prc.oRant = populateModel( "Rant" ).setUserId( auth().getUserId() );

		validate( prc.oRant )
			.onSuccess( ( result ) => {
				rantsService.create( prc.oRant );
				cbMessageBox().info( "Rant created!" );
				relocate( "rants" );
			} )
			.onError( ( result ) => {
				cbMessageBox().error( result.getAllErrors() );
				new ( argumentCollection = arguments );
			} );
	}

	/**
	 * Show a rant
	 */
	function show( event, rc, prc ){
		event.paramValue( "id", 0 );
		prc.oRant = rantsService.get( rc.id );
		event.setView( "rants/show" );
	}

	/**
	 * Edit a rant
	 */
	function edit( event, rc, prc ){
		event.paramValue( "id", 0 );
		prc.oRant = rantsService.get( rc.id );
		event.setView( "rants/edit" );
	}

	/**
	 * Update a rant
	 */
	function update( event, rc, prc ){
		event.paramValue( "id", 0 );
		prc.oRant = populateModel( rantsService.get( rc.id ) ).setUserId( auth().getUserId() );

		validate( prc.oRant )
			.onSuccess( ( result ) => {
				rantsService.update( prc.oRant );
				cbMessageBox().info( "Rant updated!" );
				relocate( "rants" );
			} )
			.onError( ( result ) => {
				cbMessageBox().error( result.getAllErrors() );
				edit( argumentCollection = arguments );
			} );
	}

	/**
	 * Delete a rant
	 */
	function delete( event, rc, prc ){
		rantsService.delete( rc.id ?: 0 );
		cbMessageBox().info( "Rant deleted!" );
		relocate( "rants" );
	}

}
```

## Model: `Rant`

Let's open the model and modify it a bit:

```js
/**
 * I model a rants
 */
component accessors="true" {

	// DI
	property name="userService" inject;

	// Properties
	property
		name   ="id"
		type   ="string"
		default="";
	property
		name   ="body"
		type   ="string"
		default="";
	property name="createdDate"  type="date";
	property name="modifiedDate" type="date";
	property
		name   ="userID"
		type   ="string"
		default="";

	// Validation Control
	this.constraints = {
		body   : { required : true },
		userId : { required : true, type : "numeric" }
	};

	// Population Control
	this.population = { excludes : "userId" };

	/**
	 * Constructor
	 */
	Rant function init(){
		variables.createdDate = now();
		return this;
	}

	/**
	 * Get the user that created this rant
	 */
	User function getUser(){
		// Lazy loading the relationship
		return userService.retrieveUserById( getUserId() );
	}

	/**
	 * Verify if this is a persisted or new user
	 */
	boolean function isLoaded(){
		return ( !isNull( variables.id ) && len( variables.id ) );
	}

}
```

Work on the unit test, what will you test?

```js
/**
 * The base model test case will use the 'model' annotation as the instantiation path
 * and then create it, prepare it for mocking and then place it in the variables scope as 'model'. It is your
 * responsibility to update the model annotation instantiation path and init your model.
 */
component extends="coldbox.system.testing.BaseModelTest" model="models.Rant" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		// setup the model
		super.setup();

		// init the model object
		model.init();
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "Rants Suite", function(){
			it( "can be created", function(){
				expect( model ).toBeComponent();
			} );

			it( "can check if it's a new rant", function(){
				expect( model.isLoaded() ).toBeFalse();
			} );

			it( "can check if it's a persisted rant", function(){
				expect( model.setId( 1 ).isLoaded() ).toBeTrue();
			} );
		} );
	}

}
```

## Model: `RantService`

Let's work on our rant service now:

```js
/**
 * I manage rants
 */
component singleton accessors="true" {

	// To populate objects from data
	property name="populator" inject="wirebox:populator";

	/**
	 * Constructor
	 */
	RantsService function init(){
		return this;
	}

	/**
	 * Provider of Rant objects
	 */
	Rant function new() provider="Rant"{
	}

	/**
	 * Create a new rant
	 *
	 * @rant The rant to create
	 */
	Rant function create( required rant ){
		arguments.rant.setModifiedDate( now() );
		queryExecute(
			"
                INSERT INTO `rants` (`body`, `modifiedDate`, `userId`)
                VALUES (:body, :modifiedDate, :userId)
            ",
			{
				body         : rant.getBody(),
				modifiedDate : { value : rant.getModifiedDate(), type : "timestamp" },
				userId       : rant.getUserId()
			},
			{ result : "local.result" }
		);
		return rant.setId( result.generatedKey );
	}

	/**
	 * Update a persisted rant
	 *
	 * @rant The rant to save
	 */
	Rant function update( required rant ){
		arguments.rant.setModifiedDate( now() );
		queryExecute(
			"
                UPDATE `rants`
                SET body = :body, modifiedDate = :modifiedDate, userId = :userId
				WHERE id = :id
            ",
			{
				id           : rant.getId(),
				body         : rant.getBody(),
				modifiedDate : { value : rant.getModifiedDate(), type : "timestamp" },
				userId       : rant.getUserId()
			},
			{ result : "local.result" }
		);
		return rant;
	}

	/**
	 * Delete a rant by id
	 */
	function delete( required numeric rantId ){
		queryExecute( "DELETE FROM `rants` WHERE id = :id", { id : arguments.rantId } );
	}

	/**
	 * Get all rants
	 */
	array function list(){
		return queryExecute(
			"SELECT * FROM `rants` ORDER BY `createdDate` DESC",
			[],
			{ returntype : "array" }
		).map( ( rant ) => populator.populateFromStruct( new (), rant ) );
	}

	/**
	 * Get a specific rant by id. If not found, return an unpersisted new Rant
	 *
	 * @return A persisted rant by ID or a new rant
	 */
	Rant function get( required rantId ){
		return queryExecute(
			"SELECT * FROM `rants` where id = :id",
			{ id : arguments.rantId },
			{ returntype : "array" }
		).reduce( ( result, rant ) => populator.populateFromStruct( result, rant ), new () );
	}

}

```

Now the unit test:

```js
describe("RantService Suite", function () {
  it("can be created", function () {
    expect(model).toBeComponent();
  });
});
```

Why not create more unit tests?

## The `index` view

```html
<cfoutput>
<div class="container mt-2">
	<h2>All Rants</h2>

	<cfif prc.aRants.isEmpty()>
		<div class="alert alert-info">
			No rants yet, why not create some?
		</div>
		<cfif auth().isLoggedIn()>
			<a
				href="#event.buildLink( "rants.new" )#"
				class="btn btn-outline-primary">Start a Rant!</a>
		<cfelse>
			<a
				href="#event.buildLink( "registration/new" )#"
				class="btn btn-outline-success">Register</a>
			<a
				href="#event.buildLink( "login" )#"
				class="btn btn-outline-success">Log In</a>
		</cfif>
	<cfelse>

		<cfif auth().isLoggedIn()>
		<a
			href="#event.buildLink( "rants.new" )#"
			class="btn btn-primary">Start a Rant!</a>
		</cfif>

		<div class="mt-3">
			<cfloop array="#prc.aRants#" item="rant">
				<div class="card mb-3">
					<div class="card-header d-flex align-items-center justify-content-between">
						<span class="me">
							<i class="bi bi-chat-left-text me-2"></i>
							#rant.getUser().getEmail()#
						</span>

						<div class="dropdown">
							<button class="btn btn-sm btn-light fs-5" type="button" data-bs-toggle="dropdown" aria-expanded="false">
								<i class="bi bi-three-dots-vertical"></i>
							</button>
							<ul class="dropdown-menu">
								<li>
									<a class="dropdown-item" href="##">Edit</a>
								</li>
								<li>
									#html.startForm( method : "DELETE", action : "rants/#rant.getId()#" )#
										<button class="dropdown-item" type="submit">Delete</button>
									#html.endForm()#
								</li>
							</ul>
						</div>

					</div>
					<div class="card-body">
						#rant.getBody()#
					</div>
					<div class="card-footer">
						<span class="badge text-bg-light">
							#dateTimeFormat( rant.getCreatedDate(), "h:nn:ss tt" )#
						on #dateFormat( rant.getCreatedDate(), "mmm d, yyyy")#
						</span>
					</div>
				</div>
			</cfloop>
		</div>
	</cfif>
</div>
</cfoutput>
```

## Default Event to `rants.index`

We want our rants to be the homepage instead of the default one.

```js
//config/ColdBox.cfc
// inside the coldbox struct
coldbox = {
    defaultEvent : "rants.index",
    ...
};
```

Hit http://127.0.0.1:42518/ and you'll see the `main.index` with the dump. ColdBox settings require a framework reinit.

## The `new` view

```html
<cfoutput>
  <div class="container">
    <div class="card">
      <div class="card-header">
        <h4>Start a Rant</h4>
      </div>

      <div class="card-body">
        #html.startForm( action : "rants" )# #html.textarea( name : "body",
        class : "form-control", rows : 10, placeholder : "What's on your mind?",
        groupWrapper : "div class='mb-3'", value : rc.body )#

        <div class="d-flex justify-content-end">
          <a
            href="#event.buildLink( 'rants' )#"
            class="btn btn-outline-secondary"
            >Cancel</a
          >
          <button type="submit" class="btn btn-outline-success ms-auto">
            Rant it!
          </button>
        </div>

        #html.endForm()#
      </div>
    </div>
  </div>
</cfoutput>
```

## Update the Main Layout

```html
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
	<div class="container-fluid">

		<!---Brand --->
		<a class="navbar-brand text-info" href="#event.buildLink( '' )#">
			<i class="bi bi-boombox"></i>
			<strong>SoapBox</strong>
		</a>

		<!--- Mobile Toggler --->
		<button
			class="navbar-toggler"
			type="button"
			data-bs-toggle="collapse"
			data-bs-target="##navbarSupportedContent"
			aria-controls="navbarSupportedContent"
			aria-expanded="false"
			aria-label="Toggle navigation"
		>
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="navbarSupportedContent">
			<!--- Left Aligned --->
			<ul class="navbar-nav me-auto mb-2 mb-lg-0">
				<!--- Logged In --->
					<li class="nav-item">
						<a
							class="nav-link #event.urlMatches( "registration/new" ) ? 'active' : ''#"
							href="#event.buildLink( 'registration.new' )#"
							>
							Register
						</a>
					</li>
					<li class="nav-item">
						<a
							class="nav-link #event.routeIs( "login" ) ? 'active' : ''#"
							href="#event.route( 'login' )#"
							>
							Log in
						</a>
					</li>
					<li class="nav-item">
						<a href="#event.buildLink( "rants.new" )#" class="btn btn-outline-info">Start a Rant</a>
					</li>
			</ul>

			<!--- Right Aligned --->
			<div class="ms-auto d-flex">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0">
					<li class="nav-item me-2">
						<a
							class="nav-link #event.routeIs( "about" ) ? 'active' : ''#"
							href="#event.buildLink( 'about' )#"
							>
							About
						</a>
					</li>
				</ul>
                <form method="POST" action="#event.buildLink( "logout" )#">
                    <input type="hidden" name="_method" value="DELETE" />
                    <button class="btn btn-outline-success" type="submit">Log Out</button>
                </form>
			</div>
		</div>
	</div>
</nav>
```

Hit http://127.0.0.1:42518/ and click on Start a rant and you'll see the form.
Log out and try, and you can still see the form. Try to create a rant and you'll see an error!

We need to secure the form, to ensure the user is logged in before they can send a rant.
