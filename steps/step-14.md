# 14 - Make Rant Reactions Functional

## Routing

We will attach ourselves after the `rants` resource so we can create nice RESTFul URLs for our bumps and poops.

```js
// Make sure this is BEFORE the `resources( "rants" )`
// Bump Rants
POST( "rants/:id/bumps" ).as( "bump.create" ).to( "bumps.create" );
DELETE( "rants/:id/bumps" ).as( "bump.delete" ).to( "bumps.delete" );

// Poop Rants
POST( "rants/:id/poops" ).as( "bump.create" ).to( "poops.create" );
DELETE( "rants/:id/poops" ).as( "bump.delete" ).to( "poops.delete" );
```

## Create `bumps` handler

```bash
coldbox create handler name="bumps" actions="create,delete" --noViews
```

Now the code:


```js
/**
 * I am a new handler
 */
component {

	property name="reactionService";

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		param rc.id      = 0;
		prc.oCurrentUser = auth().getUser();
	}

	/**
	 * Bump a rant
	 */
	function create( event, rc, prc ){
		reactionService.bump( rc.id, prc.oCurrentUser );
		relocate( "rants" );
	}

	/**
	 * Unbump the rant
	 */
	function delete( event, rc, prc ){
		reactionService.unbump( rc.id, prc.oCurrentUser );
		relocate( "rants" );
	}

}
```

## Create `poops` handler

```bash
coldbox create handler name="poops" actions="create,delete" --noViews
```

```js
/**
 * I am a new handler
 */
component {

	property name="reactionService";

	/**
	 * Executes before all handler actions
	 */
	any function preHandler( event, rc, prc, action, eventArguments ){
		param rc.id      = 0;
		prc.oCurrentUser = auth().getUser();
	}

	/**
	 * Poop a rant
	 */
	function create( event, rc, prc ){
		reactionService.poop( rc.id, prc.oCurrentUser );
		relocate( "rants" );
	}

	/**
	 * UnPoop the rant
	 */
	function delete( event, rc, prc ){
		reactionService.unPoop( rc.id, prc.oCurrentUser );
		relocate( "rants" );
	}

}
```

## Model: Update your `User.cfc`

inject the `reactionService` and add the following functions to verify if a user has bumped or pooped on a specific rant before.

```js
property name="reactionService" inject;

/**
 * Has the user bumped the rant?
 *
 * @rant The targeted rant
 */
boolean function hasBumped( rant ){
    if ( isNull( variables.bumps ) ) {
        variables.bumps = reactionService.getBumpsForUser( this );
    }
    return !variables.bumps
        .filter( function( bump ){
            return bump.getRantId() == rant.getId();
        } )
        .isEmpty();
}

/**
 * Has the user pooped the rant?
 *
 * @rant The targeted rant
 */
boolean function hasPooped( rant ){
    if ( isNull( variables.poops ) ) {
        variables.poops = reactionService.getPoopsForUser( this );
    }
    return !variables.poops
        .filter( function( poop ){
            return poop.getRantId() == rant.getId();
        } )
        .isEmpty();
}
```

## Model: Update your `ReactionService.cfc`

add the following functions:

```js
/**
 * Get the bumps of a specific user
 *
 * @user The target user
 *
 * @return array of bumps found
 */
array function getBumpsForUser( user ){
    return queryExecute(
        "SELECT * FROM `bumps` WHERE `userId` = ?",
        [ user.getId() ],
        { returntype : "array" }
    ).map( function( bump ){
        return populator.populateFromStruct( newBump(), bump )
    } );
}

/**
 * Get the poops of a specific user
 *
 * @user The target user
 *
 * @return array of poops found
 */
function getPoopsForUser( user ){
    return queryExecute(
        "SELECT * FROM `poops` WHERE `userId` = ?",
        [ user.getId() ],
        { returntype : "array" }
    ).map( function( poop ){
        return populator.populateFromStruct( newPoop(), poop )
    } );
}

/**
 * Bump a rant
 *
 * @rantId The rant to bump
 * @userId The user doing the bumping
 */
ReactionService function bump( required rantId, required userId ){
    queryExecute( "INSERT INTO `bumps` VALUES (?, ?)", [ arguments.userId, arguments.rantId ] );
    return this;
}

/**
 * Unbump a rant
 *
 * @rantId The rant to unbump
 * @userId The user doing the bumping
 */
ReactionService function unbump( required rantId, required userId ){
    queryExecute(
        "DELETE FROM `bumps` WHERE `userId` = ? AND `rantId` = ?",
        [ arguments.userId, arguments.rantId ]
    );
    return this;
}

/**
 * Poop a rant
 *
 * @rantId The rant to bump
 * @userId The user doing the bumping
 */
ReactionService function poop( rantId, userId ){
    queryExecute( "INSERT INTO `poops` VALUES (?, ?)", [ arguments.userId, arguments.rantId ] );
    return this;
}

/**
 * unpoop a rant
 *
 * @rantId The rant to unpoop
 * @userId The user doing the bumping
 */
ReactionService function unpoop( rantId, userId ){
    queryExecute(
        "DELETE FROM `poops` WHERE `userId` = ? AND `rantId` = ?",
        [ arguments.userId, arguments.rantId ]
    );
    return this;
}
```

## Make buttons clickable

Update the partial so we can have a read-only mode for guests and a clickable buttons for logged in users:

```html
<div class="card-footer">
    <cfif auth().guest()>
        <button disabled class="btn btn-outline-dark">
            #args.rant.getBumps().len()# 👊
        </button>
    <cfelseif auth().user().hasBumped( args.rant )>
        <form method="POST" action="#event.buildLink( "rants.#args.rant.getId()#.bumps" )#" style="display: inline;">
            <input type="hidden" name="_method" value="DELETE" />
            <button class="btn btn-dark">
                #args.rant.getBumps().len()# 👊
            </button>
        </form>
    <cfelse>
        <form method="POST" action="#event.buildLink( "rants.#args.rant.getId()#.bumps" )#" style="display: inline;">
            <button class="btn btn-outline-dark">
                #args.rant.getBumps().len()# 👊
            </button>
        </form>
    </cfif>

    <cfif auth().guest()>
        <button disabled class="btn btn-outline-dark">
            #args.rant.getPoops().len()# 💩
        </button>
    <cfelseif auth().user().hasPooped( args.rant )>
        <form method="POST" action="#event.buildLink( "rants.#args.rant.getId()#.poops" )#" style="display: inline;">
            <input type="hidden" name="_method" value="DELETE" />
            <button class="btn btn-dark">
                #args.rant.getPoops().len()# 💩
            </button>
        </form>
    <cfelse>
        <form method="POST" action="#event.buildLink( "rants.#args.rant.getId()#.poops" )#" style="display: inline;">
            <button class="btn btn-outline-dark">
                #args.rant.getPoops().len()# 💩
            </button>
        </form>
    </cfif>
</div>
```
