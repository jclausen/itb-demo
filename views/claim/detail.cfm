<cfoutput>
<h1>
	&nbsp;
	#renderView('common/_js/detail.controls.html')#
</h1>

<div class="claim-detail" data-claim-id="#structKeyExists(rc,'claim')?rc.claim.getId():''#"></div>

<script type="text/template" id="claim-detail-template">
	#renderView('claim/_js/detail.html')#
</script>

#renderView('common/commonTemplates')#

</cfoutput>