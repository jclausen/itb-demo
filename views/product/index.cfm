<cfoutput>
<a id="btnAddProduct" class="btn-flat default pull-right small"><i class="icon icon-plus"></i> Add Product</a>

<h1>Products</h1>

<div class="product-add"></div>
<div id="product-list"></div>

<script type="text/template" id="product-list-template">
	#renderView('product/_js/product.list.html')#
</script>
<script type="text/template" id="product-list-row-template">
	#renderView('product/_js/product.list.row.html')#
</script>
</cfoutput>