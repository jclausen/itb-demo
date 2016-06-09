/**
 *
 * @name Claims API Controller
 * @package Suretix.API.v1
 * @description This is the Claims API Controller
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseAPIController"{
	property name="ClaimsModel" inject="model:Claim";
	property name="RegistrationModel" inject="model:Registration";
	property name="ClaimService" inject="model:ClaimService";

	this.API_BASE_URL = "/api/v1/Claims";	
	//(GET) /api/v1/Claims
	function index(event,rc,prc){
		runEvent('api.v1.Claims.list');
	}	

	//(GET) /api/v1/Claims/:id
	function get(event,rc,prc){
		//reporters may only make five get requests per session
		throttleRequests("Reporter");
		this.marshallClaim(argumentCollection=arguments);
	}	

	//(GET) /api/v1/Claims (search)
	function list(event,rc,prc){
		requireRole("Administrator,Editor");
		this.marshallClaims(argumentCollection=arguments);

	}	

	//(POST) /api/v1/Claims
	function add(event,rc,prc){
		var created = ClaimService.processClaim(rc);
		if(created.success){
			rc.id = created.result.getId();
			this.marshallClaim(argumentCollection=arguments);
			rc.statusCode = STATUS.CREATED;
		} else {
			rc.statusCode = STATUS.EXPECTATION_FAILED
			rc.data['error'] = created.friendlyMessage
			if(structKeyExists(created,'message')){
				rc.data['errorDetail'] = created.message;
			}	
		}
	}	

	//(PUT) /api/v1/Claims/:id
	function update(event,rc,prc){
		requireRole("Administrator,Editor");
		this.marshallClaim(argumentCollection=arguments);
		if(structKeyExists(prc,'Claim')){
			var updated = ClaimService.updateClaim(prc.Claim,rc);
			if(updated.success){
				this.marshallClaim(argumentCollection=arguments);
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

	//(DELETE) /api/v1/Claims/:id
	function delete(event,rc,prc){
		requireRole("Administrator");
		this.marshallClaim(argumentCollection=arguments);
		if(structKeyExists(prc,'Claim')){
			var deleted = ClaimService.deleteClaim(prc.Claim);
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

	
	//(GET) /api/v1/claims/questions
	function questions(event,rc,prc){
		rc.data["questions"] = [];
		rc.statusCode = STATUS.SUCCESS;
		
		var questions = getModel("Claim").getQuestions();

		for(var question in questions){
			var sQuestion = question.asStruct();
			sQuestion['answers']= [];
			var answers = question.getAnswers();
			for(var answer in answers){
				arrayAppend(sQuestion['answers'],answer.asStruct())
			}
			arrayAppend(rc.data.questions,sQuestion);
		}
	}

	//(GET,PUT,PATCH,DELETE) /api/v1/claims/comments/:id
	function comments(event,rc,prc){
		
		switch(event.getHttpMethod()){
			case "PUT":
			case "PATCH":
				var claim = ClaimsModel.get(rc.id);
				if(structKeyExists(rc,'CommentId')){
					var Comment = getModel("Comments").get(rc.CommentId);
					Comment.setContent(rc.Comment)
					Comment.save();
				} else if (structKeyExists(rc,'delete') and rc.delete){

					var Comment = getModel("Comments").get(rc.CommentId);
					Comment.delete();

				} else {
					claim.addComment(rc.Comment);
				}

				break;

			case "DELETE":
				//delete expects the id value to be the commentid
				var Comment = getModel("Comments").get(rc.id);
				if(isNull(Comment) || listLast(Comment.getModelName(),'.') != 'Claim'){
					rc.statusCode = STATUS.NOT_FOUND;
					rc.data['error'] = "The comment id was incorrect or was not found";
					return;
				} else {
					var claim = ClaimsModel.get(Comment.getModelId());
					Comment.delete();
				}

				break;

			default:
				var claim = ClaimsModel.get(rc.id);
		
				break;
		}

		rc.data['comments']=[];
		
		for(var comment in claim.refresh().getComments()){
			var sComment = comment.asStruct();
			structDelete(sComment,'modelname');
			structDelete(sComment,'modelid');
			sComment['user'] = comment.getUser().asStruct();
			structDelete(sComment['user'],'password');
			arrayAppend(rc.data['comments'],sComment);
		}

		rc.statusCode = STATUS.SUCCESS;	
	}


	private function marshallClaim(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		var claim = ClaimsModel.get(rc.id);
		if(!isNull(Claim)){
			rc.data['claim'] = assembleDefaultClaimResponse(Claim);
			rc.statusCode = STATUS.SUCCESS;
			prc.claim = Claim;
		}

	}	

	private function marshallClaims(event,rc,prc){
		rc.data['claims']=[];
		var claims = ClaimService.processSearch(rc=rc,asQuery=false);
		for(var claim in claims){
			arrayAppend(rc.data.claims,assembleDefaultclaimResponse(claim));
		}
		rc.data['sort'] = {'column':rc.sort,'order':rc.order};
		rc.data['limit'] = rc.limit;
		rc.data['offset'] = rc.offset;
		rc.data['size'] = rc.total_records;
		prc.claims = claims;
		rc.statusCode = STATUS.SUCCESS;	
	}

	private function assembleDefaultClaimResponse(Claim){

		var response = Claim.asStruct();
		response['href'] = '/api/v1/claims/'&claim.getId();
		var Item = Claim.getItem();
		var product = Item.getProduct();
		response['item'] = Item.asStruct();
		response['item']['href'] = '/api/v1/products/' &Item.getProduct().getId()& '/inventory/' & Item.getId();
		response['item']['product'] = product.asStruct();

		var endUser = Item.getEndUser()
		response['customer'] = endUser.asStruct(false,true);
		response['customer']['href'] = '/api/v1/customers/' & endUser.getId();
		
		response['comments'] = "/api/v1/claims/comments/" & claim.getId();

		//add servicer information
		var servicer = claim.getServicer();
		if(!isNull(servicer)){
			response['servicer'] = servicer.asStruct(false,true);
			response['servicer']['href'] = '/api/v1/dealers/' &servicer.getId();
		} else {
			response['servicer'] = false;
		}

		return response;
	}	


	
}
