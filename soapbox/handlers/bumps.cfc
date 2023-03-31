/**
 * I am a new handler
 */
component {

	property name="reactionService" inject;

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		param rc.id      = 0;
		prc.oCurrentUser = auth().getUser();
		// Validate Token
		if ( !csrfVerify( rc.csrf ?: "" ) ) {
			cbMessageBox().error( "Invalid Security Token!" );
			return back();
		}
	}

	/**
	 * Bump a rant
	 */
	function create( event, rc, prc ){
		reactionService.bump( rc.id, prc.oCurrentUser.getId() );
		relocate( "rants" );
	}

	/**
	 * Unbump the rant
	 */
	function delete( event, rc, prc ){
		reactionService.unbump( rc.id, prc.oCurrentUser.getId() );
		relocate( "rants" );
	}

}
