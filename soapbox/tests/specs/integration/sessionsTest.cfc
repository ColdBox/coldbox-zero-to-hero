/*******************************************************************************
 *	Integration Test as BDD (CF10+ or Railo 4.1 Plus)
 *
 *	Extends the integration class: coldbox.system.testing.BaseTestCase
 *
 *	so you can test your ColdBox application headlessly. The 'appMapping' points by default to
 *	the '/root' mapping created in the test folder Application.cfc.  Please note that this
 *	Application.cfc must mimic the real one in your root, including ORM settings if needed.
 *
 *	The 'execute()' method is used to execute a ColdBox event, with the following arguments
 *	* event : the name of the event
 *	* private : if the event is private or not
 *	* prePostExempt : if the event needs to be exempt of pre post interceptors
 *	* eventArguments : The struct of args to pass to the event
 *	* renderResults : Render back the results of the event
 *******************************************************************************/
component extends="tests.resources.BaseIntegrationSpec" {

	property name="query"  inject="provider:QueryBuilder@qb";
	property name="auth"   inject="authenticationService@cbauth";
	property name="bcrypt" inject="@BCrypt";

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();

		variables.testUser     = query.from( "users" ).first();
		variables.testPassword = "test";
	}

	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		feature( "Login and Logout Users", function(){
			beforeEach( function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				auth.logout();
			} );

			it( "can present the login screen", function(){
				var event = get( route = "/login" );
				expect( event.getRenderedContent() ).toInclude( "SoapBox Log In" );
			} );

			it( "can log in a valid user", function(){
				var event = post( route = "/login", params = { email : testUser.email, password : testPassword } );
				expect( event.getValue( "relocate_URI" ) ).toBe( "/" );
				expect( auth.isLoggedIn() ).toBeTrue();
			} );

			it( "can show an invalid message for an invalid user", function(){
				var event = post(
					route  = "/login",
					params = { username : "testuser@tests.com", password : "bad" }
				);
				expect( event.getValue( "relocate_event" ) ).toBe( "login" );
				expect( auth.isLoggedIn() ).toBeFalse();
			} );

			it( "can logout a user", function(){
				auth.authenticate( testUser.email, testPassword );
				expect( auth.isLoggedIn() ).toBeTrue();

				var event = delete( route = "/logout" );

				expect( auth.isLoggedIn() ).toBeFalse();
				expect( event.getValue( "relocate_URI" ) ).toBe( "/" );
			} );
		} );
	}

}
