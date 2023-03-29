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
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		feature( "User Registration", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			} );

			story( "I want to be able to display the new user registration form", function(){
				it( "should load the registration screen", function(){
					var event = get( "registration/new" );
					// expectations go here.
					expect( event.getRenderedContent() ).toInclude( "SoapBox Registration" );
				} );
			} );

			story( "I want to be able to register users in the system", function(){
				given( "valid data", function(){
					then( "I should register a new user", function(){
						expect(
							queryExecute(
								"select * from users where email = :email",
								{ email : "testadmin@soapbox.com" }
							)
						).toBeEmpty();

						var event = POST(
							"/registration",
							{
								name            : "BDD Test",
								email           : "testadmin@soapbox.com",
								password        : "passwordpassword",
								confirmPassword : "passwordpassword",
								csrf            : csrfToken()
							}
						);
						var prc = event.getPrivateCollection();
						// expectations go here.
						debug( prc.vResults ?: {} );
						expect( event.getValue( "relocate_URI" ) ).toBe( "/" );
						expect( prc.oUser.getEmail() ).toBe( "testadmin@soapbox.com" );
						expect( prc.oUser.isLoaded() ).toBeTrue();
					} )
				} );

				xgiven( "invalid registration data", function(){
					then( "I should show a validation error", function(){
						fail( "implement" );
					} )
				} );

				xgiven( "a non-unique email", function(){
					then( "I should show a validation error", function(){
						fail( "implement" );
					} )
				} );
			} );
		} );
	}

}
