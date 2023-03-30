# 13. Add 👊 and 💩 actions

## Migrations `bumps`

```bash
migrate create create_bumps_table
```

Fill the file you just create with the following functions

```js
component {

	function up( schema, qb ){
		schema.create( "bumps", ( table ) => {
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
		schema.drop( "bumps" );
	}

}
```

## Migrations `poops`

```bash
migrate create create_poops_table
```

Fill the file you just create with the following functions

```js
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
```

Now migrate the migrations:

```bash
migrate up
```

## View Partial Updates

Display bumps on the rant partial, add this footer in `/views/_partials/_rant.cfm`

```html
// /views/_partials/_rant.cfm
<div class="card-footer d-flex justify-content-between align-items-center">
    <span class="badge text-bg-light">
        #dateTimeFormat( args.rant.getCreatedDate(), "h:nn:ss tt" )#
    on #dateFormat( args.rant.getCreatedDate(), "mmm d, yyyy")#
    </span>

    <span>
        <button class="btn btn-outline-dark">
            #args.rant.getBumps().len()# 👊
        </button>
        <button class="btn btn-outline-dark">
            #args.rant.getPoops().len()# 💩
        </button>
    </span>
</div>
```

## Model: Create `Bump`

Generate the `Bump` model:

```bash
coldbox create model Bump
```

and code it out along the unit test.

```js
// models/Bump.cfc
component accessors="true" {

    property name="userId";
    property name="rantId";

}
```

## Model: Create `Poop`

Generate the `Poop` model:

```bash
coldbox create model Poop
```

and code it out along the unit test.

```js
// models/Poop.cfc
component accessors="true" {

    property name="userId";
    property name="rantId";

}
```

## Model: `ReactionService.cfc`

Let's build out the model to take care of our reaction services:

```bash
coldbox create model name="ReactionService" methods="getBumpsForRant,getPoopsForRant"
```

Then update the model

```js
// models/services/ReactionService.cfc
component {

    property name="populator" inject="wirebox:populator";

    function newBump() provider="Bump";
    function newPoop() provider="Poop";

    function getBumpsForRant( required rant ) {
        return queryExecute(
            "SELECT * FROM `bumps` WHERE `rantId` = ?",
            [ rant.getId() ],
            { returntype = "array" }
        ).map( function( bump ) {
            return populator.populateFromStruct(
                newBump(),
                bump
            )
        } );
    }

    function getPoopsForRant( required rant ) {
        return queryExecute(
            "SELECT * FROM `poops` WHERE `rantId` = ?",
            [ rant.getId() ],
            { returntype = "array" }
        ).map( function( poop ) {
            return populator.populateFromStruct(
                newPoop(),
                poop
            )
        } );
    }

}
```

## Model: `Rant`

Inject `reactionService` and create the following functions in the `Rant` object

```js
// models/Rant.cfc

property name="reactionService" inject="ReactionService";

function getBumps() {
    return reactionService.getBumpsForRant( this );
}

function getPoops() {
    return reactionService.getPoopsForRant( this );
}
```
