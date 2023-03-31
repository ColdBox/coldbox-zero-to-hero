component extends="tests.resources.BaseIntegrationSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
		variables.testUser = getTestUser();
		auth.authenticate( testUser.email, testPassword );
		variables.testRantId = qb.from( "rants" ).first().id;
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		feature( "User Poop Reactions", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );

			it( "can poop on a rant", function(){
				var event = post( route = "poops", params = { id : testRantId, csrf : csrfToken() } );
				var prc   = event.getPrivateCollection();
			} );

			it( "can unpoop a rant", function(){
				var event = delete( route = "poops", params = { id : testRantId, csrf : csrfToken() } );
				var prc   = event.getPrivateCollection();
			} );
		} );
	}

}
