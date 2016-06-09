<%
    if(typeof(rowclass) === 'undefined') rowclass='';
%>
<tr class="inventoryitem-data-row <%= rowclass %>" data-item-id="<%= item.id %>">
    <td>
    	<%= item.serialnumber %>
    </td>
    <td>
        <%=item.distributor.name%>
    </td>
    <td>
        <% if(typeof(item.registration.id) === 'undefined'){ %>
            <span class="text-muted">Unregistered</span>
        <% } else { %>
            <a class="label label-success" href="/registration/detail/id/<%=item.registration.id%>">Registration #<%=item.registration.id%></a>
        <% } %>
    </td>
    <td>
        <% if(item.claims.length){ %>
            <% 
                for(var i in item.claims){
                    var claim = item.claims[i];
                    switch(claim.status){
                        case 2:
                            claim.statusText = 'Processing';
                            claim.statusClass = 'info';
                            claim.nextActionText = 'Approved';
                            break;
                        case 3:
                            claim.statusText = 'Approved';
                            claim.statusClass = 'primary';
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
            %>

                <a class="btn btn-xs label label-<%= claim.statusClass %>" data-toggle="tooltip" title="Claim #<%= claim.id %> is currently in <%= claim.statusText %> status and is waiting to be <%= claim.nextActionText %>" href="/claim/detail/id/<%=claim.id%>">Claim #<%=claim.id%></a>

            <% } %>
        <% } else { %>
            <span class="text-muted">No Claims</span>
        <% } %>
    </td>
    <td class="align-right">
        <a href="javascript:void(0)" class="edit-item btn-flat white small" data-toggle="tooltip" title="Edit this inventory item"><i class="icon icon-pencil"></i></a>
    </td>
</tr>