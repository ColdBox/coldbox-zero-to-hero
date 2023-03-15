## 13. Add 👊 and 💩 actions

### Migrations `bumps`

```
migrate create create_bumps_table
```

Fill the file you just create with the following functions

```js
component {

    function up( schema ) {
        queryExecute( "
            CREATE TABLE `bumps` (
                `userId` INTEGER UNSIGNED NOT NULL,
                `rantId` INTEGER UNSIGNED NOT NULL,
                CONSTRAINT `pk_bumps`
                    PRIMARY KEY (`userId`, `rantId`),
                CONSTRAINT `fk_bumps_userId`
                    FOREIGN KEY (`userId`)
                    REFERENCES `users` (`id`)
                    ON UPDATE CASCADE
                    ON DELETE CASCADE,
                CONSTRAINT `fk_bumps_rantId`
                    FOREIGN KEY (`rantId`)
                    REFERENCES `rants` (`id`)
                    ON UPDATE CASCADE
                    ON DELETE CASCADE
            )
        " );
    }

    function down( schema ) {
        queryExecute( "DROP TABLE `bumps`" );
    }

}
```

### Migrations `poops`

```
migrate create create_poops_table
```

Fill the file you just create with the following functions

```js
component {

    function up( schema ) {
        queryExecute( "
            CREATE TABLE `poops` (
                `userId` INTEGER UNSIGNED NOT NULL,
                `rantId` INTEGER UNSIGNED NOT NULL,
                CONSTRAINT `pk_poops`
                    PRIMARY KEY (`userId`, `rantId`),
                CONSTRAINT `fk_poops_userId`
                    FOREIGN KEY (`userId`)
                    REFERENCES `users` (`id`)
                    ON UPDATE CASCADE
                    ON DELETE CASCADE,
                CONSTRAINT `fk_poops_rantId`
                    FOREIGN KEY (`rantId`)
                    REFERENCES `rants` (`id`)
                    ON UPDATE CASCADE
                    ON DELETE CASCADE
            )
        " );
    }

    function down( schema ) {
        queryExecute( "DROP TABLE `poops`" );
    }

}
```

Now migrate the migrations:

```
migrate up
```

### View Partial Updates

Display bumps on the rant partial, add this footer in `/views/_partials/_rant.cfm`

```html
// /views/_partials/_rant.cfm
<cfprocessingdirective pageEncoding="utf-8">
<div class="card-footer">
    <button class="btn btn-outline-dark">
        #args.rant.getBumps().len()# 👊
    </button>
    <button class="btn btn-outline-dark">
        #args.rant.getPoops().len()# 💩
    </button>
</div>
```

### Model: `ReactionService.cfc`

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

### Model: `Rant`

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

Reinit and try it out on the site!
