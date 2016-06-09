<%
if(typeof(title) === 'undefined') title = 'Edit Claim';
switch(claim.status){
	case 2:
		claim.statusText = 'Processing';
		claim.statusClass = 'info';
		claim.nextActionText = 'Approved';
		break;
	case 3:
		claim.statusText = 'Approved';
		claim.statusClass = 'info';
		claim.nextActionText = 'Resolved';
		break;
	case 4:
		claim.statusText = 'Complete';
		claim.statusClass = 'success';
		claim.nextActionText = 'Incomplete';
		break;
	default:
		claim.statusText = 'Submitted';
		claim.statusClass = 'warning';
		claim.nextActionText = 'Under Review';
}
var servicerTemplate = _.template($("#dealer-detail-template").html());
var enduserTemplate = _.template($("#enduser-detail-template").html());
%>
<form class="claim-edit" data-claim-id="<%= claim.id %>" action="javascript:void(0)">

	<h3><%=title%> <span class="label label-<%= claim.statusClass %> pull-right">Claim #<%=claim.id%></span></h3>

	<div class="row col-xs-12">
		<div class="claim-information col-sm-6 col-xs-12">
			<h4>Detail</h4>

			<ul class="list list-unstyled">
				<li><strong>Date Submitted:</strong> <%= moment(claim.created).format("MMMM Do, YYYY h:mm A") %></li>
				<li><strong>Claim Status:</strong> <span class="label label-<%= claim.statusClass %>"><%= claim.statusText %></span></li>
				<li><strong>Requested Action:</strong> <%= claim.claimaction %></li>
				<li><strong>Notification Email:</strong> <a href="mailto:<%= claim.notificationemail %>"><%= claim.notificationemail %></a></li>
			</ul>
		</div>

		<div class="product-information col-sm-6 col-xs-12">
			<h4>Product Information</h4>
			<ul class="list list-unstyled">
				<li><strong>Product:</strong> <%= claim.item.product.name %></li>
				<li><strong>Model Number:</strong> <%= claim.item.product.modelnumber %></li>
				<li><strong>Serial Number:</strong> <%= claim.item.serialnumber %></li>
				<li><strong>Date of Installation:</strong> <%= moment(claim.item.installdate).format("MMMM Do, YYYY h:mm A") %></li>
				<li><strong>Date of Failure:</strong> <%= moment(claim.failuredate).format("MMMM Do, YYYY h:mm A") %></li>
			</ul>
		</div>
	</div>

	<div class="clearfix"></div>
	<hr>
	

	<div class="row col-xs-12">
		<div class="col-md-6 col-xs-6 claim-servicer">
			<%= servicerTemplate({"dealer":claim.servicer,"title":"Servicer Information"}) %>
		</div>
		<div class="col-sm-6 col-xs-6 claim-enduser">
			<%= enduserTemplate({"enduser":claim.customer}) %>
		</div>
	</div>

	<div class="clearfix"></div>
	<hr>
	
	<div class="failure-detail col-xs-12 row">
		<h4>Failure Information</h4>
		<dl>
			<% 
			for(var i in claim.answers){
			  var answer = claim.answers[i];
			%>
			<dt><%=answer.question%></dt>
			<dd><%=answer.response.length > 0 ? '<blockquote>' + answer.response + '</blockquote>' : '<span class="text-muted">No Response</span>'%></dd>
			<% } %>
		</dl>
	</div>

</form>
