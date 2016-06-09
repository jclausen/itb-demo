<cfoutput>
<h1>
	Suretix User Directory
	<cfif isUserInRole("Administrator")>
		<a href="javascript:void(0)" id="createUserBtn" class="btn btn-flat primary pull-right"><i class="icon icon-plus-circle"></i> Add User</a>
	</cfif>
</h1>
<div id="user-form"></div>
<div id="user-list"></div>

<script type="text/template" id="user-list-template">
	#renderView('user/_js/user.list.html')#
</script>
<script type="text/template" id="user-list-row-template">
	#renderView('user/_js/user.list.row.html')#
</script>
<script type="text/template" id="user-edit-form">
#renderView('user/_js/user.edit.html')#
</script>
</cfoutput>