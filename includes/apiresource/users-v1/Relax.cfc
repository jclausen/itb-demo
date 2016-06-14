component output=false{
// Description :
// 	Relax Resources Definition.  For documentation on how to build this CFC
// 	look at our documenation here: http://wiki.coldbox.org/wiki/Projects:Relax.cfm
//	
// 	The methods you can use for defining your RESTful service are:
//	
// 	// Service is used to define the service
// 	- service(title:string,
// 		      description:string,
// 			  entryPoint:string or struct
// 			  extensionDetection:boolean,
// 			  validExtensions:list,
// 			  throwOnInvalidExtensions:boolean);
//	
// 	// GlobalHeader() is used to define global headers which can be concatenated
// 	- globalHeader(name:string, description:string, required:boolean, default:any, type:string);
//	
// 	// globalParam() is used to define global params which can be concatenated
// 	- globalParam(name:string, description:string, required:boolean, default:any, type:string);
//	
// 	// Resources are defined by concatenating the following methods
// 	// The resource() takes in all arguments that match the SES addRoutes() method
// 	resource(pattern:string, handler:string, action:string or struct)
// 		.description(string)
// 		.methods(string or list)
// 		.header(name:string, description:string, required:boolean, default:any, type:string)
// 		.param(name:string, description:string, required:boolean, default:any, type:string)
// 		.placeholder(name:string, description:string, required:boolean, default:any, type:string)
// 		.schema(format:string, description:string, body:string)
// 		.sample(format:string, description:string, body:string);
		
VARIABLES.defaultAPIActions = {"GET":"index","POST":"add","PUT":"onInvalidHTTPMethod","PATCH":"onInvalidHTTPMethod","DELETE":"onInvalidHTTPMethod"};
VARIABLES.defaultEntityActions = {"GET":"get","PUT":"update","PATCH":"update","DELETE":"delete"};

	
	// I save the location of this CFC path to use resources located here
	variables.dirPath = getDirectoryFromPath( getMetadata(this).path ); 
	
	function configure(){
		
		/************************************** SERVICE DEFINITION *********************************************/
		
		// This is where we define our RESTful service, this is usually
		// our first place before even building it, we spec it out.
		this.relax = {
			// Service Title
			title = "Users API (v1)",
			// Service Description
			description = "Core User API Services",
			// Service entry point, can be a single string or name value pairs to denote tiers
			//entryPoint = "http://www.myapi.com",
			entryPoint = {
				development  = "http://127.0.0.1:62500",
				production = "https://equi.io"
			},
			// Does it have extension detection via ColdBox
			extensionDetection = false,
			// Valid format extensions
			validExtensions = "",
			// Does it throw exceptions when invalid extensions are detected
			throwOnInvalidExtension = false		
		};
		
		/************************************** GLOBAL PARAMS +  HEADERS *********************************************/

		// Global API Headers
		globalHeader(name="Authoriziation",description="The authorization token string required for authentication. If not provided only public data will be displayed. If invalid, a 405 response is returned",required=false);
		
		/************************************** RESOURCES *********************************************/
		//v1 Users API
		include 'resource/v1.users.cfm';
		include 'resource/v1.user.groups.cfm';
		include 'resource/v1.user.settings.cfm';
		
	}

}
