<!DOCTYPE html>
<html class="login-bg">
<cfinclude template="includes/html_head.cfm">
<body>
	<cfoutput>
		<div class="login-wrapper">
		    <a href="/">
		        <img class="logo" src="/includes/images/logo-white.png" alt="logo" />
		    </a>
		    <em style="color:##ffffff">by #getSetting("tennantCompanyName")#</em>
			#event.getValue("messagebox").renderIt()#
		    <div class="box">
		        <div class="content-wrap">
				    #renderView()#
		        </div>
		    </div>
		</div>
	</cfoutput>
    <cfinclude template="includes/html_foot.cfm">
</body>
</html>