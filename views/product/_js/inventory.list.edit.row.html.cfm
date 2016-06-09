<%
    if(typeof(rowclass) === 'undefined') rowclass='';
%>
<tr class="inventoryitem-data-row <%= rowclass %>" data-item-id="<%= item.id %>">
    <form action="javascript:void(0)" name="inventoryitem-edit-form" class="inventoryitem-edit-form" id="inventoryitem-information">

    <td class="field-box" style="vertical-align:top!important">
        <label>Serial Number</label>
         <input type="text" class="form-control input-small" name="SerialNumber" value="<%= item.serialnumber %>" <%=typeof(item.registration.id) !== 'undefined' || item.claims.length > 0 ? 'disabled=true' : ''%>>
         <% if(typeof(item.registration.id) !== 'undefined' || item.claims.length > 0){ %>
            <br><small class="text-muted">The serial number cannot be changed because it has been registered or has existing claims</small>
        <% } %>
    </td>
    <td  style="vertical-align:top!important">
        <label>Distributor</label>
        <select name="Distributor" class="form-control input-small">
            <% 
                for (var i in window.distributors) { 
                    var distributor = window.distributors[i];
            %>
                <option value="<%=distributor.id%>"<%= distributor.id===item.distributor.id ? ' selected' : '' %>><%=distributor.name%></option>
            <% } %>
        </select>
    </td>
    <td colspan="3" class="align-right">
        <button name="saveInventoryItem" class="save-editable btn-flat btn-primary"><i class="icon-save"></i> Save</button>
    </td>
    </form>
</tr>