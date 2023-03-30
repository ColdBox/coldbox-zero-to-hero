<cfoutput>
<div class="container mt-2">
	<h2>All Rants</h2>

	<cfif prc.aRants.isEmpty()>
		<div class="alert alert-info">
			No rants yet, why not create some?
		</div>
		<cfif auth().isLoggedIn()>
			<a
				href="#event.buildLink( "rants.new" )#"
				class="btn btn-outline-primary">Start a Rant!</a>
		<cfelse>
			<a
				href="#event.buildLink( "registration/new" )#"
				class="btn btn-outline-success">Register</a>
			<a
				href="#event.buildLink( "login" )#"
				class="btn btn-outline-success">Log In</a>
		</cfif>
	<cfelse>

		<cfif auth().isLoggedIn()>
		<a
			href="#event.buildLink( "rants.new" )#"
			class="btn btn-primary">Start a Rant!</a>
		</cfif>

		<div class="mt-3">
			<cfloop array="#prc.aRants#" item="rant">
				#view( "partials/rant", { rant = rant } )#
			</cfloop>
		</div>
	</cfif>
</div>
</cfoutput>
