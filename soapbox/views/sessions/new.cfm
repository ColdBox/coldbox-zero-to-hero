<cfoutput>
	<div class="vh-100 d-flex justify-content-center align-items-center">
		<div class="container">
			<div class="d-flex justify-content-center">
				<div class="col-8">
					<div class="card">
						<div class="card-header">
							SoapBox Log In
						</div>
						<div class="card-body">
							#html.startForm( action : "login" )#

								#html.emailField(
									name : "email",
									class : "form-control",
									placeholder : "email@soapbox.com",
									groupWrapper : "div class='mb-3'",
									label : "Email",
									labelClass : "form-label"
								)#

								#html.passwordField(
									name : "password",
									class : "form-control",
									groupWrapper : "div class='mb-3'",
									label : "Password",
									labelClass : "form-label"
								)#

								<div class="form-group">
									<button type="submit" class="btn btn-primary">Log In</button>
								</div>
							#html.endForm()#
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	</cfoutput>
