/**
 * Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 */
component {

	// APPLICATION CFC PROPERTIES
	this.name                 = "ColdBoxTestingSuite";
	this.sessionManagement    = true;
	this.setClientCookies     = true;
	this.sessionTimeout       = createTimespan( 0, 0, 15, 0 );
	this.applicationTimeout   = createTimespan( 0, 0, 15, 0 );
	this.whiteSpaceManagement = "smart";
	this.enableNullSupport    = shouldEnableFullNullSupport();

	/**
	 * --------------------------------------------------------------------------
	 * Location Mappings
	 * --------------------------------------------------------------------------
	 * - cbApp : Quick reference to root application
	 * - coldbox : Where ColdBox library is installed
	 * - testbox : Where TestBox is installed
	 */
	// Create testing mapping
	this.mappings[ "/tests" ]   = getDirectoryFromPath( getCurrentTemplatePath() );
	// The root application mapping
	rootPath                    = reReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
	this.mappings[ "/root" ]    = this.mappings[ "/cbapp" ] = rootPath;
	this.mappings[ "/coldbox" ] = rootPath & "coldbox";
	this.mappings[ "/testbox" ] = rootPath & "testbox";

	/**
	 * --------------------------------------------------------------------------
	 * ORM + Datasource Settings
	 * --------------------------------------------------------------------------
	 */
	this.datasource = "soapbox";

	/**
	 * Fires on every test request. It builds a Virtual ColdBox application for you
	 *
	 * @targetPage The requested page
	 */
	public boolean function onRequestStart( targetPage ){
		// Set a high timeout for long running tests
		setting requestTimeout   ="9999";
		// New ColdBox Virtual Application Starter
		request.coldBoxVirtualApp= new coldbox.system.testing.VirtualApp( appMapping = "/root" );

		// Reload for fresh results
		if ( structKeyExists( url, "fwreinit" ) ) {
			if ( structKeyExists( server, "lucee" ) ) {
				pagePoolClear();
			}
			// ormReload();
			request.coldBoxVirtualApp.restart();
		}

		// If hitting the runner or specs, prep our virtual app
		if ( getBaseTemplatePath().replace( expandPath( "/tests" ), "" ).reFindNoCase( "(runner|specs)" ) ) {
			request.coldBoxVirtualApp.startup();
			seedDatabase();
		}

		return true;
	}

	private function seedDatabase(){
		var controller       = request.coldBoxVirtualApp.getController();
		var migrationService = controller
			.getWireBox()
			.getInstance(
				name         : "MigrationService@cfmigrations",
				initArguments: {
					migrationsDirectory : "/root/resources/database/migrations",
					seedsDirectory      : "/root/resources/database/seeds",
					properties          : {
						datasource     : "soapbox",
						defaultGrammar : "AutoDiscover@qb",
						schema         : "soapbox"
					}
				}
			);

		var sTime = getTickCount();
		systemOutput( "Refreshing Database...", true );
		migrationService.reset();
		migrationService.install( runAll: true );
		systemOutput( "Database Refreshed in #numberFormat( getTickCount() - sTime )#", true );

		var sTime = getTickCount();
		systemOutput( "Seeding Database...", true );
		migrationService.seed( "TestFixtures" );
		systemOutput( "Database seeded in #numberFormat( getTickCount() - sTime )#", true );
	}

	/**
	 * Fires when the testing requests end and the ColdBox application is shutdown
	 */
	public void function onRequestEnd( required targetPage ){
		request.coldBoxVirtualApp.shutdown();
	}

	private boolean function shouldEnableFullNullSupport(){
		var system = createObject( "java", "java.lang.System" );
		var value  = system.getEnv( "FULL_NULL" );
		return isNull( value ) ? false : !!value;
	}

}
