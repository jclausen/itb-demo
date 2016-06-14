<cfscript>
	/**
	* User API (v1)
	**/

	resource(
			pattern='/api/v1/users',
			handler='api.v1.Users',
			action=defaultAPIActions
		)
		.description("List, search and create user methods.  Name/value schema keys may be paired as GET request parameters to assemble a search - see below.")
		.methods("GET,POST")
		.defaultFormat("json")
		.header(name="Authorization", description="The authorization token which follows the pattern `Bearer {authToken}`. If not provided, only publicly available data will be provided.", required=false,type="string")
		.param(name="postLogin",description="[POST] Whether to perform a login of the user after the resource is created",required=false,type='boolean',default="false")
		//POST requests
		.sample(format="json",description="[GET] Example search for user by last name.",body=fileRead(dirPath & 'request/GET.v1.users.searchLastName.json'))
		.sample(format="json",description="[POST] Example user creation",body=fileRead(dirPath & 'request/POST.v1.users.json'))
		.schema(format="json",description="[POST] Example response for a POST request with a `postLogin` parameter passed",body=fileRead(dirPath & 'response/GET.v1.user.json'))
		//GET requests
		.schema(format="json",description="[GET] Example response for a get request",body=fileRead(dirPath & 'response/GET.v1.users.json'));

	resource(
			pattern='/api/v1/users/:id',
			handler='api.v1.Users',
			action=defaultEntityActions
		)
		.description("API operations for a single user")
		.methods("GET,PUT,PATCH,DELETE")
		.defaultFormat("json")
		.placeholder(name="id", description="The user identifier (either the _id value or the idTag, if it exists)", required=true, type="string")
		.header(name="Authorization", description="The authorization token which follows the pattern `Bearer {authToken}`. If not provided, only publicly available data will be provided.", required=false,type="string")
		.sample(format="json",description="[PUT,PATCH] Example request content for an update - JSON body or FORM",body=fileRead(dirPath & 'request/PUT.v1.user.json'))
		.schema(format="json",description="[GET,PUT,PATCH] Example response for an authenticated request - includes expanded information",body=fileRead(dirPath & 'response/GET.v1.user.json'))
		.schema(format="json",description="[GET] Example response for a public request - restricts information",body=fileRead(dirPath & 'response/GET.v1.user.public.json'));


	resource(
			pattern='/api/v1/users/login',
			handler='api.v1.Users',
			action={"POST":"login","DELETE":"login"}
		)
		.description("Login and Logout a user.  For POST methods, email and password parameters are required")
		.methods("POST,DELETE")
		.defaultMethod("POST")
		.defaultFormat("json")
		.header(name="Authorization", description="The authorization token which follows the pattern `Bearer {authToken}`. If not provided, only publicly available data will be provided.", required=false,type="string")
		.param(name="email",description="The email of the user to login",required=true)
		.param(name="password",description="The user password for login",required=true)
		.sample(format="json",description="[POST] The the request content - JSON body or FORM",body=fileRead(dirPath & 'request/POST.v1.users.login.json'))
		.schema(format="json",description="[POST][201] Example response for a successful login",body=fileRead(dirPath & 'response/POST.v1.users.login.SUCCESS.json'))
		.schema(format="json",description="[POST][405] Example response for a failed login",body="{}")
		.schema(format="json",description="[DELETE] A delete response logs out the user and delivers a 204 response (No Content)", body="");



</cfscript>