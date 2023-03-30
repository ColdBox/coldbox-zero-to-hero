/**
 * I am a user in SoapBox
 */
component accessors="true" delegates="Authorizable@cbsecurity" {

	// DI
	property name="rantsService"    inject;
	property name="reactionService" inject;

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
	property name="rants"           type="array";

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

	/**
	 * Get the user's rants if any
	 */
	array function getRants(){
		if ( isNull( variables.rants ) ) {
			variables.rants = rantsService.findByUser( getId() );
		}
		return variables.rants;
	}

	/**
	 * Has the user bumped the rant?
	 *
	 * @rant The targeted rant
	 */
	boolean function hasBumped( rant ){
		if ( isNull( variables.bumps ) ) {
			variables.bumps = reactionService.getBumpsForUser( this );
		}
		return !variables.bumps
			.filter( function( bump ){
				return bump.getRantId() == rant.getId();
			} )
			.isEmpty();
	}

	/**
	 * Has the user pooped the rant?
	 *
	 * @rant The targeted rant
	 */
	boolean function hasPooped( rant ){
		if ( isNull( variables.poops ) ) {
			variables.poops = reactionService.getPoopsForUser( this );
		}
		return !variables.poops
			.filter( function( poop ){
				return poop.getRantId() == rant.getId();
			} )
			.isEmpty();
	}

}
