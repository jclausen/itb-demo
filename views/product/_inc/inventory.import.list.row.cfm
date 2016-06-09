<cfscript>
    param name="rowClass" default="";
    var product = item.getProduct();
</cfscript>
<cfoutput>
<tr class="inventoryitem-data-row #rowclass#" data-item-id="#item.getId()#">
    
    <td>
        #item.getSerialNumber()#
    </td>

    <td>
        <a href="/product/detail/id/#product.getId()#">#product.getName()# (Model: #product.getModelNumber()#)</a>
    </td>
    
    <td>
        #item.getDistributor().getName()#
    </td>

    <td>
        <cfif isNull(item.getRegistration())>
            <span class="text-muted">Unregistered</span>
        <cfelse>
            <a class="label label-success" href="/registration/detail/id/#item.getRegistration().getId()#">Registration ###item.getRegistration().getId()#</a>
        </cfif>
    </td>
</tr>
</cfoutput>