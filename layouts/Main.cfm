<!DOCTYPE html>
<html>
	<cfinclude template="includes/html_head.cfm">
<body>
	<cfinclude template="includes/header.cfm">
	<cfinclude template="includes/navigation.cfm">
	<!-- main container -->
    <div class="content">
        <cfinclude template="includes/messagebox.cfm">
    	<div id="pad-wrapper" class="content-container container">
    	<cfoutput>#renderView()#</cfoutput>
    	</div>
    </div>
    <cfinclude template="includes/footer.cfm">
    <cfinclude template="includes/html_foot.cfm">
</body>
</html>
