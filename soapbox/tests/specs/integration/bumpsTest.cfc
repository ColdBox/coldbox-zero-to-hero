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
		feature( "User bump Reactions", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );

			it( "can bump on a rant", function(){
				var event = post(
					route  = "/rants/#testRantId#/bumps",
					params = { id : testRantId, csrf : csrfToken() }
				);
				var prc = event.getPrivateCollection();
			} );

			it( "can unbump a rant", function(){
				var event = delete(
					route  = "/rants/#testRantId#/bumps",
					params = { id : testRantId, csrf : csrfToken() }
				);
				var prc = event.getPrivateCollection();
			} );
		} );
	}

}
