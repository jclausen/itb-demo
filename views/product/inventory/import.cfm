<cfoutput>
<h1>Import Product Inventory</h1>
<div class="row form-wrapper">
	<form name="inventoryImport" class="" action="" method="POST" enctype="multipart/form-data">
		<div class="col-md-7 col-sm-6 col-xs-12">
			<fieldset>
                <hr>

				<div class="field-box form-group">
                    <label>Select a product: <a href="javascript:void(0)" class="addProduct" data-toggle="tooltip" title="Add a new product"><i class="icon icon-plus-circle text-primary"></i></a></label>
                    <select name="productId" class="form-control">
                    	<cfloop array="#rc.products#" index="product">
                        	<option value="#product.getId()#">#product.getModelNumber()# (#product.getName()#)</option>
                    	</cfloop>
                    </select>                       
                </div>

                <input type="hidden" name="distributorId" value="1"/>


                <div class="field-box">
                    <label>
                        Enter Serial Numbers<br>
                        <small>Enter a range of serial numbers, separated by commas or line breaks. You may copy a spreadsheet column and paste it directly in to this text area.</small>
                    </label>
                    <textarea name="inventoryList" rows="10" class="form-control"></textarea>

                </div>


			</fieldset>
            <fieldset style="margin-top: 30px">
                <button class="btn-flat default pull-right"><i class="icon icon-list"></i> Submit</button>
            </fieldset>
		</div>

	</form>
    <div class="clearfix"></div>
</div>
</cfoutput>