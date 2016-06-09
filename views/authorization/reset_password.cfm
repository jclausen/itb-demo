<cfoutput>
<form name="reset_password" action="" method="POST" class="form form-block">
<fieldset class="form-group pwchange">
	<legend>Change Password</legend>
	<label>New Password: 
	<input type="password" class="form-control" name="pw_new" value=""/></label>
	<label>Verify: 
	<input type="password" class="form-control" name="pw_new_verify" value=""/></label>
</fieldset>
<fieldset class="submits centered">
	<button class="btn btn-glow primary login">Reset Password</button>
</fieldset>
</form>
</cfoutput>
