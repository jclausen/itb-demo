<%
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
    if(typeof(rowclass) === 'undefined') rowclass='';
%>
<tr class="claim-data-row <%= rowclass %>" data-claim-id="<%= claim.id %>">
    <td>
    	<a href="/claim/detail/id/<%= claim.id %>">#<%= claim.id %></a>
    </td>
    <td>
    	<%= moment(claim.created).format("MMMM Do, YYYY h:mm A") %>
    </td>
    <td>
    	<span class="label label-<%= claim.statusClass %>"><%= claim.statusText %></span>
    </td>
    <td>
    	<div class="address">
    	<strong><%= claim.customer.firstname + ' ' + claim.customer.lastname %></strong><br>
    	<!--<%= claim.customer.address1 %><%= claim.customer.address2.length > 0 ? '<br>'+claim.customer.address2 : '' %><br>-->
    	<%= claim.customer.city %>, <%= claim.customer.state %>&nbsp;&nbsp;<%= claim.customer.zip %>
    	</div>
    </td>
    <td>
    	<div class="address">
    	<strong><%= claim.servicer.name %></strong><br>
    	<!--<%= claim.servicer.address1 %><%= claim.servicer.address2.length > 0 ? '<br>'+claim.servicer.address2 : '' %><br>-->
    	<%= claim.servicer.city %>, <%= claim.servicer.state %>&nbsp;&nbsp;<%= claim.servicer.zip %>
    	</div>
    </td>
    <td>
    	<div class="btn-group claim-list-actions">
            <button class="btn glow"><i class="icon icon-gears"></i></button>
            <button class="btn glow dropdown-toggle" data-toggle="dropdown">
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                
                <li>
                	<a href="javascript:void(0)" class="claim-approval text-<%= claim.statusClass %>" data-claim-status="<%=claim.status%>">
                		<i class="icon icon-check-circle-o"></i> Mark <%=claim.nextActionText%>
                	</a>
                </li>
               
                <li><a href="/claim/detail/id/<%=claim.id%>"><i class="icon icon-eye"></i> View Claim Detail</a></li>
            </ul>
        </div>
   	</td>
</tr>