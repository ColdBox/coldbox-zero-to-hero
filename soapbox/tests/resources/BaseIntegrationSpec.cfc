/**
 * Base test bundle for our application
 *
 * @see https://coldbox.ortusbooks.com/testing/testing-coldbox-applications/integration-testing
 */
component extends="coldbox.system.testing.BaseTestCase" autowire {

	/**
	 * --------------------------------------------------------------------------
	 * Dependency Injections
	 * --------------------------------------------------------------------------
	 */

	/**
	 * --------------------------------------------------------------------------
	 * Integration testing controls
	 * --------------------------------------------------------------------------
	 * - We want the ColdBox virtual application to load once per request and get destroyed at the end of the request.
	 */
	this.loadColdBox   = true;
	this.unloadColdBox = false;

	/**
	 * Run Before all tests
	 */
	function beforeAll(){
		super.beforeAll();
	}

	/**
	 * This function is tagged as an around each handler.  All the integration tests we build
	 * will be automatically rolledbacked so we don't corrupt the database with our tests
	 *
	 * @aroundEach
	 */
	function wrapInTransaction( spec ){
		transaction action="begin" {
			try {
				arguments.spec.body( argumentCollection = arguments );
			} catch ( any e ) {
				rethrow;
			} finally {
				transaction action="rollback";
			}
		}
	}

}
