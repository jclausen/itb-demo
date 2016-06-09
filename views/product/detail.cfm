<cfoutput>
<h1>Product Detail</h1>
<div id="product-detail" class="col-xs-12" data-classification="Product" data-product-id="#rc.product.getId()#">
	#renderView('common/commonLoader')#
</div>
<div class="clearfix"></div>
<h3>Inventory Items</h3>
<div id="inventory-list"></div>

<script type="text/template" id="product-detail-template">
	#renderView('product/_js/product.detail.html')#
</script>
<script type="text/template" id="product-edit-form">
	#renderView('product/_js/product.edit.html')#
</script>
<script type="text/template" id="inventory-list-template">
	#renderView('product/_js/inventory.list.html')#
</script>
<script type="text/template" id="inventory-list-row-template">
	#renderView('product/_js/inventory.list.row.html')#
</script>
<script type="text/template" id="inventory-list-row-edit-form">
	#renderView('product/_js/inventory.list.edit.row.html')#
</script>
</cfoutput>