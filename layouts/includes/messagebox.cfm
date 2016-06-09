<cfoutput>#event.getValue("messagebox").renderIt()#</cfoutput>
<script type="text/template" id="messagebox-template">
<%
	if(typeof(class) ==='undefined') class='info';
	if(typeof(icon) ==='undefined') icon='info-circle';
%>
<div class="row alert alert-<%=class%> alert-dismissable" style="font-size: 1.1em;border-radius:0px">
	<button type="button" class="close" data-dismiss="alert" aria-label="Close" style="margin-right:20px"><span aria-hidden="true">&times;</span></button>
	<div class="container" align="center"><i class="icon-<%=icon%> pull-left"></i> <p style="padding-top: 15px;font-size:1.1em"><%=message%></p></div>
	<div class="clearfix"></div>
</div>
</script>

