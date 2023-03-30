component extends="tests.resources.BaseIntegrationSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		feature( "User Rants Page", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );

			story( "I want to display a user's rants with a unique user url", () => {
				given( "an invalid user id", function(){
					then( "a 404 page will be shown", function(){
						var event = GET( "/users/invalid" );
						expect( event.getValue( "relocate_event" ) ).toBe( "404" );
					} );
				} );

				given( "a valid id", function(){
					then( "the user's rants will be displayed", function(){
						var testUser = getTestUser();
						var event    = GET( "/users/#testUser.id#" );
						// expectations go here.
						expect( event.getPrivateValue( "oUser" ).isLoaded() ).toBeTrue();
						expect( event.getRenderedContent() ).toInclude( "#testUser.name#" );
					} );
				} );
			} );
		} );
	}

}
