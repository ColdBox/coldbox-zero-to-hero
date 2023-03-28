<cfoutput>
<div class="vh-100 d-flex justify-content-center align-items-center">
	<div class="container">
		<div class="d-flex justify-content-center">
			<div class="col-8">
				<div class="card">
					<div class="card-header">
						SoapBox Registration
					</div>
					<div class="card-body">
						#html.startForm( action : "registration" )#

							#html.inputField(
								name : "name",
								class : "form-control",
								placeholder : "Robert Box",
								groupWrapper : "div class='mb-3'",
								label : "Full Name",
								labelClass : "form-label",
								value : rc.name
							)#

							#html.emailField(
								name : "email",
								class : "form-control",
								placeholder : "email@soapbox.com",
								groupWrapper : "div class='mb-3'",
								label : "Email",
								labelClass : "form-label",
								value : rc.email
							)#

							#html.passwordField(
								name : "password",
								class : "form-control",
								groupWrapper : "div class='mb-3'",
								label : "Password",
								labelClass : "form-label"
							)#

							#html.passwordField(
								name : "confirmPassword",
								class : "form-control",
								groupWrapper : "div class='mb-3'",
								label : "Confirm Password",
								labelClass : "form-label"
							)#

							<div class="form-group">
								<button type="submit" class="btn btn-primary">Register</button>
							</div>
						#html.endForm()#
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</cfoutput>
