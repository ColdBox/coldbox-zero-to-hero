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
