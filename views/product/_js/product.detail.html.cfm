<div class="product-detail" data-product-id="<%=product.id%>">
	<a class="btn-flat info edit-product pull-right" data-toggle="tooltip" title="Edit this product"><i class="icon icon-pencil"></i></a>
	<h6><strong>Model Number:</strong> <%= product.modelnumber %></h6>
	<h6><strong>Name:</strong> <%= product.name %></h6>
	<h6><strong>Category:</strong> <%= product.category.name %></h6>
	<h6><strong>Active:</strong> <span class="label label-<%= product.active ? 'success' : 'danger' %>"><%= product.active ? 'Active' : 'Inactive' %></span></h6>
	<h6><strong>Description:</strong></h6>
	<p> <%= product.description %></p>
</div>