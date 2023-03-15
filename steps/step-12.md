## 12 - View a user's rants

### BDD

We want to be able to view a user's page with their appropriate rants. So the first thing to do is to add some rants to our database so we seed it with data. So login in and create some rants in the system using your username.

Then let's generate a `users` handler to present them:

`coldbox create handler name="users" actions="show"`

And let's work on the BDD for it:

```js
describe( "users Suite", function(){

    beforeEach(function( currentSpec ){
        // Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
        setup();
    });

    it( "can relocate to a 404 if you pass an invalid user", function(){
        var event = GET( "/users/invalid" );
        expect( event.getValue( "relocate_uri" ) ).toBe( "404" );
    });

    it( "can show the rants for a specific user", function(){
        var event = GET( "/users/lmajano" );
        // expectations go here.
        expect( event.getPrivateValue( "user" ).isLoaded() ).toBeTrue();
        expect( event.getRenderedContent() ).toInclude( "<h4>Rants</h4>" );
    });

});
```

### Router

```js
// config/Router.cfc
get( "/users/:username" ).to( "users.show" );
```

### Event Handler

Here is the implementation

```js
// handlers/users.cfc
component {

    property name="userService" inject;

    function show( event, rc, prc ) {
        prc.user = userService.retrieveUserByUsername( rc.username ?: "" );
        if ( !prc.user.isLoaded() ) {
            relocate( "404" );
        }
        event.setView( "users/show" );
    }

}
```

### Model `User.cfc` updates

To be able to pull the rants for a user, we need to update our User object, to be able to access the Rant Service. Start by injecting the `rantService`

```js
property name="rantService" inject;
```

Then create a `getRants()` function

```js
function getRants() {
    return rantService.getForUserId( variables.id );
}
```

### Model `RantService` retrieve for a user

Now let's update the rant service to get rants for a specific user via a `getForUserId` function:

```js
function getForUserId( required userId ) {
    return queryExecute(
        "SELECT * FROM `rants` WHERE `userId` = ? ORDER BY `createdDate` DESC",
        [ userId ],
        { returntype = "array" }
    ).map( function ( rant ) {
        return populator.populateFromStruct(
            new(),
            rant
        );
    } );
}
```

Now we are ready for the views

### The `404.cfm` view

Run the following command: `coldbox create view 404` to create the view

```sh
// views/404.cfm
<h1>Whoops!  That page doesn't exist.</h1>
```

### The `show.cfm` view

```html
// views/users/show.cfm
<cfoutput>
    <h1>#prc.user.getUsername()#</h1>
    <h4>Rants</h4>
    <ul>
        <cfloop array="#prc.user.getRants()#" item="rant">
            #renderView( "_partials/_rant", { rant = rant } )#
        </cfloop>
    </ul>
</cfoutput>
```

#### Create the `views/_partials/_rant.cfm` view

```html
<cfoutput>
    <div class="card mb-3">
        <div class="card-header">
            <strong><a href="#event.buildLink( "users.#args.rant.getUser().getUsername()#" )#">#args.rant.getUser().getUsername()#</a></strong>
            said at #dateTimeFormat( args.rant.getCreatedDate(), "h:nn:ss tt" )#
            on #dateFormat( args.rant.getCreatedDate(), "mmm d, yyyy")#
        </div>
        <div class="panel card-body">
            #args.rant.getBody()#
        </div>
    </div>
</cfoutput>
```

### Update the `rants/index` View

Update the `views/rants/index.cfm` file and replace the content of the loop to render the `_partials/_rant` view

```html
<cfloop array="#prc.aRants#" item="rant">
    #renderView( "_partials/_rant", { rant = rant } )#
</cfloop>
```

Now Test it out in the browser
