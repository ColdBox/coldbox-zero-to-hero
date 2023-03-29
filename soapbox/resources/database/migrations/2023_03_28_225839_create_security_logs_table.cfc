component {

	variables.INDEX_COLUMNS = [
		"userId",
		"userAgent",
		"ip",
		"host",
		"httpMethod",
		"path",
		"referer"
	];

	function up( schema, qb ){
		schema.create( "cbsecurity_logs", function( table ){
			table.string( "id", 36 ).primaryKey();
			table.timestamp( "logDate" ).withCurrent();
			table.string( "action" );
			table.string( "blockType" );
			table.string( "ip" );
			table.string( "host" );
			table.string( "httpMethod" );
			table.string( "path" );
			table.string( "queryString" );
			table.string( "referer" ).nullable();
			table.string( "userAgent" );
			table.string( "userId" ).nullable();
			table.longText( "securityRule" ).nullable();
			table.index( [ "logDate", "action", "blockType" ], "idx_cbsecurity" );

			INDEX_COLUMNS.each( ( key ) => {
				table.index( [ arguments.key ], "idx_cbsecurity_#arguments.key#" );
			} );
		} );
	}

	function down( schema, qb ){
		schema.drop( "cbsecurity_logs" );
	}

}
