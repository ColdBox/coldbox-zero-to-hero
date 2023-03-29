/**
 * I am a user in SoapBox
 */
component accessors="true" delegates="Authorizable@cbsecurity" {

	// Properties
	property name="id"              type="numeric";
	property name="name"            type="string";
	property name="email"           type="string";
	property name="password"        type="string";
	property name="confirmPassword" type="string";
	property name="createdDate"     type="date";
	property name="modifiedDate"    type="date";
	property name="roles"           type="array";
	property name="permissions"     type="array";

	// Validation
	this.constraints = {
		name  : { required : true },
		email : {
			required : true,
			type     : "email",
			unique   : { table : "users" }
		},
		password        : { required : true, size : "10..100" },
		confirmpassword : { required : true, sameAs : "password" }
	};
	this.constraintProfiles = {
		"update"     : "name,email",
		"passUpdate" : "password,confirmpassword"
	}

	/**
	 * Constructor
	 */
	User function init(){
		variables.roles       = [];
		variables.permissions = [];
		return this;
	}

	/**
	 * Verify if this is a persisted or new user
	 */
	boolean function isLoaded(){
		return ( !isNull( variables.id ) && len( variables.id ) );
	}

}
