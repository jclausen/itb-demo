<cfset iconClass = "warning">

<cfif msgStruct.type eq "error">
	<cfset msgClass = "danger">
<cfelseif msgStruct.type eq "warning">
	<cfset msgClass = "warning">
<cfelse>
	<cfset msgClass = "info">
	<cfset iconClass = "info-circle">
</cfif>
<cfoutput>
<div class="row alert alert-#msgClass# alert-dismissable" style="font-size: 1.1em;border-radius:0px">
	<button type="button" class="close" data-dismiss="alert" aria-label="Close" style="margin-right:20px"><span aria-hidden="true">&times;</span></button>
	<div class="container" align="center"><i class="icon-#iconClass# pull-left"></i> <p style="padding-top: 15px;font-size:1.1em">#msgStruct.message#</p></div>
	<div class="clearfix"></div>
</div>
</cfoutput>