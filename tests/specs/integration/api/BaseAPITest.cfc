/*******************************************************************************
*	Base API Test Class
*******************************************************************************/
component extends="coldbox.system.testing.BaseTestCase" appMapping="/" accessors=true{
	property name="Wirebox" inject="wirebox";
	property name="AppSettings" inject="wirebox:properties";
	property name="APIBaseURL" default="http://127.0.0.1:53874";
	property name="JSONPath" default="/includes/tmp/APIJSON/";
	property name="SaveJSON" default=false;
	property name="AuthToken";

	private any function apiCall(
		required string url, 
		required string type="GET", 
		required struct data={},
		required struct headers={},
		required struct files={}
	) {
		serverPort = 80;

		structAppend( ARGUMENTS.HEADERS, {"Authorization":"STX-TOKEN #VARIABLES.AuthToken.getToken()#"} );

		if(isNumeric(listLast(VARIABLES.APIBaseURL,':'))){
			serverPort = listLast(VARIABLES.APIBaseURL,':');
		}

		console("[#ARGUMENTS.type#] - #ARGUMENTS.URL#");

		var h = new Http(url=VARIABLES.APIBaseURL & arguments.url,method=arguments.type,port=serverPort);

		if( structIsEmpty( ARGUMENTS.files) ){

			if( !structIsEmpty(arguments.data) ) h.addParam(type="BODY",value=serializeJSON(arguments.data));

		} else {
			
			for( var formKey in arguments.data ){
				h.addParam( type="FormField", name=formKey, value=arguments.data[ formKey ] );
			}

			for( var fileField in ARGUMENTS.files  ){
				h.addParam( type="File", name=fileField, file=ARGUMENTS.files[ fileField ] );
			}

		}
		
		for( var headerName in headers ){
			h.addParam( type="Header", name=headerName, value=headers[ headerName ] );
		}

		var response = h.send().getPrefix();

		if( SaveJSON ){
			if(!directoryExists(expandPath(JSONPath))) directoryCreate(expandPath(JSONPath));
			if(isJSON(response.filecontent)){
				reqPath = replaceNoCase(ARGUMENTS.url,'/','.',"All");
				var filename = ucase(arguments.type) & reqPath & ".json";
				fileWrite(expandPath(JSONPath) & filename ,trim(response.filecontent));
			}
		}

		return response;
	}

	/**
	* Check for a consistent response with GET/POST/PUT/PATCH methods
	**/
	function expectConsistentAPIResponse(resp,statusCode=200){
		expect(resp).toBeStruct();
		expect(resp).toHaveKey('statuscode');

		if(resp.statuscode != ARGUMENTS.statusCode){
		 	writeOutput(resp.filecontent);
		 	abort;
		}

		// if(resp.status_code == 500){
		// 	writeOutput(resp.filecontent);
		// 	abort;
		// }

		expect(resp.statuscode).toBe(ARGUMENTS.statusCode);
		expect(resp).toHaveKey('filecontent');
		
		// if(!isJSON(resp.filecontent)){
		// 	writeOutput(resp.filecontent);
		// 	abort;
		// }
		
		
		expect(isJSON(resp.filecontent)).toBeTrue();
		return deserializeJSON(resp.filecontent);
	}

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		this.loadColdbox = true;
		//setup each as a new coldbox request
		setup();
		if(!structKeyExists(application,'wirebox')) throw("Wirebox is not available. Cannot proceed with test suite");
		application.wirebox.autowire(this);
		expect( isNull( AppSettings ) ).toBeFalse( "Autowiring failed. Could not proceed." );
		VARIABLES.AuthToken = Wirebox.getInstance( "APIToken" ).findByDescription( "Development Testing API Account" );
		expect( isNull( VARIABLES.AuthToken ) ).toBeFalse();
		VARIABLES.AuthUser = VARIABLES.AuthToken.getUser();
		expect( isNull( VARIABLES.AuthUser ) ).toBeFalse();

	}

	function afterAll(){
	}

	

}
