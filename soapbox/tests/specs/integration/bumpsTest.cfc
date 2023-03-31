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
		describe( "bumps Suite", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );

			it( "create", function(){
				// Execute event or route via GET http method. Spice up accordingly
				var event = get( "bumps.create" );
				// expectations go here.
				expect( false ).toBeTrue();
			} );

			it( "delete", function(){
				// Execute event or route via GET http method. Spice up accordingly
				var event = get( "bumps.delete" );
				// expectations go here.
				expect( false ).toBeTrue();
			} );
		} );
	}

}
