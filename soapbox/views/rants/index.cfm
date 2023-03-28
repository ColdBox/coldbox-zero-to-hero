<cfoutput>
<div class="container">
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
				<div class="card mb-3">
					<div class="card-header">
						<strong>#rant.getUser().getEmail()#</strong>
						said:
					</div>
					<div class="card-body">
						#rant.getBody()#
					</div>
					<div class="card-footer">
						<span class="badge text-bg-light">
							#dateTimeFormat( rant.getCreatedDate(), "h:nn:ss tt" )#
						on #dateFormat( rant.getCreatedDate(), "mmm d, yyyy")#
						</span>
					</div>
				</div>
			</cfloop>
		</div>
	</cfif>
</div>
</cfoutput>
