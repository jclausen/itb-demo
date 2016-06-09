<cfscript>
	var AppSettings = args.AppSettings;
</cfscript>
<cfoutput>
<p>A new warranty claim has been received by the <a href="#AppSettings.base_url#">#AppSettings.tennantCompanyName# Suretix</a> system and is pending approval.</p>
<p>Please <a href="#AppSettings.base_url#">log in to the admin console</a> to review the full details of this this claim.</p>

<cfinclude template="/views/email/claimSummary.cfm">

</cfoutput>