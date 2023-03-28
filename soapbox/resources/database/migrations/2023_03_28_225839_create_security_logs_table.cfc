component {

	function up( schema, qb ){
		schema.create( "cbsecurity_logs", function( table ){
			table.string( "id" ).primaryKey();
			table.timestamp( "logDate" );
			table.string( "action" );
			table.string( "blockType" );
			table.string( "ip" );
			table.string( "host" );
			table.string( "httpMethod" );
			table.string( "path" );
			table.string( "queryString" );
			table.string( "referer" );
			table.string( "userAgent" );
			table.string( "userId" );
			table.longText( "securityRule" );
			table.index( [ "logDate", "action", "blockType" ], "idx_cbsecurity" );
		} );
	}

	function down( schema, qb ){
		schema.drop( "cbsecurity_logs" );
	}

}
