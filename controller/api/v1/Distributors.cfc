/**
 *
 * @name Distributors API Controller
 * @package Suretix.API.v1
 * @description This is the Distributors API Controller
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseAPIController"{
	property name="ModelDistributor" inject="model:Distributor";
	property name="AccessRoles" default="Administrator,Editor";
	
	this.API_BASE_URL = "/api/v1/distributors";
		
	//(GET) /api/v1/distributors
	function index(event,rc,prc){
		runEvent('api.v1.Distributors.list');
	}	

	//(GET) /api/v1/distributors/:id
	function get(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallDistributor(argumentCollection=arguments);
	}	

	//(GET) /api/v1/distributors (search)
	function list(event,rc,prc){
		this.marshallDistributors(argumentCollection=arguments);
	}	

	//(POST) /api/v1/distributors
	function add(event,rc,prc){
		var distributor = Distributor.new(properties=rc,ignoreEmpty=true);

		if(distributor.isValid()){
			distributor.save();
			rc.id = distributor.getId();
			marshallDistributor(argumentCollection=arguments);
	
		} else {
	
			rc.statusCode = STATUS.NOT_ACCEPTABLE;

			rc.data['error'] = "The distributor could not be created because one or more of the required fields were incorrect.  Please try again.";
			rc.data['validationErrors'] = EndUser.getValidationResults().getAllErrors();	
	
		}
			
	}	

	//(PUT|PATCH) /api/v1/distributors/:id
	function update(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallDistributor(argumentCollection=arguments);

		if(structKeyExists(prc,'distributor')){
			var EndUser = prc.distributor;
			EndUser.populate(memento=rc)
			if(EndUser.isValid()){
				EndUser.save();
				this.marshallDistributor(argumentCollection=arguments);
		
			} else {
		
				rc.statusCode = STATUS.NOT_ACCEPTABLE;
				rc.data['error'] = "The distributor could not be updated because one or more of the required fields were incorrect.  Please try again.";
				rc.data['validationErrors'] = EndUser.getValidationResults().getAllErrors();
		
			}
		}
	}	

	//(DELETE) /api/v1/distributors/:id
	function delete(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallDistributor(argumentCollection=arguments);

		if(structKeyExists(prc,'distributor') and currentUser().hasPermission("Registration":"Manage")){
			prc.user.delete();

		} else if(structKeyExists(prc,'distributor')){
			rc.statusCode = STATUS.NOT_ALLOWED;
			rc.data['error'] = "You are not authorized to perform delete operations on distributors";	
		}
	}	

	//(GET) /api/v1/distributors/:id/inventory
	public function inventory(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;

		this.marshallDistributor(argumentCollection=arguments);

		if(structKeyExists(prc,'distributor')){
			rc.data['distributor']['inventory'] = [];
			for(var item in prc.distributor.getInventory()){
				var sItem = item.asStruct();
				sItem['href'] = '/api/v1/products/' &item.getProduct().getId()& '/inventory/' & item.getId();
				arrayAppend(rc.data['distributor']['inventory'],sItem)
			}
		}

	}

	//(PATCH) /api/v1/distributors/:id/inventory
	public function assignInventory(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallDistributor(argumentCollection=arguments);

		if(structKeyExists(prc,'distributor') && structKeyExists(rc,'Item') && isNumeric(rc.item)){
			var item = getModel("ProductInventory").get(rc.item);
			if(!isNull(item)){
				item.setDistributor(prc.distributor);
				item.save();
				this.items(argumentCollection=arguments);
			} else {
				rc.statusCode = STATUS.EXPECTATION_FAILED;
				rc.data['error'] = "The item provided for assignment to this distributor could not be found";	
			}
		}



	}

	private function marshallDistributor(event,rc,prc){
		if(structKeyExists(prc,'distributor')){
			var distributor = prc.distributor.refresh();
		} else {
			var distributor = ModelDistributor.get(rc.id);	
		}

		if(!isNull(distributor)){
			var sDistributor = distributor.asStruct(false,true);
			rc.data['distributor'] = sDistributor;
			rc.data.distributor['href'] = this.API_BASE_URL&'/'&distributor.getId();
			rc.data.distributor['inventory'] = [];
			for(var item in distributor.getInventory()){
				arrayAppend(rc.data.distributor.items,'/api/v1/products/' &item.getProduct().getId()& '/inventory/' & item.getId());
			}
			prc.distributor = distributor;
			rc.statusCode=STATUS.SUCCESS;
		}
	}	

	private function marshallDistributors(event,rc,prc){
		rc.data['distributors']=[];
		
		var distributors = ModelDistributor.list(asQuery=false,sortOrder='Name asc');

		//assemble distributor data
		for(var distributor in distributors){
			sDistributor = distributor.asStruct(false,true);
			sDistributor['href'] = this.API_BASE_URL&'/'&distributor.getId();
			arrayAppend(rc.data.distributors,sDistributor);
		}

		rc.statusCode=STATUS.SUCCESS;

	}	


	
}
