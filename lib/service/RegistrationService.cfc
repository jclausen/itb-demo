/**
 *
 * @name Registration Service
 * @package Suretix.Service
 * @description This is the Registration Service
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseService" singleton{
	property name="ModelRegistration" inject="model:Registration";
	property name="ModelInventory" inject="model:ProductInventory";
	property name="ModelEndUser" inject="model:EndUser";
	property name="ModelDealer" inject="model:Dealer";
	property name="MailerService" inject="model:MailerService";
	
	/**
	* Constructor
	*/
	function init(){
		
		// init super class
		super.init();
		
		// Use Query Caching
	    setUseQueryCaching( false );
	    // Query Cache Region
	    setQueryCacheRegion( "ormservice.Registration" );
	    // EventHandling
	    setEventHandling( true );
	    
	    return this;
	}
	/**
	* Search Registrations
	**/
	public function processSearch(rc={},asQuery=false){
		param name="rc.sort" default="created";
		param name="rc.order" default="desc";
		param name="rc.limit" default=25;
		param name="rc.offset" default=0;
		param name="rc.cache" default=true;
		var qReg = ModelRegistration.newCriteria(setUseQueryCaching=rc.cache);
		var conjunctions = [];
		var disjunctions = [];
		qReg.resultTransformer(qReg.DISTINCT_ROOT_ENTITY);
		qReg.createAlias('Item','Item');
		qReg.createAlias('Item.Product','Product');
		qReg.createAlias('Item.EndUser','Customer');
		qReg.createAlias('Item.Dealer','Dealer');
		qReg.createAlias('Item.Installer','Installer');
		qReg.createAlias('Item.Distributor','Distributor');

		//if we have a search term set all of our arguments
		if(structKeyExists(rc,'search')){
			if(!structKeyExists(rc,'product')) rc['product']=rc.search;
			if(!structKeyExists(rc,'customer')) rc['customer']=rc.search;
			if(!structKeyExists(rc,'dealer')) rc['dealer']=rc.search;
			if(!structKeyExists(rc,'installer')) rc['installer']=rc.search;
			if(!structKeyExists(rc,'distributor')) rc['distributor']=rc.search;
		}

		if(structKeyExists(rc,'sn')){
			arrayAppend( conjunctions,qReg.restrictions.eq('Item.serialNumber',javacast('string',rc.sn)) );
		}

		//search by product
		if(structKeyExists(rc,'product')){
			if(isNumeric(rc.product)){			
				arrayAppend(conjunctions,qReg.restrictions.eq('Product.id',javacast('int',rc.product)));		
			} else {
				var productSearch = [
					qReg.restrictions.iLike('Product.Name','%#rc.product#%'),
					qReg.restrictions.iLike('Product.ModelNumber','%#rc.product#%'),
					qReg.restrictions.iLike('Product.Description','%#rc.product#%')
				]
				arrayAppend(disjunctions,productSearch,true);
			}
		}

		//search by customer
		if(structKeyExists(rc,'customer')){
			if(isNumeric(rc.customer)){			
				arrayAppend(conjunctions,qReg.restrictions.eq('Customer.id',javacast('int',rc.customer)));		
			} else {
				var customerSearch = [
					qReg.restrictions.iLike('Customer.FirstName','%#rc.customer#%'),
					qReg.restrictions.iLike('Customer.LastName','%#rc.customer#%')
				]
				arrayAppend(disjunctions,customerSearch,true);
			}
		}

		//search by dealer
		if(structKeyExists(rc,'dealer')){
			if(isNumeric(rc.dealer)){			
				arrayAppend(conjunctions,qReg.restrictions.eq('Dealer.id',javacast('int',rc.dealer)));		
			} else {
				var dealerSearch = [
					qReg.restrictions.iLike('Dealer.Name','%#rc.dealer#%'),
					qReg.restrictions.iLike('Dealer.ContactName','%#rc.dealer#%')
				]
				arrayAppend(disjunctions,dealerSearch,true);
			}
		}

		//search by distributor
		if(structKeyExists(rc,'distributor')){
			if(isNumeric(rc.distributor)){			
				arrayAppend(conjunctions,qReg.restrictions.eq('Distributor.id',javacast('int',rc.distributor)));		
			} else {
				var distributorSearch = [
					qReg.restrictions.iLike('Distributor.Name','%#rc.distributor#%'),
					qReg.restrictions.iLike('Distributor.ContactName','%#rc.distributor#%')
				]
				arrayAppend(disjunctions,distributorSearch,true);
			}
		}

		if(arrayLen(conjunctions)) qReg.Conjunction(conjunctions);
		if(arrayLen(disjunctions)) qReg.Disjunction(disjunctions);

		rc.total_records = qReg.count();

		return qReg.list(asQuery=ARGUMENTS.asQuery,max=rc.limit,offset=rc.offset,sortOrder=rc.sort & ' ' & rc.order);

	}

	/**
	* Process a registration
	**/
	public function processRegistration(required struct collection){
		var response = newResponse();
		
		// we can't do anything without an item
		if(!structKeyExists(collection,"inventoryId") and !structKeyExists(collection,"SerialNumber")){
			response['success']=false;
			response['friendlyMessage'] = "Registration could not proceed because no associated item was provided";
			response['error'] = "Item";
			return response;
		} else {
			if(structKeyExists(collection,"SerialNumber")){
				var InventoryItem = ModelInventory.findBySerialNumber(collection.SerialNumber);
			} else {
				var InventoryItem = ModelInventory.get(collection.inventoryId);
			}

			if(isNull(InventoryItem)){
				response['success']=false;
				response['friendlyMessage'] = "Registration could not proceed because the item provided could not be found";
				response['error'] = "Item";
				return response;
			} else if(!isNull( ModelRegistration.findWhere({'Item':InventoryItem}) )){
				response['success']=false;
				response['friendlyMessage'] = "A registration already exists for this item.  We could not proceed";
				response['error'] = "Registration";
				return response;
			}
			//handle our collection first
			var Registration = ModelRegistration.new(properties=collection,ignoreEmpty=true);
			InventoryItem.populate(memento=collection);
			
		}


		//validate and create our relationships
		var EndUser = processEndUser(InventoryItem,collection,false);

		if(!isObject(EndUser)){
			Registration.delete();
			//break out if invalid object
			return EndUser;
		}
		
		//Pass the flag to dealer to save, if possible
		var Dealer = processDealer(InventoryItem,collection,false);
		
		if(!isObject(Dealer)){
			Registration.delete();
			return Dealer;
		}

		

		//Wrap up and return response - setting our dealer as the same		
		InventoryItem.setInstaller(Dealer);
		InventoryItem.save();

		Registration.setItem(InventoryItem);
		processQuestionResponses(Registration, arguments.collection)
		Registration.save();

		processNotifications(Registration);

		response.result = Registration;
		response.success = true;

		return response;

	}

	/**
	* Update an existing registration
	**/
	public function updateRegistration(required Registration Registration,required struct collection){
		var response = newResponse();

		Registration.populate(memento=ARGUMENTS.collection);

		if(structKeyExists(collection,'endUserId')){
			var EndUser = processEndUser(Registration,collection);
			if(!isStruct(EndUser)){
				Registration.setEndUser(EndUser);
			} else {
				//break out if !valiation
				return EndUser;
			}	
		}
		
		if(structKeyExists(collection,'endUserId')){
			var Dealer = processDealer(InventoryItem,collection);
			if(isStruct(Dealer)){
				return Dealer;
			}	
		}

		//Wrap up and return response
		Registration.save();
		response.result = Registration;
		response.success = true;

		return response;

	}

	public function deleteRegistration(required Registration Registration){
		var response = newResponse();
		var InventoryItem = Registration.getItem();
		
		if(!arrayLen(InventoryItem.getClaims())){
			
			var EndUser = InventoryItem.getEndUser();
			var Dealer = InventoryItem.getDealer();
			var Installer = InventoryItem.getInstaller();
			var installerSame = true;
			//clear out our inventoryItem data
			InventoryItem.setEndUser(javacast('null',0));
			InventoryItem.setDealer(javacast('null',0));
			InventoryItem.setInstaller(javacast('null',0));
			InventoryItem.setInstallDate(javacast('null',0));
			InventoryItem.setOrderNumber(javacast('null',0));
			
			InventoryItem.save();
			//Now evaluate our End User and Dealer information

			if(!arrayLen(EndUser.refresh().getItems())){
				EndUser.delete();
			}
			if(Dealer.getId() != Installer.getId()){
				installerSame = false; 
			}

			if(!arrayLen(Dealer.getCustomers())){
				Dealer.delete();
			}

			if(!installerSame and !arrayLen(Installer.getCustomers())){
				Installer.delete();
			}
			response.success = true;

		} else {
			response.success=false;
			response['friendlyMessage']='This registration already has existing warranty claims and may not be deleted';
			response['message']="The system found #arrayLen(InventoryItem.getClaims())# existing claims for the inventory item."
		}
		
		return response;
	}

	private function processQuestionResponses(required Registration Registration, required struct collection){
		var questions = Registration.getQuestions(active=true);
		var answers = [];
		for(var question in questions){
			var sResponse = {"question":question.getQuestion()};
			if(structKeyExists(collection,'question-response-#question.getId()#')){
				sResponse["response"] = collection['question-response-#question.getId()#'];
				arrayAppend(answers,sResponse);
			}

		}

		Registration.setAnswers(serializeJSON(answers));
	}


	private function processEndUser(required ProductInventory InventoryItem,collection,saveItem=true){
		//End User
		if(structKeyExists(collection,'endUserId')){
			var EndUser = ModelEndUser.get(collection.endUserId);
		} else {
			var sEndUser = {};
			
			for(var key in collection){
				if( findNoCase('EndUser_',key) and len(collection[key]) ) sEndUser[replaceNoCase(key,'EndUser_','',"ALL")]=collection[key];
			}

			//attempt to find an existing User
			var EndUser = matchEndUser(sEndUser);
			
			//if not found, create a new record
			if(isNull(EndUser)){
				var EndUser = ModelEndUser.new(properties=sEndUser);
			} else {
				EndUser.populate(memento=sEndUser);
			}

			if(EndUser.isValid()){
				EndUser.save();
				InventoryItem.setEndUser(EndUser);

			} else {
				var response = newResponse();
				response.success = false;
				response.friendlyMessage="Registration could not proceed because the End User information did pass validation.  Please try again.";
				response.message = EndUser.getValidationResults().getAllErrors();
				response.errors = EndUser.getValidationResults();
				//break out
				return response;

			}
		}
		if(ARGUMENTS.saveItem) InventoryItem.save();

		return EndUser;

	}

	public function matchEndUser(required sEndUser){
		if(structKeyExists(sEndUser,'Email')){
				var EndUser = ModelEndUser.findByEmail(sEndUser.Email);	
		} else {
			var ExistingUsers = ModelEndUser.findAllWhere({'FirstName':sEndUser.firstname,'LastName':sEndUser.lastName,'Address1':sEndUser.address1,'Zip':sEndUser.Zip});
			if(arrayLen(ExistingUsers)){
				var EndUser = ExistingUsers[1];
			}
		}

		if(!isNull(EndUSer)){
			return EndUser;
		} else{
			return javacast('null',0);
		}
	}

	/**
	* Import/Export Functions
	**/


	public function processRegistrationsExport(required startDate,required endDate=now()){
		var response = newResponse();
		var q = ModelRegistration.newCriteria();
		q.add(q.restrictions.GE('created', ParseDateTime(ARGUMENTS.startDate) ));
		q.add(q.restrictions.LE('created', ParseDateTime(ARGUMENTS.endDate) ));
		q.order('created','DESC');
		var exportRegistrations = q.list(asQuery=false);
		if(!arrayLen(exportRegistrations)){
			response.message = "#arrayLen(exportRegistrations)# found with start date #startDate# and end date #endDate#";
			response.friendlyMessage = "No registrations were found which matched your search criteria.  Please adjust your date range and try again.";
			return response;
		} 
		var exportColumns = ["Registration Number","Admin URL","Customer Name","Address","Phone Number","Email","Suretix Product","Serial Number","Installation Type","Installation Date","Dealer Name"];
		//use our first registration to pull our question data
		var baseReg = exportRegistrations[1];
		for( var answer in deSerializeJSON(baseReg.getAnswers()) ){
			arrayAppend(exportColumns,htmlToText(answer.question));
		}

		var qExport = queryNew(arrayToList(exportColumns));
		for(var registration in exportRegistrations){
			var item = registration.getItem();
			var customer = item.getEndUser();
			var dealer = item.getDealer();
			var rowNumber = queryAddRow(qExport);
			querySetCell(qExport,"Registration Number",registration.getId(),rowNumber);
			querySetCell(qExport,"Admin URL",AppSettings.secure_URL & '/registration/detail/id/' & registration.getId(),rowNumber);
			querySetCell(qExport,"Customer Name",customer.getFirstName() & ' ' & customer.getLastName(),rowNumber);
			querySetCell(qExport,"Address",textFormatEntityAddress(customer),rowNumber);
			querySetCell(qExport,"Phone Number",customer.getPhone(),rowNumber);
			querySetCell(qExport,"Email",customer.getEmail(),rowNumber);
			querySetCell(qExport,"Suretix Product",item.getProduct().getModelNumber(),rowNumber);
			querySetCell(qExport,"Serial Number",item.getSerialNumber(),rowNumber);
			querySetCell(qExport,"Installation Type",item.getInstallType(),rowNumber);
			querySetCell(qExport,"Installation Date",dateFormat(item.getInstallDate(),'mm/dd/yyyy'),rowNumber);
			querySetCell(qExport,"Dealer Name",dealer.getName(),rowNumber);

			for(var answer in deSerializeJSON(registration.getAnswers())){
				//if we have any question differences between registrations we need to add a new column
				if(!arrayFind(exportColumns,htmlToText(answer.question))){
					queryAddColumn(qExport,htmlToText(answer.question));
				}
				querySetCell(qExport,htmlToText(answer.question),len(answer.response)?answer.response:'NoResponse',rowNumber);
			}

			//evict our item to free up resources for the next iteration
			registration.evict();
		}

		var response.result = Wirebox.getInstance("FileService").queryToExcel(qExport);

		return response;


	}

	private function processDealer(required ProductInventory InventoryItem,required struct collection,saveItem=true){

		//Dealer & Installer
		if(structKeyExists(collection,'dealerId')){
			var Dealer = ModelDealer.get(collection.dealerId);
			if(isNull(Dealer)){
				//break out if no dealer
				response.success=false;
				response.friendlyMessage="Registration could not proceed because the Dealer provided by the ID #dealerId# could not be found";
				response.message = "Dealer Not Found";
				response.errors = {}
				return response;
			}
		} else {
			var sDealer = {};
			for(var key in collection){
				if( findNoCase('Dealer_',key) and len(collection[key]) ) sDealer[replaceNoCase(key,'Dealer_','',"ALL")]=collection[key];
			}

			structAppend(sDealer,duplicate(collection),false);


			//Try to find an existing dealer
			var Dealer = ModelDealer.findByNameAndCityAndState(sDealer.Name,sDealer.City,sDealer.State);
			
			if(isNull(Dealer)){
				var Dealer = ModelDealer.new(sDealer);
				
				if(Dealer.isValid()){
					Dealer.save();
				} else {
					response.success=false;
					response.friendlyMessage="Registration could not proceed because the Dealer information did pass validation.  Please try again.";
					response.message = Dealer.getValidationResults().getAllErrors();
					response.errors = Dealer.getValidationResults();
					//break out if !valiation
					return response;
				}	
			}

		}

		//Set the Dealer and Installer as the same
		InventoryItem.setDealer(Dealer);

		if(ARGUMENTS.saveItem) InventoryItem.save();

		return Dealer;

	}

	private function processNotifications(required Registration Registration){
		var EndUser = arguments.Registration.getItem().getEndUser();
		var companyName = structKeyExists(appSettings,"tennantCompanyName")?appSettings.tennantCompanyName:"";
		//send our user confirmation email if they have provided us with one
		if( len( EndUser.getEmail() ) ){

			MailerService.send(argumentCollection={
				"to":EndUser.getEmail(),
				"from":structKeyExists(AppSettings,'email_from')?AppSettings.email_From:"suretix@intothebox.org",
				"subject":"Thank you for registering your #companyName# product",
				"view"='email/external/confirmRegistration',
				viewArgs={"EndUser":EndUser,"AppSettings":AppSettings}
			});
		}

		//send our system notification to our tennant
		// Turned Off Per Request from story #110411790 https://www.pivotaltracker.com/story/show/110411790
		// MailerService.send(argumentCollection={
		// 		"to":AppSettings.registration_to,
		// 		"from":structKeyExists(AppSettings,'email_from')?AppSettings.email_from:"suretix@intothebox.org",
		// 		"subject":"[Suretix] New Registration Received from #companyName#",
		// 		"view"='email/internal/notifyRegistration',
		// 		viewArgs={"Registration":arguments.Registration,"AppSettings":AppSettings}
		// });
		
	}
	
}
