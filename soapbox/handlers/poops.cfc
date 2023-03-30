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
	}

	/**
	 * Poop a rant
	 */
	function create( event, rc, prc ){
		reactionService.poop( rc.id, prc.oCurrentUser.getId() );
		relocate( "rants" );
	}

	/**
	 * UnPoop the rant
	 */
	function delete( event, rc, prc ){
		reactionService.unPoop( rc.id, prc.oCurrentUser.getId() );
		relocate( "rants" );
	}

}
