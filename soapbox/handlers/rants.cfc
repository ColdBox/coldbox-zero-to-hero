/**
 * Manage rants
 * It will be your responsibility to fine tune this template, add validations, try/catch blocks, logging, etc.
 */
component extends="coldbox.system.EventHandler" {

	// DI
	property name="rantsService" inject;

	/**
	 * Display a list of rants
	 */
	function index( event, rc, prc ){
		prc.aRants = rantsService.list()
		event.setView( "rants/index" );
	}

	/**
	 * Return an HTML form for creating a rant
	 */
	function new( event, rc, prc ){
		param rc.body = "";
		event.setView( "rants/new" );
	}

	/**
	 * Create a rant
	 */
	function create( event, rc, prc ){
		prc.oRant = populateModel( "Rant" ).setUserId( auth().getUserId() );

		validate( prc.oRant )
			.onSuccess( ( result ) => {
				rantsService.save( prc.oRant );
				cbMessageBox().info( "Rant created!" );
				relocate( "rants" );
			} )
			.onError( ( result ) => {
				cbMessageBox().error( result.getAllErrors() );
				new ( argumentCollection = arguments );
			} );
	}

	/**
	 * Show a rant
	 */
	function show( event, rc, prc ){
		event.paramValue( "id", 0 );
		prc.oRant = rantsService.get( rc.id );
		event.setView( "rants/show" );
	}

	/**
	 * Edit a rant
	 */
	function edit( event, rc, prc ){
		event.paramValue( "id", 0 );
		prc.oRant = rantsService.get( rc.id );
		event.setView( "rants/edit" );
	}

	/**
	 * Update a rant
	 */
	function update( event, rc, prc ){
		event.paramValue( "id", 0 );
		prc.oRant = populateModel( rantService.get( rc.id ) );

		validate( prc.oRant )
			.onSuccess( ( result ) => {
				rantsService.create( prc.oRant );
				cbMessageBox().info( "Rant updated!" );
				relocate( "rants" );
			} )
			.onError( ( result ) => {
				cbMessageBox().error( result.getAllErrors() );
				edit( argumentCollection = arguments );
			} );
	}

	/**
	 * Delete a rant
	 */
	function delete( event, rc, prc ){
		event.paramValue( "id", 0 );
		rantService.delete( rc.id );
		cbMessageBox().info( "Rant deleted!" );
		relocate( "rants" );
	}

}
