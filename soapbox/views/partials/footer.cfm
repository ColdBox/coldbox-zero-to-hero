<cfoutput>
<footer class="w-100 bottom-0 position-fixed border-top py-3 mt-5 bg-light">
	<div class="container">
		<p class="float-end">
			<a href="##" class="btn btn-info rounded-circle shadow" role="button">
				<i class="bi bi-arrow-bar-up"></i> <span class="visually-hidden">Top</span>
			</a>
		</p>
		<p>
			<a href="https://github.com/ColdBox/coldbox-platform/stargazers">ColdBox Platform</a> is a copyright-trademark software by
			<a href="https://www.ortussolutions.com">Ortus Solutions, Corp</a>
		</p>

		<span
			class="badge rounded-pill text-bg-dark"
			data-bs-toggle="tooltip"
			title="Environment"
		>
			<i class="bi bi-hdd-stack"></i>
			 #getSetting( "environment" )#
		</span>

		<span
			class="badge rounded-pill text-bg-dark"
			data-bs-toggle="tooltip"
			title="Debug Mode"
		>
			<i class="bi bi-bug"></i>
			 #isDebugMode()#
		</span>

		<span
			class="badge rounded-pill text-bg-dark"
			data-bs-toggle="tooltip"
			title="Request Date/Time"
		>
			<i class="bi bi-calendar"></i>
			 #getIsoTime()#
		</span>
	</div>
</footer>
</cfoutput>
