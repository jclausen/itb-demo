/**
 *
 * @name Products API Controller
 * @package Suretix.API.v1
 * @description This is the Products API Controller
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseAPIController"{
	property name="ModelProducts" inject="model:Product";
	property name="ModelInventory" inject="model:ProductInventory";
	property name="ModelCategories" inject="model:ProductCategory";
	
	this.API_BASE_URL = "/api/v1/products";

	//(GET) /api/v1/products
	function index(event,rc,prc){
		runEvent('api.v1.Products.list');
	}	

	//(GET) /api/v1/products/:id
	function get(event,rc,prc){
		this.marshallProduct(event,rc,prc);
	}

	//(GET) /api/v1/products/categories/:id
	function getCategory(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		var category = ModelCategories.get(rc.id);
		if(!isNull(category)){
			prc.category = category;
			rc.data['category']=category.asStruct(false,true);
			rc.data['category']["href"]=this.API_BASE_URL&'/categories/'&category.getId();
			rc.data['category']["products"]=rc.data['category']["href"]&'/products';
			rc.statusCode = STATUS.SUCCESS;
		}

	}

	//(POST) /api/v1/products/categories
	function addCategory(event,rc,prc){
		requireRole("Administrator");
		rc.statusCode = STATUS.NOT_IMPLEMENTED;

	}

	//(PUT) /api/v1/products/categories/:id
	function updateCategory(event,rc,prc){
		requireRole("Administrator");
		rc.statusCode = STATUS.NOT_IMPLEMENTED;

	}

	//(DELETE) /api/v1/products/categories/:id
	function deleteCategory(event,rc,prc){
		requireRole("Administrator");
		rc.statusCode = STATUS.NOT_IMPLEMENTED;

	}

	//(GET) /api/v1/products/categories
	function getCategories(event,rc,prc){
		rc.data = {"categories":[]};
		var categories = ModelCategories.list(asQuery=false,sortOrder="Name asc");
		for(var category in categories){
			var sCat = category.asStruct(false,true);
			sCat["href"]=this.API_BASE_URL&'/categories/'&category.getId();
			sCat["products"]=sCat.href&'/products';
			arrayAppend(rc.data.categories,sCat);
		}
		rc.statusCode = STATUS.SUCCESS;
	}	

	//(GET) /api/v1/categories/:id/products
	function getCategoryProducts(){
		runEvent("api.v1.Products.getCategory");
		if(structKeyExists(prc,'category')){
			this.marshallProducts(argumentCollection=arguments);
		}
	}

	//(GET) /api/v1/products/:id/inventory
	function getProductInventory(event,rc,prc){
		requireRole("Administrator,Editor");
		this.marshallInventory(argumentCollection=arguments);
	}

	//(GET) /api/v1/products/:id/inventory/:inventoryId
	function getInventoryItem(event,rc,prc){
		//disallow numeric lookup for reporters
		if(isUserInRole("Reporter") and !isRemoteLookup(event)){
			this.onAuthorizationFailure();
		} else {
			this.marshallInventoryItem(argumentCollection=arguments);
		}	
	}

	//(PUT|PATCH) /api/v1/products/:id/inventory/:inventoryId
	function updateInventoryItem(event,rc,prc){
		requireRole("Administrator,Editor");
		this.marshallInventoryItem(argumentCollection=arguments);
		if(structKeyExists(prc,'inventoryItem')){
			//make sure we remove the ID of the product before update
			var collection = duplicate(rc);
			structDelete(collection,'id');
			prc.inventoryItem.populate(memento=collection);
			if(prc.inventoryItem.isValid()){

				prc.inventoryItem.save();
				//re-marshals with fresh data
				this.marshallInventoryItem(argumentCollection=arguments);
			
			} else {

				rc.data.success=false;
				rc.statusCode = STATUS.EXPECTATION_FAILED
				rc.data['error'] = "The inventory item could not be updated because the data provided failed to meet validation requirements"
				rc.data['validationErrors'] = prc.inventoryItem.getValidationResults();
			}
			
		}
	}

	//(POST) /api/v1/products/:id/inventory
	function addInventoryItem(event,rc,prc){
		requireRole("Administrator,Editor");
		this.marshallProduct(argumentCollection=arguments);
		if(structKeyExists(prc,'product')){
			var collection = duplicate(rc);
			structDelete(collection,'id');
			
			var inventoryItem = ModelInventory.new(properties=collection);

			inventoryItem.setProduct(prc.product);

			if(inventoryItem.isValid()){

				prc.inventoryItem.save();
				//re-marshals with fresh data
				this.marshallInventoryItem(argumentCollection=arguments);
			
			} else {
				
				rc.data.success=false;
				rc.statusCode = STATUS.EXPECTATION_FAILED
				rc.data['error'] = "The inventory item could not be updated because the data provided failed to meet validation requirements"
				rc.data['validationErrors'] = prc.inventoryItem.getValidationResults();
			}

		}
	}

	//(GET) /api/v1/products (search)
	function list(event,rc,prc){
		this.marshallProducts(argumentCollection=arguments);
	}	

	//(POST) /api/v1/products
	function add(event,rc,prc){
		requireRole("Administrator,Editor");
		var product = ModelProducts.new(properties=rc,ignoreEmpty=true);
		product.save();
		rc.id = product.getId();
		this.marshallProduct(argumentCollection=arguments);
		rc.statusCode = STATUS.CREATED;
	}	

	//(PUT) /api/v1/products/:id
	function update(event,rc,prc){
		requireRole("Administrator,Editor");
		this.marshallProduct(argumentCollection=arguments);
		if(structKeyExists(prc,'product')){
			prc.product.populate(memento=rc);
			prc.product.save();
			//refresh our data
			this.marshallProduct(argumentCollection=arguments);
		}
	}	

	//(DELETE) /api/v1/products/:id
	function delete(event,rc,prc){
		equireRole("Administrator");
		this.marshallProduct(argumentCollection=arguments);
		if(structKeyExists(prc,product)){
			prc.product.delete();
			rc.data = {"deleted":true};
			rc.statusCode = 204;
		}
	}		

	private function marshallProduct(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		var product = ModelProducts.get(rc.id);
		if(!isNull(product)){
			rc.data['product'] = product.asStruct(false,true);
			rc.data.product['href'] = this.API_BASE_URL&'/'&product.getId();;
			var category = product.getCategory();
			rc.data.product['category'] = {"id":category.getId(),"name":category.getName(),"href":this.API_BASE_URL&'/categories/'&category.getId()};
			rc.data.product['inventory'] = this.API_BASE_URL&'/'&product.getId()&'/inventory';
			rc.statusCode = STATUS.SUCCESS;
			prc.product = product;

		}
	}	

	private function marshallProducts(event,rc,prc){
		var showCategory = true;
		if(event.valueExists('filter')){
			var products = ModelProducts.searchProducts(event);
		} else if (structKeyExists(prc,'category')) {
			var products = ModelProducts.list(criteria={"Category":prc.category},asQuery=false,order="Name ASC");
			showCategory = false;
		} else {
			var products = ModelProducts.list(asQuery=false,order="Name ASC");
		}
		rc.data['products'] = [];

		for(var product in products){
			var sProduct = product.asStruct(false,true);
			//normalize our category name
			if(showCategory){
				var category = product.getCategory();
				sProduct['category'] = {"id":category.getId(),"name":category.getName(),"href":this.API_BASE_URL&'/categories/'&category.getId()};
			}
			sProduct['href'] = this.API_BASE_URL&'/'&product.getId();
			sProduct['inventory'] = sProduct.href&'/inventory';
			arrayAppend(rc.data.products,sProduct);
		}
		prc.products = products;
		rc.statusCode = STATUS.SUCCESS;
	}

	private function marshallInventory(event,rc,prc){
		marshallProduct(argumentCollection=arguments);
		rc.data['inventory']=[];
		prc.inventoryItems = ModelInventory.list(criteria={"Product":prc.product},asQuery=false);
		for(var item in prc.inventoryItems){
			
			arrayAppend(rc.data['inventory'],assembleDefaultInventoryItemResponse(item));
			item.evict();
		}
		rc.statusCode = STATUS.SUCCESS;	
	}

	private function marshallInventoryItem(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		if(isNumeric(rc.inventoryId) and !isRemoteLookup(event)){
			prc.inventoryItem = ModelInventory.get(rc.inventoryId);	
		} else {
			prc.inventoryItem = ModelInventory.findBySerialNumber(rc.inventoryId);
		}
		if(!isNull(prc.inventoryItem)){
			rc.data['item'] = assembleDefaultInventoryItemResponse(prc.inventoryItem);

			rc.statusCode = STATUS.SUCCESS;
		}


	}

	private function assembleDefaultInventoryItemResponse(required ProductInventory Item){
			var inventoryItem = arguments.Item;
			var sItem = inventoryItem.asStruct(false,true);
			sItem = inventoryItem.asStruct(false,true);
			sItem['href'] = this.API_BASE_URL&'/'&inventoryItem.getProduct().getId()&'/inventory/'&inventoryItem.getId();
			sItem['product'] = inventoryItem.getProduct().asStruct(false,true);
			sItem['product']['href'] = this.API_BASE_URL&'/'&inventoryItem.getProduct().getId();
			//default relationships
			sItem['registration'] = false;
			sItem['customer'] = false;
			sItem['dealer'] = false;
			sItem['installer'] = false;
			sItem['distributor'] = false;
			sItem['claims'] = [];
			//registration
			var registration = inventoryItem.getRegistration();
			if(!isNull(registration)){
				sItem['registration'] = {"id":registration.getId(),"date":registration.getCreated(),"href":'/api/v1/registrations/'&registration.getId()};	
			}
			//customer data
			var customer = inventoryItem.getEndUser();
			if(!isNull(customer)){
				sItem['customer'] = customer.asStruct(false,true);
				sItem['customer']['href'] = '/api/v1/customers/'&customer.getId();
			}

			//dealer information
			var dealer = inventoryItem.getDealer();
			if(!isNull(dealer)){
				sItem['dealer'] = dealer.asStruct(false,true);
				sItem['dealer']['href'] = '/api/v1/dealers/'&dealer.getId();	
			}
			//installer
			var installer = inventoryItem.getInstaller();
			if(!isNull(installer)){
				sItem['installer'] = installer.asStruct(false,true);
				sItem['installer']['href'] = '/api/v1/dealers/'&installer.getId();	
			}
			//distributor
			var distributor = inventoryItem.getDistributor();
			if(!isNull(distributor)){
				sItem['distributor'] = distributor.asStruct(false,true);
				sItem['distributor']['href'] = '/api/v1/distributors/'&distributor.getId();	
			}

			var claims = inventoryItem.getClaims();
			if(arrayLen(claims)){
				for(var claim in claims){
					var sClaim = {"id":claim.getId(),"status":claim.getStatus(),"href":'/api/v1/claims/'&claim.getId()}
					arrayAppend(sItem.claims,sClaim);
				}
			}

			return sItem;

	}

	private function isRemoteLookup(event){
		if(event.isAjax() && findNoCase('sdk',CGI.HTTP_REFERER)) return true;
		return false;
	}	


	
}
