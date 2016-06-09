<cfoutput>
<h1>Import Completed</h1>
<cfif arrayLen(rc.errors)>
	<h3>There were errors with your import data which could not be processed:</h3>
	<ul class="list-unstyled">
		<cfloop array="#rc.errors#" index="error">
			<cfif isArray(error.message)>
				<li class="alert alert-danger">#error.message[1]#</li>
			<cfelse>
				<li class="alert alert-danger">#error.message#</li>	
			</cfif>
		</cfloop>
	</ul>
</cfif>
<h3>The following inventory items were imported:</h3>
<div id="inventory-list">
	<div class="dataTables_wrapper">
	    <table id="inventory-table" class="table table-hover">
	        <thead>
	            <tr>
	                <th tabindex="0" rowspan="1" colspan="1" class="col-md-3">
	                    <span class="line"></span>
	                    Serial Number
	                </th>
	            	<th tabindex="0" rowspan="1" colspan="1" class="col-md-4" role="columnheader">
	                    <span class="line"></span>
	                    Product
	                </th>
	                <th tabindex="0" rowspan="1" colspan="1" class="col-md-3">
	                    <span class="line"></span>
	                    Distributor
	                </th>

	                <th tabindex="0" rowspan="1" colspan="1" class="col-md-2">
	                    <span class="line"></span>
	                    Registration
	                </th>
	            </tr>
	        </thead> 
	        <tbody class="inventory-list">
	        	#renderView(view='product/_inc/inventory.import.list.row',collection=rc.inventoryItems,collectionAs='item')#
	        </tbody>   
	    </table>
	</div>
</div>
<div align="center">
	<a href="/product/import" class="btn btn-flat default"><i class="icon-plus-circle"></i> Import More Items</a>
</div>
</cfoutput>