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

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
		variables.testUser = getTestUser();
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
				// Log in user
				auth.authenticate( testUser.email, testPassword );
				var event = get( "/rants/new" );
				expect( event.getRenderedContent() ).toInclude( "Start a Rant" );
			} );

			it( "can stop the display of the new rant form if you are not logged in", function(){
				var event = post( "rants/new" );
				expect( event.getValue( "relocate_event" ) ).toBe( "login" );
			} );

			it( "can stop a rant from being created from an invalid user", function(){
				expect( function(){
					var event = post( route = "rants", params = { body : "Test Rant", csrf : csrfToken() } );
				} ).toThrow( type = "NoUserLoggedIn" );
			} );

			it( "can create a rant from a valid user", function(){
				// Log in user
				auth.authenticate( testUser.email, testPassword );
				var event = post( route = "rants", params = { body : "Test Rant", csrf : csrfToken() } );
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
				var event = delete( route: "/rants/#testId#", params: { csrf : csrfToken() } );
				expect( event.getValue( "relocate_event" ) ).toBe( "rants" );
			} );
		} );
	}

}
