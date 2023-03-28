<cfoutput>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
	<div class="container-fluid">

		<!---Brand --->
		<a class="navbar-brand text-info" href="#event.buildLink( '' )#">
			<i class="bi bi-boombox"></i>
			<strong>SoapBox</strong>
		</a>

		<!--- Mobile Toggler --->
		<button
			class="navbar-toggler"
			type="button"
			data-bs-toggle="collapse"
			data-bs-target="##navbarSupportedContent"
			aria-controls="navbarSupportedContent"
			aria-expanded="false"
			aria-label="Toggle navigation"
		>
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="navbarSupportedContent">
			<!--- Left Aligned --->
			<ul class="navbar-nav me-auto mb-2 mb-lg-0">
				<!--- Logged In --->
				<cfif !cbsecure().isLoggedIn()>
					<li class="nav-item">
						<a
							class="nav-link #event.urlMatches( "registration/new" ) ? 'active' : ''#"
							href="#event.buildLink( 'registration.new' )#"
							>
							Register
						</a>
					</li>
					<li class="nav-item">
						<a
							class="nav-link #event.routeIs( "login" ) ? 'active' : ''#"
							href="#event.buildLink( 'login' )#"
							>
							Log in
						</a>
					</li>
				<cfelse>
					<li class="nav-item">
						<a href="#event.buildLink( "rants.new" )#" class="btn btn-outline-info">Start a Rant</a>
					</li>
				</cfif>
			</ul>

			<!--- Right Aligned --->
			<div class="ms-auto d-flex">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0">
					<li class="nav-item me-2">
						<a
							class="nav-link #event.routeIs( "about" ) ? 'active' : ''#"
							href="#event.buildLink( 'about' )#"
							>
							About
						</a>
					</li>
				</ul>
				<cfif cbsecure().isLoggedIn()>
					<form method="POST" action="#event.buildLink( "logout" )#">
						<input type="hidden" name="_method" value="DELETE" />
						<button class="btn btn-outline-success" type="submit">Log Out</button>
					</form>
				</cfif>
			</div>
		</div>
	</div>
</nav>
</cfoutput>
