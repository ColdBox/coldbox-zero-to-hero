component {

	// The bcrypt equivalent of the word test.
	bcrypt_test = "$2y$10$sgnxdXfMuffDAs3GkxRbVuwYsAg07nvly8Rr5uZ5zcnPAKz8kJnvS";

    function run( qb, mockdata ) {
        qb.table( "users" ).insert(
			mockdata.mock(
                $num = 25,
                "id": "autoincrement",
                "name": "name",
                "email": "email",
                "password": "oneOf:#bcrypt_test#"
            )
		);
    }

}
