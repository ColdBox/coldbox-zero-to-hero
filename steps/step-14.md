# 14 - Make Rant Reactions Functional

## Routing

We will attach ourselves after the `rants` resource so we can create nice RESTFul URLs for our bumps and poops.

```js
// Make sure this is BEFORE the `resources( "rants" )`
// Bump Rants
route( "rants/:id/bumps" )
    .as( "bumps" )
    .withAction( { "POST" : "create", "DELETE" : "delete" } )
    .toHandler( "Bumps" );

// Poop Rants
route( "rants/:id/poops" )
    .as( "poops" )
    .withAction( { "POST" : "create", "DELETE" : "delete" } )
    .toHandler( "poops" );
```

## Create `bumps` handler

```bash
coldbox create handler name="bumps" actions="create,delete" --noViews
```

Open the integration tests first:

```js
feature( "User bump Reactions", function(){
    beforeEach( function( currentSpec ){
        // Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
        setup();
    } );

    it( "can bump on a rant", function(){
        var event = post(
            route  = "/rants/#testRantId#/bumps",
            params = { id : testRantId, csrf : csrfToken() }
        );
        var prc = event.getPrivateCollection();
    } );

    it( "can unbump a rant", function(){
        var event = delete(
            route  = "/rants/#testRantId#/bumps",
            params = { id : testRantId, csrf : csrfToken() }
        );
        var prc = event.getPrivateCollection();
    } );
} );
```

Now the handler source to put it together


```js
/**
 * I am a new handler
 */
component {

	property name="reactionService" inject="ReactionService";

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

Let's start again with our BDD tests:

```js
feature( "User Poop Reactions", function(){
    beforeEach( function( currentSpec ){
        // Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
        setup();
    } );

    it( "can poop on a rant", function(){
        var event = post(
            route  = "/rants/#testRantId#/poops",
            params = { id : testRantId, csrf : csrfToken() }
        );
        var prc = event.getPrivateCollection();
    } );

    it( "can unpoop a rant", function(){
        var event = delete(
            route  = "/rants/#testRantId#/poops",
            params = { id : testRantId, csrf : csrfToken() }
        );
        var prc = event.getPrivateCollection();
    } );
} );
```

Now the handler source:

```js
/**
 * I am a new handler
 */
component {

	property name="reactionService" inject="ReactionService";

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
 * @user The user object who is doing the bumping
 */
ReactionService function bump( required rantId, required user ){
    queryExecute( "INSERT INTO `bumps` VALUES (?, ?)", [ arguments.user.getID(), arguments.rantId ] );
    return this;
}

/**
 * Unbump a rant
 *
 * @rantId The rant to unbump
 * @user The user object who is doing the unbumping
 */
ReactionService function unbump( required rantId, required user ){
    queryExecute(
        "DELETE FROM `bumps` WHERE `userId` = ? AND `rantId` = ?",
        [ arguments.user.getID(), arguments.rantId ]
    );
    return this;
}

/**
 * Poop a rant
 *
 * @rantId The rant to bump
 * @user The user object who is doing the pooping
 */
ReactionService function poop( required rantId, required user ){
    queryExecute( "INSERT INTO `poops` VALUES (?, ?)", [ arguments.user.getID(), arguments.rantId ] );
    return this;
}

/**
 * unpoop a rant
 *
 * @rantId The rant to unpoop
 * @user The user object who is doing the unpooping
 */
ReactionService function unpoop( required rantId, required user ){
    queryExecute(
        "DELETE FROM `poops` WHERE `userId` = ? AND `rantId` = ?",
        [ arguments.user.getID(), arguments.rantId ]
    );
    return this;
}
```

## Make buttons clickable

Update the partial so we can have a read-only mode for guests and a clickable buttons for logged in users:

```html
<!--- Bump & Poop --->
<span class="d-flex gap-3">

    <!--- Guest Read Only --->
    <cfif auth().guest()>
        <button class="btn btn-outline-dark" disabled>
            #args.rant.getBumps().len()# 👊
        </button>
    <!-- User has Bumped -->
    <cfelseif auth().user().hasBumped( args.rant )>
        #html.startForm( method : "delete", action : "#event.route( 'bumps', { id: args.rant.getId() } )#" )#
            #csrf()#
            <button class="btn btn-dark">
                #args.rant.getBumps().len()# 👊
            </button>
        #html.endForm()#
    <!-- Fresh Bump -->
    <cfelse>
        #html.startForm( action : "#event.route( 'bumps', { id: args.rant.getId() } )#" )#
            #csrf()#
            <button class="btn btn-outline-dark">
                #args.rant.getBumps().len()# 👊
            </button>
        #html.endForm()#
    </cfif>

    <!--- Guest Read Only --->
    <cfif auth().guest()>
        <button class="btn btn-outline-dark" disabled>
            #args.rant.getPoops().len()# 💩
        </button>
    <!-- User has Pooped -->
    <cfelseif auth().user().hasPooped( args.rant )>
        #html.startForm( method : "delete", action : "#event.route( 'poops', { id: args.rant.getId() } )#" )#
            #csrf()#
            <button class="btn btn-dark">
                #args.rant.getPoops().len()# 💩
            </button>
        #html.endForm()#
    <!-- Fresh Poop -->
    <cfelse>
        #html.startForm( action : "#event.route( 'poops', { id: args.rant.getId() } )#" )#
            #csrf()#
            <button class="btn btn-outline-dark">
                #args.rant.getPoops().len()# 💩
            </button>
        #html.endForm()#
    </cfif>

</span>
```
