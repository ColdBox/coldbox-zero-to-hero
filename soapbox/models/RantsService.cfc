/**
 * I manage rants
 */
component singleton accessors="true" {

	// To populate objects from data
	property name="populator" inject="wirebox:populator";

	/**
	 * Constructor
	 */
	RantsService function init(){
		return this;
	}

	/**
	 * Provider of Rant objects
	 */
	Rant function new() provider="Rant"{
	}

	/**
	 * Save a new or persisted rant
	 */
	Rant function save( required rant ){
		arguments.rant.setModifiedDate( now() );
		queryExecute(
			"
                INSERT IGNORE INTO `rants` (`body`, `modifiedDate`, `userId`)
                VALUES (?, ?, ?)
            ",
			[
				rant.getBody(),
				{ value : rant.getModifiedDate(), type : "timestamp" },
				rant.getUserId()
			],
			{ result : "local.result" }
		);
		return rant.isLoaded() ? rant : rant.setId( result.generatedKey );
	}

	/**
	 * Delete a rant by id
	 */
	function delete( required numeric rantId ){
		queryExecute( "DELETE FROM `rants` WHERE id = :id", { id : arguments.rantId } );
	}

	/**
	 * Get all rants
	 */
	array function list(){
		return queryExecute(
			"SELECT * FROM `rants` ORDER BY `createdDate` DESC",
			[],
			{ returntype : "array" }
		).map( ( rant ) => populator.populateFromStruct( new (), rant ) );
	}

	/**
	 * Get a specific rant by id. If not found, return an unpersisted new Rant
	 *
	 * @return A persisted rant by ID or a new rant
	 */
	Rant function get( required rantId ){
		return queryExecute(
			"SELECT * FROM `rants` where id = :id",
			{ id : arguments.rantId },
			{ returntype : "array" }
		).reduce( ( result, rant ) => populator.populateFormStruct( result, rant ), new () );
	}

}
