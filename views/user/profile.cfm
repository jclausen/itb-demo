<cfoutput>
<h1>Suretix User Profile</h1>
<div id="user-profile" class="col-md-9" data-classification="User" data-user-id="#rc.user.getId()#"></div>
<div class="clearfix"></div>
<script type="application/javascript">
	window.profileIsEditable = #event.getValue('mayEdit',false)#;
	window.profileMayDelete = #event.getValue('mayDelete',false)#;
	window.currentUser = #serializeJSON(session.currentUser)#
</script>

<script type="text/template" id="user-detail-template">
#renderView('user/_js/user.profile.html')#
</script>
<script type="text/template" id="user-edit-form">
#renderView('user/_js/user.edit.html')#
</script>
</cfoutput>