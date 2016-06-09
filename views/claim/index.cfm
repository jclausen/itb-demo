<cfoutput>
<h1>Warranty Claims</h1>
<div id="claims-data">
	#renderView(view = 'common/commonLoader',args={"msg":"Loading Claims..."})#
</div>

<script type="text/template" id="claims-table-content">
	#renderView('claim/_js/claimsTable.html')#
</script>
<script type="text/template" id="claims-table-datarow">
	#renderView('claim/_js/claimRow.html')#
</script>
<script type="text/template" id="pagination-template">
	#renderView('common/_js/pagination.html')#
</script>
</cfoutput>