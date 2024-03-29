/**
 * This is your application router.  From here you can controll all the incoming routes to your application.
 *
 * https://coldbox.ortusbooks.com/the-basics/routing
 */
component {

	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * Router Configuration Directives
		 * --------------------------------------------------------------------------
		 * https://coldbox.ortusbooks.com/the-basics/routing/application-router#configuration-methods
		 */
		setFullRewrites( true );

		/**
		 * --------------------------------------------------------------------------
		 * App Routes
		 * --------------------------------------------------------------------------
		 * Here is where you can register the routes for your web application!
		 * Go get Funky!
		 */

		// A nice healthcheck route example
		route( "/healthcheck", function( event, rc, prc ){
			return "Ok!";
		} );

		// A nice RESTFul Route example
		route( "/api/echo", function( event, rc, prc ){
			return { "error" : false, "data" : "Welcome to my awesome API!" };
		} );

		// About Page
		route( "about", "about.index" );
		// route( "/about" ).as( "about" ).to( "about.index" ); Same as above

		// Registration Flow
		resources( resource: "registration", only: "new,create" );

		// Login Flow
		GET( "/login" ).as( "login" ).to( "sessions.new" );
		POST( "/login" ).to( "sessions.create" );
		// Logout
		delete( "/logout" ).as( "logout" ).to( "sessions.delete" );

		// Bump Rants
		route( "rants/:id/bumps" )
			.as( "bumps" )
			.withAction( { "POST" : "create", "DELETE" : "delete" } )
			.toHandler( "Bumps" );

		// Poop Rants
		route( "rants/:id/poops" )
			.as( "poops" )
			.withAction( { "POST" : "create", "DELETE" : "delete" } )
			.toHandler( "poops" );

		// Rants
		resources( "rants" );

		// User Rants
		get( "/users/:id" ).as( "user.rants" ).to( "users.show" );

		// @app_routes@

		// Conventions-Based Routing
		route( ":handler/:action?" ).end();
	}

}
