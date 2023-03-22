<cfoutput>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
	<div class="container-fluid">

		<!---Brand --->
		<a class="navbar-brand text-info" href="#event.buildLink( 'main' )#">
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

			<!--- Right Aligned --->
			<div class="ms-auto d-flex">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0">
					<li class="nav-item">
						<a
							class="nav-link #event.getCurrentEvent() eq "about.index" ? 'active' : ''#"
							href="#event.buildLink( 'about' )#"
							>
							About
						</a>
					</li>
				</ul>
			</div>

		</div>
	</div>
</nav>
</cfoutput>
