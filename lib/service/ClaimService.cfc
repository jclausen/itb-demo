/**
 *
 * @name Claims Service
 * @package Suretix.Service
 * @description This is the Claims Service
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseService" singleton{
	property name="ModelClaim" inject="model:Claim";
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
	    setQueryCacheRegion( "ormservice.Claim" );
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
		if(len(rc.order > 4)){
			switch(rc.order){
				case "ascending":
					rc.order='asc';
					break;
				case "descending":
					rc.order='desc';
					break;
				default:
					rc.order='asc';
			}
		}
		var qReg = ModelClaim.newCriteria(setUseQueryCaching=rc.cache);
		var conjunctions = [];
		var disjunctions = [];
		qReg.resultTransformer(qReg.DISTINCT_ROOT_ENTITY);
		qReg.createAlias('Servicer','Servicer');
		qReg.createAlias('Item','Item');
		qReg.createAlias('Item.Product','Product');
		qReg.createAlias('Item.EndUser','Customer');
		qReg.createAlias('Item.Dealer','Dealer');
		qReg.createAlias('Item.Installer','Installer');
		qReg.createAlias('Item.Distributor','Distributor');
		//if we have a search term set all of our arguments
		if(structKeyExists(rc,'search')){
			if(!structKeyExists(rc,'product')) rc['product']=rc.search;
			if(!structKeyExists(rc,'dealer')) rc['dealer']=rc.search;
			if(!structKeyExists(rc,'servicer')) rc['servicer']=rc.search;
			if(!structKeyExists(rc,'customer')) rc['customer']=rc.search;
		}
		if(structKeyExists(rc,'sn')){
			arrayAppend( conjunctions,qReg.restrictions.eq('Item.serialNumber',rc.sn) );
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
		//search by product
		if(structKeyExists(rc,'inventoryitem')){
			if(isNumeric(rc.product)){			
				arrayAppend(conjunctions,qReg.restrictions.eq('Item.id',javacast('int',rc.inventoryitem)));		
			} else {
				arrayAppend(conjunctions,qReg.restrictions.eq('Item.SerialNumber',rc.inventoryitem));
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

		//search by servicer
		if(structKeyExists(rc,'servicer')){
			if(isNumeric(rc.servicer)){			
				arrayAppend(conjunctions,qReg.restrictions.eq('Servicer.id',javacast('int',rc.servicer)));		
			} else {
				var servicerSearch = [
					qReg.restrictions.iLike('Servicer.Name','%#rc.servicer#%'),
					qReg.restrictions.iLike('Servicer.ContactName','%#rc.servicer#%')
				]
				arrayAppend(disjunctions,servicerSearch,true);
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
	public function processClaim(required struct collection){
		var response = newResponse();
		
		// we can't do anything without an item
		if(!structKeyExists(collection,"inventoryId") and !structKeyExists(collection,"SerialNumber")){
			response['success']=false;
			response['friendlyMessage'] = "Claim could not proceed because no associated item was provided";
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
				response['friendlyMessage'] = "Claim could not proceed because the item provided could not be found";
				response['error'] = "Item";
				return response;
			} else if(arrayLen( ModelClaim.findAllWhere({'Item':InventoryItem,'FailureDate':collection.FailureDate}) )){
				response['success']=false;
				response['friendlyMessage'] = "We have already received a claim for Serial Number #InventoryItem.getSerialNumber()# with a failure date of #dateFormat(collection.FailureDate,'mm/dd/yyyy')#.  A customer service representative is currently evaluating this claim.  If this claim is for a new product, please verify your serial number and try again.";
				response['error'] = "Claim";
				return response;
			}
			//Update any necessary fields in our item
			if(!len(InventoryItem.getInstallDate())) InventoryItem.setInstallDate(collection.InstallDate);
			//handle our collection first
			var Claim = ModelClaim.new(properties=collection,ignoreEmpty=true);
			
		}


		//validate and create our relationships
		var EndUser = processEndUser(InventoryItem,collection,false);

		if(!isObject(EndUser)){
			Claim.delete();
			//break out if invalid object
			return EndUser;
		}
		
		//Pass the flag to dealer to save, if possible
		var Servicer = processServicer(InventoryItem,collection,false);
		
		if(!isObject(Servicer)){
			Claim.delete();
			return Servicer;
		}

		//Set our Servicer as our dealer/installer, if the item wasn't previously registered
		if(isNull(InventoryItem.getDealer())) InventoryItem.setDealer(Servicer);
		if(isNull(InventoryItem.getInstaller())) InventoryItem.setInstaller(Servicer);

		

		//Wrap up and return response		
		Claim.setItem(InventoryItem);
		Claim.setServicer(Servicer);
		Claim.setEndUser(EndUser);

		processQuestionResponses(Claim, arguments.collection);

		if(InventoryItem.isValid() and Claim.isValid()){
			InventoryItem.save();
			Claim.save();			
		} else if(!Claim.isValid()) {
			var response = newResponse();
			response.success = false;
			response.friendlyMessage="Claim could not proceed because the information did pass validation.  Please try again.";
			response.message = Claim.getValidationResults().getAllErrors();
			response.errors = Claim.getValidationResults();
			//break out
			return response;

		} else if(!InventoryItem.isValid()){
			var response = newResponse();
			response.success = false;
			response.friendlyMessage="Claim could not proceed because the Product did pass validation.  Please try again.";
			response.message = InventoryItem.getValidationResults().getAllErrors();
			response.errors = InventoryItem.getValidationResults();
			//break out
			return response;
		}


		processNotifications(Claim);

		response.result = Claim;
		response.success = true;

		return response;

	}

	/**
	* Update an existing registration
	**/
	public function updateClaim(required Claim Claim,required struct collection){
		var response = newResponse();

		Claim.populate(memento=collection);

		if(structKeyExists(collection,'endUserId')){
			var EndUser = processEndUser(Claim,collection);
			if(!isStruct(EndUser)){
				Claim.setEndUser(EndUser);
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
		Claim.save();
		response.result = Claim;
		response.success = true;

		return response;

	}

	public function deleteClaim(required Claim Claim){
		var response = newResponse();
		var InventoryItem = Claim.getItem();
		
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

	private function processQuestionResponses(required Claim Claim, required struct collection){
		var questions = Claim.getQuestions(active=true);
		var answers = [];
		for(var question in questions){
			var sResponse = {"question":question.getQuestion()};
			if(structKeyExists(collection,'question-response-#question.getId()#')){
				sResponse["response"] = collection['question-response-#question.getId()#'];
				arrayAppend(answers,sResponse);
			}

		}

		Claim.setAnswers(serializeJSON(answers));
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
				//Set our end user for the inventory item if has not been set
				if(isNull(InventoryItem.getEndUser())) InventoryItem.setEndUser(EndUser);
			} else {
				var response = newResponse();
				response.success = false;
				response.friendlyMessage="Claim could not proceed because the End User information did pass validation.  Please try again.";
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


	public function processClaimsExport(required startDate,required endDate=now()){
		var response = newResponse();
		var q = ModelClaim.newCriteria();
		q.add(q.restrictions.GE('created', ParseDateTime(ARGUMENTS.startDate) ));
		q.add(q.restrictions.LE('created', ParseDateTime(ARGUMENTS.endDate) ));
		q.order('created','DESC');
		var exportClaims = q.list(asQuery=false);
		if(!arrayLen(exportClaims)){
			response.message = "#arrayLen(exportClaims)# found with start date #startDate# and end date #endDate#";
			response.friendlyMessage = "No claims were found which matched your search criteria.  Please adjust your date range and try again.";
			return response;
		} 
		var exportColumns = ["Claim Number","Admin URL","Customer Name","Address","Phone Number","Email","Suretix Product","Serial Number","Failure Date","Servicer Name","Servicer Phone","Claim Notification Email"];
		//use our first claim to pull our question data
		var baseReg = exportClaims[1];
		for( var answer in deSerializeJSON(baseReg.getAnswers()) ){
			arrayAppend(exportColumns,htmlToText(answer.question));
		}

		var qExport = queryNew(arrayToList(exportColumns));
		for(var claim in exportClaims){
			var item = claim.getItem();
			var customer = item.getEndUser();
			var servicer = claim.getServicer();
			var rowNumber = queryAddRow(qExport);
			querySetCell(qExport,"Claim Number",claim.getId(),rowNumber);
			querySetCell(qExport,"Admin URL",AppSettings.secure_URL & '/claim/detail/id/' & claim.getId(),rowNumber);
			querySetCell(qExport,"Customer Name",customer.getFirstName() & ' ' & customer.getLastName(),rowNumber);
			querySetCell(qExport,"Address",textFormatEntityAddress(customer),rowNumber);
			querySetCell(qExport,"Phone Number",customer.getPhone(),rowNumber);
			querySetCell(qExport,"Email",customer.getEmail(),rowNumber);
			querySetCell(qExport,"Suretix Product",item.getProduct().getModelNumber(),rowNumber);
			querySetCell(qExport,"Serial Number",item.getSerialNumber(),rowNumber);
			querySetCell(qExport,"Failure Date",dateFormat(claim.getFailureDate(),'mm/dd/yyyy'),rowNumber);
			querySetCell(qExport,"Servicer Name",servicer.getName(),rowNumber);
			querySetCell(qExport,"Servicer Phone",servicer.getPhone(),rowNumber);
			querySetCell(qExport,"Claim Notification Email",claim.getNotificationEmail(),rowNumber);

			for(var answer in deSerializeJSON(claim.getAnswers())){
				//if we have any question differences between claims we need to add a new column
				if(!arrayFind(exportColumns,htmlToText(answer.question))){
					queryAddColumn(qExport,htmlToText(answer.question));
				}
				querySetCell(qExport,htmlToText(answer.question),len(answer.response)?answer.response:'NoResponse',rowNumber);
			}

			//evict our item to free up resources for the next iteration
			claim.evict();
		}

		var response.result = Wirebox.getInstance("FileService").queryToExcel(qExport);

		return response;


	}

	private function processServicer(required ProductInventory InventoryItem,required struct collection,saveItem=true){

		//Dealer & Installer
		if(structKeyExists(collection,'dealerId')){
			var Servicer = ModelDealer.get(collection.dealerId);
			if(isNull(Dealer)){
				//break out if no dealer
				response.success=false;
				response.friendlyMessage="Claim could not proceed because the Dealer provided by the ID #dealerId# could not be found";
				response.message = "Dealer Not Found";
				response.errors = {}
				return response;
			}
		} else {
			var sDealer = {};
			for(var key in collection){
				if( findNoCase('Servicer_',key) and len(collection[key]) ) sDealer[replaceNoCase(key,'Servicer_','',"ALL")]=collection[key];
			}

			structAppend(sDealer,duplicate(collection),false);


			//Try to find an existing dealer
			var Servicer = ModelDealer.findByNameAndCityAndState(sDealer.Name,sDealer.City,sDealer.State);
			
			if(isNull(Dealer)){
				var Servicer = ModelDealer.new(sDealer);
				
				if(Servicer.isValid()){
					Servicer.setIsServicer(true);
					Servicer.save();
				} else {
					response.success=false;
					response.friendlyMessage="Claim could not proceed because the Dealer information did pass validation.  Please try again.";
					response.message = Dealer.getValidationResults().getAllErrors();
					response.errors = Dealer.getValidationResults();
					//break out if !valiation
					return response;
				}	
			} else {
				if(!Servicer.getIsServicer()){
					Servicer.setIsServicer(true).save();
				}
			}

		}

		//If we don't have an existing dealer/installer record for the item
		if(isNull(InventoryItem.getDealer())) InventoryItem.setDealer(Servicer);
		if(isNull(InventoryItem.getInstaller())) InventoryItem.setInstaller(Servicer);

		if(ARGUMENTS.saveItem) InventoryItem.save();

		return Servicer;

	}

	private function processNotifications(required Claim Claim){

		var companyName = structKeyExists(appSettings,"tennantCompanyName")?appSettings.tennantCompanyName:"";
		//send our user confirmation email if they have provided us with one
		if( len( Claim.getNotificationEmail() ) ){

			MailerService.send(argumentCollection={
				"to":Claim.getNotificationEmail(),
				"from":structKeyExists(AppSettings,'email_from')?AppSettings.email_From:"suretix@intothebox.org",
				"subject":"Your #companyName# Warranty Claim Form Has Been Submitted",
				"view"='email/external/confirmClaimReceived',
				viewArgs={"Claim":arguments.Claim,"AppSettings":AppSettings}
			});
		}

		//send our system notification to our tennant
		MailerService.send(argumentCollection={
				"to":AppSettings.registration_to,
				"from":structKeyExists(AppSettings,'email_from')?AppSettings.email_from:"suretix@intothebox.org",
				"subject":"[Suretix] New #companyName# Warranty Claim Received",
				"view"='email/internal/notifyClaimReceived',
				viewArgs={"Claim":arguments.Claim,"AppSettings":AppSettings}
		});
		
	}
	
	
}
