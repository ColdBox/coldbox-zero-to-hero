component {

    function up( schema ) {
        schema.create( "users", function( table ) {
            table.increments( "id" )
            table.string( "name" )
            table.string( "email" ).unique()
            table.string( "password" )
            table.timestamps()
        } );
    }

    function down( schema ) {
        schema.drop( "users" )
    }

}
