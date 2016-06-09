<cfoutput>
<h1>Product Registrations</h1>
<div id="registrations-data">
	#renderView(view = 'common/commonLoader',args={"msg":"Loading Registrations..."})#
</div>

<script type="text/template" id="registrations-table-content">
	#renderView('registration/_js/registrationsTable.html')#
</script>
<script type="text/template" id="registrations-table-datarow">
	#renderView('registration/_js/registrationRow.html')#
</script>
<script type="text/template" id="pagination-template">
	#renderView('common/_js/pagination.html')#
</script>
</cfoutput>