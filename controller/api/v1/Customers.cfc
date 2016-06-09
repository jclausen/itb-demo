/**
 *
 * @name Customers API Controller
 * @package Suretix.API.v1
 * @description This is the Customers API Controller
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseAPIController"{
	property name="ModelEndUsers" inject="model:EndUser";
	property name="ModelDealers" inject="model:Dealer";
	
	this.API_BASE_URL = "/api/v1/customers";
		
	//(GET) /api/v1/customers
	function index(event,rc,prc){
		runEvent('api.v1.Customers.list');
	}	

	//(GET) /api/v1/customers/:id
	function get(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallCustomer(argumentCollection=arguments);
	}	

	//(GET) /api/v1/customers (search)
	function list(event,rc,prc){
		this.marshallCustomers(argumentCollection=arguments);
	}	

	//(POST) /api/v1/customers
	function add(event,rc,prc){
		var customer = ModelEndUsers.new(properties=rc,ignoreEmpty=true);

		if(customer.isValid()){
			customer.save();
			rc.id = customer.getId();
			marshallCustomer(argumentCollection=arguments);
	
		} else {
	
			rc.statusCode = STATUS.NOT_ACCEPTABLE;

			rc.data['error'] = "The customer could not be created because one or more of the required fields were incorrect.  Please try again.";
			rc.data['validationErrors'] = EndUser.getValidationResults().getAllErrors();	
	
		}
			
	}	

	//(PUT|PATCH) /api/v1/customers/:id
	function update(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallCustomer(argumentCollection=arguments);

		if(structKeyExists(prc,'customer')){
			var EndUser = prc.customer;
			EndUser.populate(memento=rc)
			if(EndUser.isValid()){
				EndUser.save();
				this.marshallCustomer(argumentCollection=arguments);
		
			} else {
		
				rc.statusCode = STATUS.NOT_ACCEPTABLE;
				rc.data['error'] = "The customer could not be updated because one or more of the required fields were incorrect.  Please try again.";
				rc.data['validationErrors'] = EndUser.getValidationResults().getAllErrors();
		
			}
		}
	}	

	//(DELETE) /api/v1/customers/:id
	function delete(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallCustomer(argumentCollection=arguments);

		if(structKeyExists(prc,'customer') and currentUser().hasPermission("Registration":"Manage")){
			prc.user.delete();

		} else if(structKeyExists(prc,'customer')){
			rc.statusCode = STATUS.NOT_ALLOWED;
			rc.data['error'] = "You are not authorized to perform delete operations on customers";	
		}
	}	

	private function marshallCustomer(event,rc,prc){
		var customer = ModelEndUsers.get(rc.id);
		if(!isNull(customer)){
			var sCustomer = customer.asStruct(false,true);
			rc.data['customer'] = sCustomer;
			rc.data.customer['href'] = this.API_BASE_URL&'/'&customer.getId();
			rc.data.customer['items'] = [];
			for(var item in customer.getItems()){
				arrayAppend(rc.data.customer.items,'/api/v1/products/' &item.getProduct().getId()& '/inventory/' & item.getId());
			}
			prc.customer = customer;
			rc.statusCode=STATUS.SUCCESS;
		}
	}	

	private function marshallCustomers(event,rc,prc){
		rc.data['customers']=[];
		//pull customers based our our params
		if(structKeyExists(rc,'dealer')){
			var dealer = ModelDealers.get(rc.dealer);
			if(isNull(dealer)){
				rc.statusCode = STATUS.NOT_FOUND;
				rc.data.customers = javacast('null',0);
				return;
			} else {
				var customers = dealer.getCustomers()
			}
		} if(structKeyExists(rc,'installer')){
			var installer = ModelDealers.get(rc.installer);

			if(isNull(installer)){
				rc.statusCode = STATUS.NOT_FOUND;
				rc.data.customers = javacast('null',0);
				return;
			} else {
				var customers = installer.getInstallationCustomers()
			}
		} else {
			rc.maxrows = event.getValue('maxrows',25);
			rc.offset = event.getValue('offset',0);
			var qCustomers = ModelEndUsers.newCriteria();
			qCustomers.createAlias('Items','Items');
			qCustomers.createAlias('Items.Dealer','Dealer');
			qCustomers.order('Dealer.Name','ASC');
			qCustomers.order('LastName','ASC');

			var customers = qCustomers.list(asQuery=false,max=rc.maxrows,offset=rc.offset);
		}


		//assemble customer data
		for(var customer in customers){
			sCustomer = customer.asStruct(false,true);
			sCustomer['href'] = this.API_BASE_URL&'/'&customer.getId();
			arrayAppend(rc.data.customers,sCustomer);
		}

		rc.statusCode=STATUS.SUCCESS;

	}	


	
}
