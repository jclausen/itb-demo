<cfscript>
	var AppSettings = args.AppSettings;
</cfscript>
<cfoutput>
<p>Thank you for completing the online claim form for your #appSettings.tennantCompanyShortName# product. We have received your claim information.</p>

<p>A #appSettings.tennantCompanyShortName# Customer Care agent will review your claim and contact you within 2 day business days.</p>

<p>If you need additional support, please contact our Customer Care department at #appSettings.tennantSupportPhone#.</p>

<hr>

<p>The details of your claim submission are provided below, for your records:</p>

<cfinclude template="/views/email/claimSummary.cfm">

</cfoutput>