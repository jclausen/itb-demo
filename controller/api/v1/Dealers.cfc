/**
 *
 * @name Users API Controller
 * @package Suretix.API.v1
 * @description This is the Users API Controller
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseAPIController"{
	property name="ModelDealers" inject="model:Dealer";
	
	this.API_BASE_URL = "/api/v1/dealers";
		
	//(GET) /api/v1/dealers
	function index(event,rc,prc){
		runEvent('api.v1.Dealers.list');
	}	

	//(GET) /api/v1/dealers/:id
	function get(event,rc,prc){
		throttleRequests("Reporter");
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallDealer(argumentCollection=arguments);
	}	

	//(GET) /api/v1/dealers (search)
	function list(event,rc,prc){
		this.marshallDealers(argumentCollection=arguments);
	}	

	//(POST) /api/v1/dealers
	function add(event,rc,prc){
		requireRole("Administrator");
		var Dealer = ModelDealers.new(properties=rc,ignoreEmpty=true);

		if(Dealer.isValid()){
			Dealer.save();
			rc.id = Dealer.getId();
			marshallDealer(argumentCollection=arguments);
	
		} else {
	
			rc.statusCode = STATUS.NOT_ACCEPTABLE;

			rc.data['error'] = "The dealer record could not be created because one or more of the required fields were incorrect.  Please try again.";
			rc.data['validationErrors'] = Dealer.getValidationResults().getAllErrors();	
	
		}
			
	}	

	//(PUT|PATCH) /api/v1/dealers/:id
	function update(event,rc,prc){
		requireRole("Administrator");
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallDealer(argumentCollection=arguments);

		if(structKeyExists(prc,'Dealer')){
			var Dealer = prc.Dealer
			Dealer.populate(memento=rc);
			if(Dealer.isValid()){
				Dealer.save();
				this.marshallDealer(argumentCollection=arguments);
		
			} else {
		
				rc.statusCode = STATUS.NOT_ACCEPTABLE;
				rc.data['error'] = "The dealer record could not be updated because one or more of the required fields were incorrect.  Please try again.";
				rc.data['validationErrors'] = Dealer.getValidationResults().getAllErrors();
		
			}
		}
	}	

	//(DELETE) /api/v1/dealers/:id
	function delete(event,rc,prc){
		requireRole("Administrator")
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallDealer(argumentCollection=arguments);

		if(structKeyExists(prc,'Dealer') and currentUser().hasPermission("Registration":"Manage")){
			prc.user.delete();

		} else if(structKeyExists(prc,'Dealer')){
			rc.statusCode = STATUS.NOT_ALLOWED;
			rc.data['error'] = "You are not authorized to perform delete operations on dealers";	
		}
	}	

	private function marshallDealer(event,rc,prc){
		var Dealer = ModelDealers.get(rc.id);
		if(!isNull(Dealer)){
			var sDealer = Dealer.asStruct(false,true);
			rc.data['dealer'] = sDealer;
			rc.data.dealer['href'] = this.API_BASE_URL&'/'&Dealer.getId();
			rc.data.dealer['customers'] = '/api/v1/customers/dealer/'&Dealer.getId();
			if(Dealer.getIsInstaller()){
				rc.data.dealer['installations'] = '/api/v1/customers/installer/'&Dealer.getId();
			}
			prc.dealer = Dealer;
			rc.statusCode=STATUS.SUCCESS;
		}
	}	

	private function marshallDealers(event,rc,prc){
		rc.data['Dealers']=[];
		
		rc.maxrows = event.getValue('maxrows',25);
		rc.offset = event.getValue('offset',0);
		var qDealers = ModelDealers.newCriteria();
		qDealers.order('Name','ASC');
		var Dealers = qDealers.list(asQuery=false,max=rc.maxrows,offset=rc.offset);
		
		//assemble Dealer data
		for(var Dealer in Dealers){
			sDealer = Dealer.asStruct(false,true);
			sDealer['href'] = this.API_BASE_URL&'/'&Dealer.getId();
			sDealer['customers'] = '/api/v1/customers/dealer/'&Dealer.getId();
			if(Dealer.getIsInstaller()){
				sDealer['installations'] = '/api/v1/customers/installer/'&Dealer.getId();
			}
			arrayAppend(rc.data.Dealers,sDealer);
		}

		rc.statusCode=STATUS.SUCCESS;

	}	


	
}
