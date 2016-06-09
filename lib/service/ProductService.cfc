/**
 *
 * @name Products Service
 * @package Suretix.Service
 * @description This is the User Service
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseService" singleton{
	property name="ModelProducts" inject="model:Product";
	property name="ModelInventory" inject="model:ProductInventory";
	property name="FileService" inject="model:FileService";
	
	/**
	* Constructor
	*/
	function init(){
		
		// init super class
		super.init();
		
		// Use Query Caching
	    setUseQueryCaching( false );
	    // Query Cache Region
	    setQueryCacheRegion( "ormservice.Product" );
	    // EventHandling
	    setEventHandling( true );
	    
	    return this;
	}

	public struct function processListImport(collection){
		var rc = arguments.collection;
		var response = newResponse();
		var itemsAdded = [];
		var errors = [];
		rc.inventoryList = replace(rc.inventoryList,',',chr(13),'ALL');
		var inventory = listToArray(rc.inventoryList,chr(13));
		var product = rc.productId;
		var distributor = rc.distributorId;
		if(arrayLen(inventory)){
			for(var sn in inventory){
				var itemProperties = {"SerialNumber":sn,"Product":product,"Distributor":distributor};
				var item = ModelInventory.new(properties=itemProperties);
				if(item.isValid()){
					item.save();
					arrayAppend(itemsAdded,item);
				} else {
					itemProperties.message = item.getValidationResults().getAllErrors();
					itemProperties.errors = item.getValidationResults();
					arrayAppend(errors,itemProperties);
				}
			}
		}
		response["errors"] = errors;
		response["items"] = itemsAdded;
		return response;

	}


	public function processInventoryImport(event){
		var upload = FileService.processSpreadsheetUpload(event,"import_file",true);
		return createInventoryFromUpload(upload);

	}

	public function createInventoryFromUpload(required query q){
		setting requesttimeout=1200;
		var response = newResponse();
		var aInventory = [];
		var errors = [];
		for(row in q){
			var item = entityFromUpload(row,'ProductInventory',false);
			//ensure our serial typing is correct
			item.setSerialNumber(javacast('string',item.getSerialNumber()));

			//Distributor
			var distributor = distributorFromUpload(row);
			item.setDistributor(distributor);

			//Handle Product
			var product = entityFromUpload(row,'Product',false);
			var existingProduct = ModelProducts.findByModelNumber(product.getModelNumber());
			
			//if we have an existing product, set it.  Otherwise create a new one if we can
			if(!isNull(existingProduct)){
				item.setProduct(existingProduct);
			} else {

				if(structKeyExists(row,'Product Category')){
					var category = Wirebox.getInstance("ProductCategory").findByCategoryName(row["Product Category"]);
					if(!isNull(category)) product.setCategory(category);
				}
				
				if(product.isValid()) {
					product.save();
					item.setProduct(product);
				} else {
					arrayAppend(errors,{"message":"The serial number #item.getSerialNumber()# could not be created because a valid product for Model Number ###product.getModelNumber()# could not be found or created from the upload data."});
					continue;
				}

			}



			
			if(item.isValid()){

				item.save();
				arrayAppend(aInventory,item);
			} else {
				arrayAppend(errors,{"message":item.getValidationResults().getAllErrors(),"errors":item.getValidationResults()})
			}
		}
		response['items'] = aInventory;
		response['errors'] = errors;
		return response;
	}

	
	
	
}
