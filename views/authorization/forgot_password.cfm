<cfoutput>
	<form name="forgot_password" action="/forgot_password" method="POST">
		<fieldset id="fields" class="form-group">
		<h6>Enter your email address to reset your password:</h6>
		<input type="text" class="form-control" name="email" value="#event.getValue("email",'')#"/>
		</fieldset>
		
		<fieldset id="submits" class="form-group">
		<input type="submit" class="btn btn-glow primary login" name="submit" value="Reset Password" >
		</fieldset>
	</form>
</cfoutput>