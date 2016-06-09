<%
if(typeof(title) === 'undefined') var title = 'Registration Detail';
var dealerTemplate = _.template($("#dealer-detail-template").html());
var enduserTemplate = _.template($("#enduser-detail-template").html());
%>
<div class="registration-detail-content" data-registration-id="<%= registration.id %>">

	<h3><%=title%> <span class="label label-success pull-right">#<%=registration.id%></span></h3>

	<div class="clearfix"></div>
	
	<hr>
	

	<div class="row col-xs-12">
		<div class="product-information col-md-4 col-xs-12">
			<h4>Product Information</h4>
			<ul class="list list-unstyled">
				<li><strong>Date of Registration:</strong> <%= moment(registration.item.created).format("MMMM Do, YYYY h:mm A") %></li>
				<li><strong>Product:</strong> <%= registration.item.product.name %></li>
				<li><strong>Model Number:</strong> <%= registration.item.product.modelnumber %></li>
				<li><strong>Serial Number:</strong> <%= registration.item.serialnumber %></li>
				<li><strong>Date of Installation:</strong> <%= moment(registration.item.installdate).format("MMMM Do, YYYY h:mm A") %></li>
			</ul>
		</div>
		<div class="col-md-4 col-xs-12 registration-dealer editable" data-classification="Dealer">
			<%= dealerTemplate({"dealer":registration.dealer,"title":"Dealer Information"}) %>
		</div>
		
		<div class="col-md-4 col-xs-12 registration-installer editable"  data-classification="Installer">
			<%= dealerTemplate({"dealer":registration.installer,"title":"Installer Information","classification":"Installer"}) %>
		</div>
	</div>

	<div class="clearfix"></div>
	<hr>
	<div class="col-xs-12">
	
		<div class="col-md-4 col-xs-12 registration-enduser editable" data-classification="EndUser">
			<%= enduserTemplate({"enduser":registration.customer}) %>
		</div>

		<div class="failure-detail col-md-8 col-xs-12">
			<h4>Registration Question Responses:</h4>
			<dl>
				<% 
				for(var i in registration.answers){
				  var answer = registration.answers[i];
				%>
				<dt><%=answer.question%></dt>
				<dd><%=answer.response.length > 0 ? '<blockquote>' + answer.response + '</blockquote>' : '<span class="text-muted">No Response</span>'%></dd>
				<% } %>
			</dl>
		</div>

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
