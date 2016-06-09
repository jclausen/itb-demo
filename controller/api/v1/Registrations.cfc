/**
 *
 * @name Registrations API Controller
 * @package Suretix.API.v1
 * @description This is the Registrations API Controller
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseAPIController"{
	property name="RegistrationsModel" inject="model:Registration";
	property name="RegistrationService" inject="model:RegistrationService";

	this.API_BASE_URL = "/api/v1/registrations";
		
	//(GET) /api/v1/registrations
	function index(event,rc,prc){
		runEvent('api.v1.Registrations.list');
	}	

	//(GET) /api/v1/registrations/:id
	function get(event,rc,prc){
		//reporters may only make five get requests per session
		throttleRequests("Reporter");
		this.marshallRegistration(argumentCollection=arguments);
	}	

	//(GET) /api/v1/registrations (search)
	function list(event,rc,prc){
		requireRole("Administrator,Editor");
		this.marshallRegistrations(argumentCollection=arguments);
	}	

	//(POST) /api/v1/registrations
	function add(event,rc,prc){
		var created = RegistrationService.processRegistration(rc);
		if(created.success){
			rc.id = created.result.getId();
			this.marshallRegistration(argumentCollection=arguments);
			rc.statusCode = STATUS.CREATED;
		} else {
			rc.statusCode = STATUS.EXPECTATION_FAILED
			rc.data['error'] = created.friendlyMessage
			if(structKeyExists(created,'message')){
				rc.data['errorDetail'] = created.message;
			}	
		}
	}	

	//(PUT) /api/v1/registrations/:id
	function update(event,rc,prc){
		requireRole("Administrator,Editor");
		this.marshallRegistration(argumentCollection=arguments);
		if(structKeyExists(prc,'registration')){
			var updated = RegistrationService.updateRegistration(prc.registration,rc);
			if(updated.success){
				this.marshallRegistration(argumentCollection=arguments);
				rc.statusCode = STATUS.SUCCESS;
			} else {
				rc.statusCode = STATUS.EXPECTATION_FAILED
				rc.data['error'] = updated.friendlyMessage
				if(structKeyExists(updated,'message')){
					rc.data['errorDetail'] = updated.message;
				}				
			}
		}
	}	

	//(DELETE) /api/v1/registrations/:id
	function delete(event,rc,prc){
		requireRole("Administrator");
		this.marshallRegistration(argumentCollection=arguments);
		if(structKeyExists(prc,'registration')){
			var deleted = RegistrationService.deleteRegistration(prc.registration);
			if(deleted.success);
			rc.data = {"deleted":true};
			rc.statusCode = STATUS.NO_CONTENT;
		} else {
			rc.statusCode = STATUS.EXPECTATION_FAILED
			rc.data['error'] = updated.friendlyMessage
			if(structKeyExists(updated,'message')){
				rc.data['errorDetail'] = updated.message;
			}
		}
	}		

	//(GET) /api/v1/registrations/questions
	function questions(event,rc,prc){
		rc.data["questions"] = [];
		rc.statusCode = STATUS.SUCCESS;

		var questions = RegistrationsModel.getQuestions(true);
		
		for(var question in questions){
			var sQuestion = question.asStruct();
			structDelete(sQuestion,"modelName");
			structDelete(sQuestion,"modelId");
			sQuestion['answers']= [];
			var answers = question.getAnswers();
			for(var answer in answers){
				arrayAppend(sQuestion['answers'],answer.asStruct());				
			}
			arrayAppend(rc.data["questions"],sQuestion);
		}

	}
	
	//(GET,PUT,PATCH,DELETE) /api/v1/registrations/comments/:id
	function comments(event,rc,prc){
		
		switch(event.getHttpMethod()){
			case "PUT":
			case "PATCH":
				var registration = RegistrationsModel.get(rc.id);
				if(structKeyExists(rc,'CommentId')){
					var Comment = getModel("Comments").get(rc.CommentId);
					Comment.setContent(rc.Comment)
					Comment.save();
				} else if (structKeyExists(rc,'delete') and rc.delete){

					var Comment = getModel("Comments").get(rc.CommentId);
					Comment.delete();

				} else {
					registration.addComment(rc.Comment);
				}

				break;

			case "DELETE":
				//delete expects the id value to be the commentid
				var Comment = getModel("Comments").get(rc.id);
				if(isNull(Comment) || listLast(Comment.getModelName(),'.') != 'Registration'){
					rc.statusCode = STATUS.NOT_FOUND;
					rc.data['error'] = "The comment id was incorrect or was not found";
					return;
				} else {
					var registration = RegistrationsModel.get(Comment.getModelId());
					Comment.delete();
				}

				break;

			default:
				var registration = RegistrationsModel.get(rc.id);
		
				break;
		}

		rc.data['comments']=[];
		
		for(var comment in registration.refresh().getComments()){
			var sComment = comment.asStruct();
			structDelete(sComment,'modelname');
			structDelete(sComment,'modelid');
			sComment['user'] = comment.getUser().asStruct();
			structDelete(sComment['user'],'password');
			arrayAppend(rc.data['comments'],sComment);
		}

		rc.statusCode = STATUS.SUCCESS;	
	}

	private function marshallRegistration(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		var registration = RegistrationsModel.get(rc.id);
		if(!isNull(registration)){
			var InventoryItem = registration.getItem();
			rc.data['registration'] = assembleDefaultRegistrationResponse(registration);
			prc.registration = registration;
			rc.statusCode = STATUS.SUCCESS;
		}

	}	

	private function marshallRegistrations(event,rc,prc){
		rc.data['registrations']=[];
		var registrations = RegistrationService.processSearch(rc=rc,asQuery=false);
		for(var reg in registrations){
			arrayAppend(rc.data.registrations,assembleDefaultRegistrationResponse(reg));
		}
		rc.data['sort'] = {'column':rc.sort,'order':rc.order};
		rc.data['limit'] = rc.limit;
		rc.data['offset'] = rc.offset;
		rc.data['size'] = rc.total_records;
		prc.registrations = registrations;
		rc.statusCode = STATUS.SUCCESS;	
	}

	private function assembleDefaultRegistrationResponse(registration){
		var response = registration.asStruct();
		var item = registration.getItem();
		var product = item.getProduct();
		response['item'] = item.asStruct();
		response['item']['href'] = '/api/v1/products/' &product.getId()& '/inventory/' & item.getId();
		response['item']['product'] = product.asStruct();
		
		var endUser = item.getEndUser()
		response['customer'] = endUser.asStruct(false,true);
		response['customer']['href'] = '/api/v1/customers/' &endUser.getId();

		var dealer = item.getDealer();
		if(!isNull(dealer)){
			response['dealer'] = dealer.asStruct(false,true);
			response['dealer']['href'] = '/api/v1/dealers/' &dealer.getId();
		} else {
			response['dealer']=false;
		}
		
		response['comments'] = "/api/v1/registrations/comments/" & registration.getId();
		
		var installer = item.getInstaller();
		if(!isNull(installer)){
			response['installer'] = installer.asStruct(false,true);
			response['installer']['href'] = '/api/v1/dealers/' &installer.getId()	
		} else {
			response['installer'] = false;
		}

		return response;
	}	


	
}
