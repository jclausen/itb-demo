/**
* I am a new handler
*/
component extends="BaseController" output=false{
	property name="InventoryModel" inject="model:ProductInventory";
	property name="ProductService" inject="model:ProductService";
		
	function index(event,rc,prc){
		event.setView("product/index");
	}	

	function detail(event,rc,prc){
		if(event.valueExists('id')){
			rc.product = 	getModel("Product").get(rc.id);
			event.setView("product/detail");
		} else {
			_this.fourOhFour(argumentCollection=arguments);
		}
	}

	function inventory(event,rc,prc){
		event.setView("product/inventory");
	}	
	

	function import(event,rc,prc){
		if(event.getHTTPMethod() is "POST"){
			runEvent("Product.processImport");
		} else {
			rc.products = getModel("Product").list(asQuery=false,sortOrder="ModelNumber asc");
			rc.distributors = getModel("Distributor").list(asQuery=false,sortOrder="Name asc");
			event.setView("product/inventory/import");	
		}
	}


	function processImport(event,rc,prc){
		
		//if using the direct input option
		if(len(trim(rc.inventoryList))){
			var imported = ProductService.processListImport(rc);
			rc.inventoryItems = imported.items;
			rc.errors = imported.errors;
			event.setView("product/inventory/import_confirmation");
		} else if(event.valueExists("import_file")) {
			var imported = ProductService.processInventoryImport(event);
			rc.inventoryItems = imported.items;
			rc.errors = imported.errors;
			event.setView("product/inventory/import_confirmation");
		} else {
			MessageBox.warn("No data was provided to import.  Please try again.");
			event.setView("product/inventory/import");
		}
	}
}
