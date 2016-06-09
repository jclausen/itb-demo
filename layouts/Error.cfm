<!DOCTYPE html>
<html class="login-bg">
<cfinclude template="includes/html_head.cfm">
<body>
<style type="text/css">
	@import url('/includes/css/view/authorization.css');
	@import url('/includes/css/view/view-authorization-login.css');
</style>
	<cfoutput>
		<div class="login-wrapper">
		    	<div class="container well col-md-8 col-md-offset-2" style="background-color:##ffffff;font-size: 1.3em; padding: 30px 30px 30px 30px">
		    		<cfif isDefined('oException') AND oException.geterrorCode() neq "" AND oException.getErrorCode() neq 0>
		    			<div class="btn btn-danger" style="font-size: 5em; margin: 30px;font-weight: bold">#oException.getErrorCode()#</div>
		    		<cfelse>
		    				<div class="btn btn-default" style="font-size: 8em; margin: 30px;padding: 50px 50px">500</div>
					</cfif>
				    <h1 style="text-align:center;margin-bottom: 30px;font-size: 5em">Unexpected Error</h1>
				    <p>Oh no!  An error ocurred while attempting to process the request.  A system administrator has been notified by email of the details surrounding the error.</p>
				    <p>Please use your browser's back button or click the button below to return to the previous page</p>

				    <a class="btn-flat primary" style="font-size: 1.3em;padding: 10px;color:##fff!important" href="javascript:void()" onclick="function(){window.history.back()}">&lt;&lt; Go Back To Previous Page</a>
		        </div>
		    </div>
		</div>
	</cfoutput>
	<script src="/includes/js/opt/require.js" type="application/javascript"></script>
	<script type="application/javascript">
	require(['/includes/js/opt/es6-shim.js'],function(){
		require(['/includes/js/opt/globals.js'],function(globals){
			require(['/includes/js/opt/app.js']);
		});
	});
	</script>
</body>
</html>