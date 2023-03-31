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

	<div class="card-footer d-flex justify-content-between align-items-center">

		<!--- Timestamp --->
		<span class="badge text-bg-light">
			#dateTimeFormat( args.rant.getCreatedDate(), "h:nn:ss tt" )#
			on #dateFormat( args.rant.getCreatedDate(), "mmm d, yyyy")#
		</span>

		<!--- Bump & Poop --->
		<span class="d-flex gap-3">

			<!--- Guest Read Only --->
			<cfif auth().guest()>
				<span data-bs-toggle="tooltip" title="Log In First">
					<button class="btn btn-outline-dark" disabled>
						#args.rant.getBumps().len()# 👊
					</button>
				</span>
			<!-- User has Bumped -->
			<cfelseif auth().user().hasBumped( args.rant )>
				#html.startForm( method : "delete", action : "#event.route( 'bumps', { id: args.rant.getId() } )#" )#
					#csrf()#
					<button class="btn btn-dark">
						#args.rant.getBumps().len()# 👊
					</button>
				#html.endForm()#
			<!-- Fresh Bump -->
			<cfelse>
				#html.startForm( action : "#event.route( 'bumps', { id: args.rant.getId() } )#" )#
					#csrf()#
					<button class="btn btn-outline-dark">
						#args.rant.getBumps().len()# 👊
					</button>
				#html.endForm()#
			</cfif>

			<!--- Guest Read Only --->
			<cfif auth().guest()>
				<span data-bs-toggle="tooltip" title="Log In First">
					<button class="btn btn-outline-dark" disabled>
						#args.rant.getPoops().len()# 💩
					</button>
				</span>
			<!-- User has Pooped -->
			<cfelseif auth().user().hasPooped( args.rant )>
				#html.startForm( method : "delete", action : "#event.route( 'poops', { id: args.rant.getId() } )#" )#
					#csrf()#
					<button class="btn btn-dark">
						#args.rant.getPoops().len()# 💩
					</button>
				#html.endForm()#
			<!-- Fresh Poop -->
			<cfelse>
				#html.startForm( action : "#event.route( 'poops', { id: args.rant.getId() } )#" )#
					#csrf()#
					<button class="btn btn-outline-dark">
						#args.rant.getPoops().len()# 💩
					</button>
				#html.endForm()#
			</cfif>

		</span>
	</div>
</div>
</cfoutput>
