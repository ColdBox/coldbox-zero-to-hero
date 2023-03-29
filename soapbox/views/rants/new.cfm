<cfoutput>
<div class="container">
	<div class="card">

		<div class="card-header">
			<h4>Start a Rant</h4>
		</div>

		<div class="card-body">
			#html.startForm( action : "rants" )#

				#csrf()#

				#html.textarea(
					name : "body",
					class : "form-control",
					rows : 10,
					placeholder : "What's on your mind?",
					groupWrapper : "div class='mb-3'",
					value : rc.body
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
