<%
if(typeof(title) === 'undefined') var title = 'Claim Information';
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
<div class="claim-detail-content" data-claim-id="<%= claim.id %>">

	<h3><%=title%> <span class="label label-<%= claim.statusClass %> pull-right">Claim #<%=claim.id%></span></h3>

	<div class="row col-xs-12" style="margin-top: 20px;">
		<div class="claim-information col-sm-6 col-xs-12">
			<h4>Detail</h4>
			<ul class="list list-unstyled" style="line-height: 2.2em;">
				<li><strong>Date Submitted:</strong> <%= moment(claim.created).format("MMMM Do, YYYY h:mm A") %></li>
				<li><strong>Claim Status:</strong> 
				<div class="btn-group claim-status" style="margin-left: 20px">
                      <button type="button" class="btn btn-<%= claim.statusClass %> btn-xs"><%= claim.statusText %></button>
                      <button type="button" class="btn btn-<%= claim.statusClass %> btn-xs dropdown-toggle" data-toggle="dropdown">
                        <span class="caret"></span>
                      </button>
                      <ul class="dropdown-menu" role="menu">
	                  	<li>
		                	<a href="javascript:void(0)" class="claim-approval" data-claim-status="1">
		                		<i class="icon icon-check-circle-o"></i> Mark as Submitted
		                	</a>
		                </li>
		                <li>
		                	<a href="javascript:void(0)" class="claim-approval" data-claim-status="2">
		                		<i class="icon icon-check-circle-o"></i> Mark as Under Review
		                	</a>
		                </li>

		                <li>
		                	<a href="javascript:void(0)" class="claim-approval" data-claim-status="3">
		                		<i class="icon icon-check-circle-o"></i> Mark as Approved
		                	</a>
		                </li>

		                <li>
		                	<a href="javascript:void(0)" class="claim-approval" data-claim-status="4">
		                		<i class="icon icon-check-circle-o"></i> Mark as Resolved/Completed
		                	</a>
		                </li>
                      </ul>
                    </div>
				<li><strong>Requested Action:</strong> <%= claim.claimaction %></li>
				<li><strong>Notification Email:</strong> <a href="mailto:<%= claim.notificationemail %>"><%= claim.notificationemail %></a></li>
			</ul>
		</div>

		<div class="product-information col-sm-6 col-xs-12">
			<h4>Product Information</h4>
			<ul class="list list-unstyled" style="line-height: 2.2em;">
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
		<div class="col-md-6 col-xs-6 claim-servicer editable" data-classification="Dealer">
			<%= servicerTemplate({"dealer":claim.servicer,"title":"Servicer Information"}) %>
		</div>
		<div class="col-sm-6 col-xs-6 claim-enduser editable" data-classification="EndUser">
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

	
	<div class="col-xs-12 comments-container">
		<h4>
			Comments:
		</h4>
		<button class="add-new-comment btn-flat info large pull-right comment-icon-stack icon-stack" style="padding: 16px;" data-toggle="tooltip" title="Add a Comment">
			<i class="icon icon-comment-o icon-stack-3x icon-2x" style="position:absolute; margin-left: -13px;margin-top: -14px"></i>
			<i class="icon icon-plus icon-inverse icon-stack-1x" style="position:absolute;margin-top: -8px"></i>
		</button>
		<div class="clearfix"></div>
		<div class="comments"></div>	
	</div>

</div>
