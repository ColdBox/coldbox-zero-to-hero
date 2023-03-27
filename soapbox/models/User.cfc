/**
 * I am a user in SoapBox
 */
component accessors="true" {

	// Properties
	property name="id"           type="numeric";
	property name="name"         type="string";
	property name="email"        type="string";
	property name="password"     type="string";
	property name="createdDate"  type="date";
	property name="modifiedDate" type="date";

	/**
	 * Constructor
	 */
	User function init(){
		return this;
	}

	/**
	 * Verify if this is a persisted or new user
	 */
	boolean function isLoaded(){
		return ( !isNull( variables.id ) && len( variables.id ) );
	}

}
