<cfoutput>
<div class="container mt-2">
	<div class="card">

		<div class="card-header">
			<h4>#prc.oRant.isLoaded() ? "Edit" : "Start"# a Rant</h4>
		</div>

		<div class="card-body">
			#html.startForm(
				action : "rants/#prc.oRant.getId()#",
				method : prc.oRant.isLoaded() ? "PUT" : "POST"
			)#

				#csrf()#

				#html.textarea(
					name : "body",
					class : "form-control",
					rows : 10,
					placeholder : "What's on your mind?",
					groupWrapper : "div class='mb-3'",
					bind : prc.oRant
				)#

				<div class="d-flex justify-content-end">
					<a href="#event.buildLink( 'rants' )#" class="btn btn-outline-secondary">Cancel</a>
					<button type="submit" class="btn btn-outline-success ms-auto">Rant it!</button>
				</div>

			#html.endForm()#
		</div>
	</div>
</div>
</cfoutput>
