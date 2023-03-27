/**
 * User registration handler
 */
component {

	// DI
	property name="userService" inject;

	/**
	 * Show registration screen
	 */
	function new( event, rc, prc ){
		event.setView( "registration/new" );
	}

	/**
	 * Register a new user
	 */
	function create( event, rc, prc ){
		prc.oUser = userService.create( populateModel( "User" ) );

		flash.put(
			"notice",
			{
				type    : "success",
				message : "The user #encodeForHTML( prc.oUser.getEmail() )# with id: #prc.oUser.getId()# was created!"
			}
		);

		relocate( URI: "/" );
	}

}
