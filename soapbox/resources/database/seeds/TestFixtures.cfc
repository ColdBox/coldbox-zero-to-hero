component {

	// The bcrypt equivalent of the word test.
	bcrypt_test = "$2a$12$5d31nX1hRnkvP/8QMkS/yOuqHpPZSGGDzH074MjHk6u2tYOG5SJ5W";

	function run( qb, mockdata ){
		qb.table( "users" )
			.insert(
				mockdata.mock(
					$num      = 25,
					"id"      : "autoincrement",
					"name"    : "name",
					"email"   : "email",
					"password": "oneOf:#bcrypt_test#"
				)
			);
	}

}
