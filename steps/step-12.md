# 12 - View a user's rants

## BDD

We want to be able to view a user's page with their appropriate rants.

Then let's generate a `users` handler to present them:

```js
coldbox create handler name="users" actions="show"
```

And let's work on the BDD for it:

```js
feature( "User Rants Page", function(){
    beforeEach( function( currentSpec ){
        // Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
        setup();
    } );

    story( "I want to display a user's rants with a unique user url", () => {
        given( "an invalid user id", function(){
            then( "a 404 page will be shown", function(){
                var event = GET( "/users/invalid" );
                expect( event.getValue( "relocate_event" ) ).toBe( "404" );
            } );
        } );

        given( "a valid id", function(){
            then( "the user's rants will be displayed", function(){
                var testUser = getTestUser();
                var event    = GET( "/users/#testUser.id#" );
                // expectations go here.
                expect( event.getPrivateValue( "oUser" ).isLoaded() ).toBeTrue();
                expect( event.getRenderedContent() ).toInclude( "#testUser.name#" );
            } );
        } );
    } );
} );
```

## Router

```js
// config/Router.cfc
get( "/users/:id" ).as( "user.rants" ).to( "users.show" );
```

## Event Handler

Here is the implementation

```js
// handlers/users.cfc
component {

    // DI
    property name="userService" inject;

    function show( event, rc, prc ) {
        prc.oUser = userService.retrieveUserById( rc.id ?: "" );
		if ( !prc.oUser.isLoaded() ) {
			relocate( "404" );
		}
		event.setView( "users/show" );
    }

}
```

## Model `User.cfc` updates

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

## Model `RantService` retrieve for a user

Now let's update the rant service to get rants for a specific user via a `findByUser` function:

```js
function findByUser( required userId ) {
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

## The `404.cfm` view

Run the following command: `coldbox create view 404` to create the view

```html
<div class="d-flex align-items-center justify-content-center vh-100">
  <div class="text-center">
    <h1 class="display-1 fw-bold">404</h1>
    <p class="fs-3"><span class="text-danger">Opps!</span> Page not found.</p>
    <p class="lead">The page you’re looking for doesn’t exist.</p>
    <a href="/" class="btn btn-primary">Go Home</a>
  </div>
</div>
```

## The `show.cfm` view

```html
<cfoutput>
<div class="container mt-4">
	<h1 class="mb-4 d-flex align-items-center">#prc.oUser.getName()#
		<span
			class="ms-2 fs-6 badge text-bg-primary"
			title="Total Rants"
			data-bs-toggle="tooltip"
			>
			#prc.oUser.getRants().len()#
		</span>
	</h1>
	<ul>
		<cfloop array="#prc.oUser.getRants()#" item="rant">
			#view( "partials/rant", { rant = rant } )#
		</cfloop>
	</ul>
</div>
</cfoutput>
```

## Create the `views/partials/rant.cfm` view

```html
<cfoutput>
<div class="card mb-3">
	<div class="card-header d-flex align-items-center justify-content-between">
		<span class="me">
			<i class="bi bi-chat-left-text me-2"></i>
			<a href="#event.route( 'user.rants', { id : args.rant.getUser().getId() } )#">
				#args.rant.getUser().getName()#
			</a>
		</span>

		<!--- Edit/Delete Actions --->
		<cfif auth().isLoggedIn()>
			<div class="dropdown">
				<button class="btn btn-sm btn-light fs-5" type="button" data-bs-toggle="dropdown" aria-expanded="false">
					<i class="bi bi-three-dots-vertical"></i>
				</button>
				<ul class="dropdown-menu">
					<li>
						<a class="dropdown-item" href="#event.route( 'rants.edit', { id: args.rant.getId() } )#">Edit</a>
					</li>
					<li>
						#html.startForm( method : "DELETE", action : "rants/#args.rant.getId()#" )#
							#csrf()#
							<button class="dropdown-item" type="submit">Delete</button>
						#html.endForm()#
					</li>
				</ul>
			</div>
		</cfif>

	</div>

	<div class="card-body">
		#args.rant.getBody()#
	</div>

	<div class="card-footer">
		<span class="badge text-bg-light">
			#dateTimeFormat( args.rant.getCreatedDate(), "h:nn:ss tt" )#
		    on #dateFormat( args.rant.getCreatedDate(), "mmm d, yyyy")#
		</span>
	</div>
</div>
</cfoutput>
```

## Update the `rants/index` View

Update the `views/rants/index.cfm` file and replace the content of the loop to render the `_partials/_rant` view

```html
<cfloop array="#prc.aRants#" item="rant">
    #view( "partials/rant", { rant = rant } )#
</cfloop>
```

Now Test it out in the browser

## Optimizations

Look at the following code:

```js
<h1 class="mb-4 d-flex align-items-center">#prc.oUser.getName()#
    <span
        class="ms-2 fs-6 badge text-bg-primary"
        title="Total Rants"
        data-bs-toggle="tooltip"
        >
        #prc.oUser.getRants().len()#
    </span>
</h1>
<ul>
    <cfloop array="#prc.oUser.getRants()#" item="rant">
        #view( "partials/rant", { rant = rant } )#
    </cfloop>
</ul>
```

Can you spot the optimization?  We are calling `getRants()` twice, which does at this moment, two queries.  Why?  How would you optimize that?

```js

property name="rants"     type="array";

/**
 * Get the user's rants if any
 */
array function getRants(){
    if ( isNull( variables.rants ) ) {
        variables.rants = rantsService.findByUser( getId() );
    }
    return variables.rants;
}
```
