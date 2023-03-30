/**
 * I model a rants
 */
component accessors="true" {

	// DI
	property name="userService"     inject;
	property name="reactionService" inject;

	// Properties
	property
		name   ="id"  
		type   ="string"
		default="";
	property
		name   ="body"
		type   ="string"
		default="";
	property name="createdDate"  type="date";
	property name="modifiedDate" type="date";
	property
		name   ="userID"
		type   ="string"
		default="";

	// Validation Control
	this.constraints = {
		body   : { required : true },
		userId : { required : true, type : "numeric" }
	};

	// Population Control
	this.population = { excludes : "userId" };

	/**
	 * Constructor
	 */
	Rant function init(){
		variables.createdDate = now();
		return this;
	}

	/**
	 * Get the user that created this rant
	 */
	User function getUser(){
		if ( isNull( variables.user ) ) {
			// Lazy loading the relationship
			variables.user = userService.retrieveUserById( getUserId() );
		}
		return variables.user;
	}

	/**
	 * Get the bumps this rant has
	 */
	function getBumps(){
		if ( isNull( variables.bumps ) ) {
			// Lazy loading the relationship
			variables.bumps = reactionService.getBumpsForRant( this );
		}
		return variables.bumps;
	}

	/**
	 * Get the poops this rant has
	 */
	function getPoops(){
		if ( isNull( variables.poops ) ) {
			// Lazy loading the relationship
			variables.poops = reactionService.getPoopsForRant( this );
		}
		return variables.poops;
	}

	/**
	 * Verify if this is a persisted or new user
	 */
	boolean function isLoaded(){
		return ( !isNull( variables.id ) && len( variables.id ) );
	}

}
