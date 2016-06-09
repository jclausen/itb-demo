/**
 *
 * @name Base API Controller
 * @package Suretix.API.v1
 * @description This is the Base API Controller
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component accessors=true{
	property name="METHODS";
	property name="STATUS";
	property name="AccessRoles" default="Administrator,Editor,Reporter";

	//Verb aliases - in case we are dealing with legacy browsers or servers
	METHODS = {
		"GET":"GET",
		"POST":"POST",
		"PATCH":"PATCH",
		"PUT":"PUT",
		"DELETE":"DELETE"
	};
	
	//HTTP STATUS CODES
	STATUS = {
		"CREATED":201,
		"SUCCESS":200,
		"NO_CONTENT":204,
		"BAD_REQUEST":400,
		"NOT_AUTHORIZED":401,
		"NOT_FOUND":404,
		"NOT_ALLOWED":405,
		"NOT_ACCEPTABLE":406,
		"EXPECTATION_FAILED":417,
		"INTERNAL_ERROR":500,
		"NOT_IMPLEMENTED":501
	};

	//Default allowed methods
	this.allowedMethods={
		'index'		= METHODS.GET,
		'questions'	= METHODS.GET,
		'get' 		= METHODS.GET,
		'add' 		= METHODS.POST,
		'update' 	= METHODS.PUT & ',' & METHODS.PATCH,
		'delete'	= METHODS.DELETE
	}
	
	function preHandler(event,action,eventArguments){
		var rc = event.getCollection();
		var prc = event.getCollection(private=true);
		rc.format="JSON";

		//404 default
		rc.statusCode=STATUS.NOT_FOUND;
		rc.data = {};
		event.noLayout();

		//handle any content payloads
		try{
			if(len(getHttpRequestData().content) and isJson(getHttpRequestData().content)) structAppend(rc, deserializeJson(getHttpRequestData().content),true);
		} catch(any e){
			//empty catch for bad JSON
		}

		//set our access control allow origin header for cross-domain requests
		header name="Access-Control-Allow-Origin" value="*";

		//process our login tokens (logged in users will be logged out and re-logged in again if the token is passed with different credentials)
		processAuthenticationTokens(event,rc,prc);
		
		if(!isUserLoggedIn()){
			this.onAuthorizationFailure(event,rc,prc)
		}
		
		//require our minimum access roles
		requireRole(AccessRoles);	
	}

	function postHandler(event,action,eventArguments,rc,prc){
		event.renderData( type=rc.format, data=rc.data, statusCode=rc.statusCode, statusMessage=structKeyExists(rc,'statusMessage')?rc.statusMessage:"Success");  
	}

	/**
	* Token Authentication and Login
	**/
	public function processAuthenticationTokens(event,rc,prc){
		var headers = GetHttpRequestData().headers;
		//logout our user after 5 minutes, if using token auth
		if(isUserLoggedIn() and structKeyExists(session,'tokenAuthentication') and session.tokenAuthentication and ( now() > dateAdd( 'm', 5, session.currentUser.lastLogin ) ) ){
			logoutUser();
		}

		if(structKeyExists(headers,'Authorization')){
			var authHeader = listToArray(headers.Authorization,' ');
			if(arrayLen(authHeader) == 2 and authHeader[1] == 'STX-TOKEN'){
				var token = authHeader[2];

				var APIToken = getModel("APIToken").findByToken(token);
				if(!isNull(APIToken) and !isNull(APIToken.getUser())){
					var user = APIToken.getUser();
					//logoout the existing user if the token is different and re-login
					if(len(getAuthUser()) and user.getEmail() != getAuthUser()) {
						logoutUser();
						loginUser(user,arguments.rc,true);
					} else if(!isUserLoggedIn() and !isNull(user)) {
						loginUser(user,arguments.rc,true);
					}
				}
			}
		}
	}

	/**
	* Common Methods
	**/

	public function fourOhFour(event,rc,prc){
		rc.statusCode = STATUS.NOT_FOUND;
		rc.data['message'] = "The entity requested could not be found";
	}

	/**
	* on invalid http verbs
	*/
	function onInvalidHTTPMethod( faultAction, event, rc, prc ){
		rc.data['success']=false;
	   	rc.data['error'] = "Invalid HTTP Method Execution of (#arguments.faultAction#): #event.getHTTPMethod()#";
		log.warn( rc.data.error, getHTTPRequestData() );
	   	event.renderData( type="JSON", data=rc.data, statusCode=STATUS.NOT_ALLOWED, statusMessage="Invalid HTTP Method");   
	}

	function onMissingAction(event,rc,prc,missingAction,eventArguments){
		rc.data['success']=false;
	   	rc.data['error'] = "Action '#arguments.missingAction#' could not be found";
		log.warn( rc.data.error, getHTTPRequestData() );
	   	event.renderData( type="JSON", data=rc.data, statusCode=STATUS.NOT_FOUND, statusMessage="Not Found"); 			
	}

	/**
	* Render the failure of authorization
	**/
	function onAuthorizationFailure(event=getRequestContext(),rc=getRequestCollection(),prc=getRequestCollection(private=true)){
		log.warn( "Authorization Failure", getHTTPRequestData() );
		header statusCode=STATUS.NOT_AUTHORIZED statusText="Not Authorized";
		writeOutput(serializeJSON({'message':'Your permissions do not allow this operation'}));
		flush;
		abort;
	}

	/**
	* Throttles the number of requests for a resource
	* Logs out the user on failure and displays the limit message
	**/
	public function throttleRequests(roles,max=5,event=getRequestContext(),rc=getRequestCollection()){
		var request_key = lCase(replaceNoCase(event.getCurrentRoutedURL(),'/','_','all'));
		var event = getRequestContext();
		if(isUserInAnyRole(roles)){
			if(!structKeyExists(session,'requestThrottle')) session.requestThrottle={};
			if(!structKeyExists(session.requestThrottle,request_key));
				session.requestThrottle[request_key]=0;
			session.requestThrottle[request_key]++;

			if(session.requestThrottle[request_key] > arguments.max){
				rc.statusMessage = "Resource request limit exceeded";
				rc.data = {"message":"You have exceeded the allowed number of requests for this resource"};
				logoutUser();
				onAuthorizationFailure();
			}
		}
	}

	public function requireRole(roles){
		if(isArray(arguments.roles)) arguments.roles = arrayToList(arguments.roles);
		if(!isUserInAnyRole(arguments.roles)){
			return this.onAuthorizationFailure();
		}
	}


	public function requirePermission(permissions){
		var user = getModel("User").findById(SESSION.currentUser.id);
		if(isNull(user) or !user.hasPermission(permissions)) 
			return onAuthorizationFailure();
	}

	// function onError( event, rc, prc, faultaction, exception ){
	// 	//show the full stack trace for errors if in dev
	// 	if(getSetting("environment") == 'development'){
	// 		errorDetail = arguments.exception;
	// 	} else {
	// 		errorDetail = arguments.exception.detail;
	// 	}
	// 	rc.data = {'message': arguments.exception.message,'detail': errorDetail,'rc':rc};
	// 	rc.statusCode = STATUS.INTERNAL_ERROR;
	// }
		

	
}
