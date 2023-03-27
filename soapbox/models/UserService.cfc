/**
 * I manage user objects
 */
component singleton accessors="true" {

	// DI
	property name="bcrypt" inject="@BCrypt";


	/**
	 * Constructor
	 */
	UserService function init(){
		return this;
	}

	/**
	 * Create a new empty User
	 */
	User function new() provider="User"{
	}

	/**
	 * list
	 */
	function list(){
		return queryExecute(
			"select * from users",
			{},
			{ returntype : "array" }
		);
	}

	/**
	 * Create a new user
	 *
	 * @user The user to persist
	 *
	 * @return The persisted user
	 */
	User function create( required user ){
		// Store timestamps
		var now = now();
		arguments.user.setModifiedDate( now ).setCreatedDate( now )
		// Persist: You can use positional or named arguments
		queryExecute(
			"
				INSERT INTO `users` (`name`, `email`, `password`, `createdDate`, `modifiedDate`)
				VALUES (?, ?, ?, ?, ?)
			",
			[
				arguments.user.getName(),
				arguments.user.getEmail(),
				bcrypt.hashPassword( arguments.user.getPassword() ),
				{
					value : arguments.user.getCreatedDate(),
					type  : "timestamp"
				},
				{
					value : arguments.user.getModifiedDate(),
					type  : "timestamp"
				}
			],
			{ result : "local.result" }
		);
		// Seed id and return
		return arguments.user.setId( result.generatedKey );
	}
	DI

}
