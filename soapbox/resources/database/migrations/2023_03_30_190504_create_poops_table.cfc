component {

	function up( schema, qb ){
		schema.create( "poops", ( table ) => {
			table.unsignedInteger( "userId" );
			table.unsignedInteger( "rantId" );

			table
				.foreignKey( "userId" )
				.references( "id" )
				.onTable( "users" )
				.onDelete( "cascade" )
				.onUpdate( "cascade" );

			table
				.foreignKey( "rantId" )
				.references( "id" )
				.onTable( "rants" )
				.onDelete( "cascade" )
				.onUpdate( "cascade" );
		} );
	}

	function down( schema, qb ){
		schema.drop( "poops" );
	}

}
