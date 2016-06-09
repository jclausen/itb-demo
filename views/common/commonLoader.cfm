<cfscript>
	if(!isDefined('args')) args = {};
	if(!structKeyExists(args,'msg')) args.msg = "Loading..."
</cfscript>
<div class="loader">
	<div align="center" class="text-muted"><p><cfoutput>#args.msg#</cfoutput></p><i class="icon icon-spin icon-spinner icon-3x"></i></div>
</div>