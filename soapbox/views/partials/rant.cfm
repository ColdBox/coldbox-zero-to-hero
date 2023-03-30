<cfoutput>
<div class="card mb-3">
	<div class="card-header d-flex align-items-center justify-content-between">
		<span class="me">
			<i class="bi bi-chat-left-text me-2"></i>
			<a href="#event.route( 'user.rants', { id : args.rant.getUser().getId() } )#">
				#args.rant.getUser().getName()#
			</a>
		</span>

		<div class="dropdown">
			<button class="btn btn-sm btn-light fs-5" type="button" data-bs-toggle="dropdown" aria-expanded="false">
				<i class="bi bi-three-dots-vertical"></i>
			</button>
			<ul class="dropdown-menu">
				<li>
					<a class="dropdown-item" href="##">Edit</a>
				</li>
				<li>
					#html.startForm( method : "DELETE", action : "rants/#args.rant.getId()#" )#
						#csrf()#
						<button class="dropdown-item" type="submit">Delete</button>
					#html.endForm()#
				</li>
			</ul>
		</div>

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
