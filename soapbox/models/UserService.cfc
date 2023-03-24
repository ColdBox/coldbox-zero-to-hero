/**
 * I am a new Model Object
 */
component singleton accessors="true"{

	// Properties


	/**
	 * Constructor
	 */
	UserService function init(){

		return this;
	}

	/**
	 * list
	 */
	function list(){
		return queryExecute( "select * from users", {}, { returntype = "array" } );
	}


}
