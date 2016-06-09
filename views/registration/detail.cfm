<cfoutput>
<h1>
	&nbsp;
	#renderView(view='common/_js/detail.controls.html',collection=['Registration'],collectionAs='entityName')#
</h1>

<div class="registration-detail" data-registration-id="#structKeyExists(rc,'registration')?rc.registration.getId():''#"></div>

<script type="text/template" id="registration-detail-template">
	#renderView('registration/_js/detail.html')#
</script>

#renderView('common/commonTemplates')#

</cfoutput>