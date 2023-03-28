component {

	function up( schema, queryBuilder ){
		schema.create( "rants", function( table ){
			table.increments( "id" );
			table.text( "body" );
			table.timestamps();
			table.unsignedInteger( "userId" );
			table
				.foreignKey( "userId" )
				.references( "id" )
				.onTable( "users" );
		} );
	}

	function down( schema, queryBuilder ){
		schema.drop( "rants" );
	}

}
