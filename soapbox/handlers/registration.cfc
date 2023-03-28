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
		param rc.name  = "";
		param rc.email = "";
		event.setView( "registration/new" );
	}

	/**
	 * Register a new user
	 */
	function create( event, rc, prc ){
		prc.oUser = populateModel( "User" );

		validate( prc.oUser )
			.onError( ( results ) => {
				cbMessageBox().error( results.getAllErrors() );
				new ( argumentCollection = arguments );
			} )
			.onSuccess( ( results ) => {
				userService.create( prc.oUser );
				cbMessageBox().success( "The user #encodeForHTML( prc.oUser.getEmail() )# with id: #prc.oUser.getId()# was created!" );
				auth().login( prc.oUser );
				relocate( URI: "/" );
			} );
	}

}
