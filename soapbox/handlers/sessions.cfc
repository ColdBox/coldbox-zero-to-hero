/**
 * I manage logins and logouts
 */
component {

	/**
	 * Show the login screen
	 */
	function new( event, rc, prc ){
		event.setView( "sessions/new" );
	}

	/**
	 * Login a user
	 */
	function create( event, rc, prc ){
		// Validate Token
		if ( !csrfVerify( rc.csrf ?: "" ) ) {
			cbMessageBox().error( "Invalid Security Token!" );
			return back();
		}
		try {
			cbsecure().authenticate( rc.email ?: "", rc.password ?: "" );
			cbMessageBox().success( "Welcome back #encodeForHTML( rc.email )#" );
			return relocate( uri = "/" );
		} catch ( InvalidCredentials e ) {
			cbMessageBox().error( e.message );
			return relocate( "login" );
		}
	}

	/**
	 * Logout a user
	 */
	function delete( event, rc, prc ){
		cbMessageBox().success( "Bye Bye! See you soon!" );
		cbsecure().logout();
		relocate( uri = "/" );
	}

}
