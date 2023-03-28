/**
 * I model a rants
 */
component accessors="true" {

	// DI
	property name="userService" inject;

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
		// Lazy loading the relationship
		return userService.retrieveUserById( getUserId() );
	}

	/**
	 * Verify if this is a persisted or new user
	 */
	boolean function isLoaded(){
		return ( !isNull( variables.id ) && len( variables.id ) );
	}

}
