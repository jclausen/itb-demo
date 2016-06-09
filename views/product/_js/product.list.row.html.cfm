<%
    if(typeof(rowclass) === 'undefined') rowclass='';
%>
<tr class="product-data-row <%= rowclass %>" data-product-id="<%= product.id %>">
    <td>
    	<a href="/product/detail/id/<%= product.id %>">#<%= product.modelnumber %></a>
    </td>
    <td>
        <%=product.name%>
    </td>
    <td>
        <%=product.category.name%>
    </td>
    <td>
        <i class="icon icon-check-circle-o <%= product.active ? 'text-success' : 'text-muted' %> icon-2x"></i>
    </td>
    <td>
    	<div class="btn-group product-list-actions">
            <button class="btn glow"><i class="icon icon-gears"></i></button>
            <button class="btn glow dropdown-toggle" data-toggle="dropdown">
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                
                <li>
                	<a href="javascript:void(0)" class="product-approval <%= product.active ? 'text-success' : 'text-muted' %>" data-product-status="<%=product.active%>" data-product-toggle="<%=!product.active%>">
                		<i class="icon icon-check-circle-o"></i> Set <%=product.active?'Inactive':'Active'%>
                	</a>
                </li>
               
                <li><a href="/product/detail/id/<%=product.id%>"><i class="icon icon-eye"></i> View Product Detail</a></li>
            </ul>
        </div>
   	</td>
</tr>