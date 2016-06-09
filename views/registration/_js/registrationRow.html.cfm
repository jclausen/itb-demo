<%
    if(typeof(rowclass) === 'undefined') rowclass='';
%>
<tr class="registration-data-row <%= rowclass %>" data-registration-id="<%= registration.id %>">
    <td>
    	<a href="/registration/detail/id/<%= registration.id %>">#<%= registration.id %></a>
    </td>
    <td>
    	<%= moment(registration.created).format("MMMM Do, YYYY h:mm A") %>
    </td>
    <td>
    	<%= registration.item.product.modelnumber %><br>
        <small>(SN: <%= registration.item.serialnumber %>)</small>
    </td>
    <td>
    	<div class="address">
    	<strong><%= registration.customer.firstname + ' ' + registration.customer.lastname %></strong><br>
    	<!--<%= registration.customer.address1 %><%= registration.customer.address2.length > 0 ? '<br>'+registration.customer.address2 : '' %><br>-->
    	<%= registration.customer.city %>, <%= registration.customer.state %>&nbsp;&nbsp;<%= registration.customer.zip %>
    	</div>
    </td>
    <td>
    	<div class="address">
    	<strong><%= registration.dealer.name %></strong><br>
    	<!--<%= registration.dealer.address1 %><%= registration.dealer.address2.length > 0 ? '<br>'+registration.dealer.address2 : '' %><br>-->
    	<%= registration.dealer.city %>, <%= registration.dealer.state %>&nbsp;&nbsp;<%= registration.dealer.zip %>
    	</div>
    </td>
    <td>
    	<div class="btn-group registration-list-actions">
            <button class="btn glow"><i class="icon icon-gears"></i></button>
            <button class="btn glow dropdown-toggle" data-toggle="dropdown">
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a href="/registration/detail/id/<%=registration.id%>"><i class="icon icon-eye"></i> View Registration Detail</a></li>
            </ul>
        </div>
   	</td>
</tr>