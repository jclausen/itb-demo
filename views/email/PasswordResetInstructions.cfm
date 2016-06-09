<cfscript>
var user = args.user;
var AppSettings = args.AppSettings;
</cfscript>
<cfoutput>
<p>Hello #user.getFirstName()#!</p>

<p>Your request to reset your password has been received.  Click on the link below to create a new password:</p>

<a href="http://#cgi.http_host#/reset_password?token=#user.getResetToken()#">http://#cgi.http_host#/reset_password?token=#user.getResetToken()#</a>

<p>For additional assistance, please <a href="mailto:#AppSettings.error_to#">contact support</a>.</p>
</cfoutput>