<div class="product-detail form-wrapper" data-product-id="<%=product.id%>">
<div class="clearfix"></div>
	<form name="product-edit-form" class="col-sm-8" id="product-edit-form" action="javascript:void(0)">
		<div class="field-box">
			<label>Model Number:</label>
			<input name="ModelNumber" class="form-control input-sm" value="<%= product.modelnumber %>"/>
		</div>
		<div class="field-box">
			<label>Name:</label> 
			<input name="Name" class="form-control input-sm" value="<%= product.name %>"/>
		</div>
		<div class="field-box">
			<label>Category:</label>
				<select name="Category" class="form-control input-sm">
					<% 
					for(var i in window.categories) { 
						var category = window.categories[i];
					%>
					<option value="<%=category.id%>"<%= category.id === product.category.id ? ' selected' : '' %>><%=category.name%></option>
					<% } %>
				</select>
		</div>
		<div class="field-box">
			<label>Active:</label>
				<select name="Active" class="form-control input-sm">
					<option value="true"<%= product.active ? ' selected' : '' %>>Yes</option>
					<option value="false"<%= !product.active ? ' selected' : '' %>>No</option>
				</select>
		</div>
		<div class="field-box">
			<label>Description:</label>
				<textarea name="Description" class="form-control input-sm" rows="6"><%= product.description %></textarea>
		</div>
	</form>
<div class="clearfix"></div>
</div>