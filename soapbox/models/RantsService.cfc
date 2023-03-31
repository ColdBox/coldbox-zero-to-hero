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
	 * Create a new rant
	 *
	 * @rant The rant to create
	 */
	Rant function create( required rant ){
		arguments.rant.setModifiedDate( now() );
		queryExecute(
			"
                INSERT INTO `rants` (`body`, `modifiedDate`, `userId`)
                VALUES (:body, :modifiedDate, :userId)
            ",
			{
				body         : rant.getBody(),
				modifiedDate : { value : rant.getModifiedDate(), type : "timestamp" },
				userId       : rant.getUserId()
			},
			{ result : "local.result" }
		);
		return rant.setId( result.generatedKey );
	}

	/**
	 * Update a persisted rant
	 *
	 * @rant The rant to save
	 */
	Rant function update( required rant ){
		arguments.rant.setModifiedDate( now() );
		queryExecute(
			"
                UPDATE `rants`
                SET body = :body, modifiedDate = :modifiedDate, userId = :userId
				WHERE id = :id
            ",
			{
				id           : rant.getId(),
				body         : rant.getBody(),
				modifiedDate : { value : rant.getModifiedDate(), type : "timestamp" },
				userId       : rant.getUserId()
			},
			{ result : "local.result" }
		);
		return rant;
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
		).reduce( ( result, rant ) => populator.populateFromStruct( result, rant ), new () );
	}

	array function findByUser( required userId ){
		return queryExecute(
			"SELECT * FROM `rants` WHERE `userId` = ? ORDER BY `createdDate` DESC",
			[ userId ],
			{ returntype : "array" }
		).map( function( rant ){
			return populator.populateFromStruct( new (), rant );
		} );
	}

}
