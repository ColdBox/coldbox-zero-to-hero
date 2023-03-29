component {

	// The bcrypt equivalent of the word test.
	bcrypt_test = "$2a$12$5d31nX1hRnkvP/8QMkS/yOuqHpPZSGGDzH074MjHk6u2tYOG5SJ5W";

	function run( qb, mockdata ){
		// Create Users
		var aUsers = mockdata.mock(
			$num      = 10,
			"id"      : "autoincrement",
			"name"    : "name",
			"email"   : "email",
			"password": "oneOf:#bcrypt_test#"
		);
		qb.newQuery()
			.table( "users" )
			.insert( aUsers );

		// Create Rants
		var aRants = mockdata.mock(
			$num     = 25,
			"id"     : "autoincrement",
			"body"   : "sentence:1:3",
			"userId" : "num:1:#aUsers.len()#"
		);
		qb.newQuery()
			.table( "rants" )
			.insert( aRants );
	}

}
