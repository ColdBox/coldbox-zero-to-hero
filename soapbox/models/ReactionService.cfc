/**
 * I am a new Model Object
 */
component accessors="true" {

	// DI
	property name="populator" inject="wirebox:populator";

	function newBump() provider="Bump"{
	};
	function newPoop() provider="Poop"{
	};

	/**
	 * Constructor
	 */
	ReactionService function init(){
		return this;
	}

	/**
	 * Get bumps for a specific rant object
	 *
	 * @rant The rant to filter on
	 *
	 * @return array of bumps found
	 */
	function getBumpsForRant( required rant ){
		return queryExecute(
			"SELECT * FROM `bumps` WHERE `rantId` = ?",
			[ rant.getId() ],
			{ returntype : "array" }
		).map( function( bump ){
			return populator.populateFromStruct( newBump(), bump )
		} );
	}

	/**
	 * Get poops for a specific rant object
	 *
	 * @rant The rant to filter on
	 *
	 * @return array of poops found
	 */
	function getPoopsForRant( required rant ){
		return queryExecute(
			"SELECT * FROM `poops` WHERE `rantId` = ?",
			[ rant.getId() ],
			{ returntype : "array" }
		).map( function( poop ){
			return populator.populateFromStruct( newPoop(), poop )
		} );
	}

	/**
	 * Get the bumps of a specific user
	 *
	 * @user The target user
	 *
	 * @return array of bumps found
	 */
	array function getBumpsForUser( user ){
		return queryExecute(
			"SELECT * FROM `bumps` WHERE `userId` = ?",
			[ user.getId() ],
			{ returntype : "array" }
		).map( function( bump ){
			return populator.populateFromStruct( newBump(), bump )
		} );
	}

	/**
	 * Get the poops of a specific user
	 *
	 * @user The target user
	 *
	 * @return array of poops found
	 */
	function getPoopsForUser( user ){
		return queryExecute(
			"SELECT * FROM `poops` WHERE `userId` = ?",
			[ user.getId() ],
			{ returntype : "array" }
		).map( function( poop ){
			return populator.populateFromStruct( newPoop(), poop )
		} );
	}

	/**
	 * Bump a rant
	 *
	 * @rantId The rant to bump
	 * @userId The user doing the bumping
	 */
	ReactionService function bump( required rantId, required userId ){
		queryExecute( "INSERT INTO `bumps` VALUES (?, ?)", [ arguments.userId, arguments.rantId ] );
		return this;
	}

	/**
	 * Unbump a rant
	 *
	 * @rantId The rant to unbump
	 * @userId The user doing the bumping
	 */
	ReactionService function unbump( required rantId, required userId ){
		queryExecute(
			"DELETE FROM `bumps` WHERE `userId` = ? AND `rantId` = ?",
			[ arguments.userId, arguments.rantId ]
		);
		return this;
	}

	/**
	 * Poop a rant
	 *
	 * @rantId The rant to bump
	 * @userId The user doing the bumping
	 */
	ReactionService function poop( rantId, userId ){
		queryExecute( "INSERT INTO `poops` VALUES (?, ?)", [ arguments.userId, arguments.rantId ] );
		return this;
	}

	/**
	 * unpoop a rant
	 *
	 * @rantId The rant to unpoop
	 * @userId The user doing the bumping
	 */
	ReactionService function unpoop( rantId, userId ){
		queryExecute(
			"DELETE FROM `poops` WHERE `userId` = ? AND `rantId` = ?",
			[ arguments.userId, arguments.rantId ]
		);
		return this;
	}

}
