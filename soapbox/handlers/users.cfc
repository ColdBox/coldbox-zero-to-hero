/**
 * I manage user rants
 */
component {

	// DI
	property name="userService" inject;

	/**
	 * Show user rants
	 */
	function show( event, rc, prc ){
		prc.oUser = userService.retrieveUserById( rc.id ?: "" );
		if ( !prc.oUser.isLoaded() ) {
			relocate( "404" );
		}
		event.setView( "users/show" );
	}

}
