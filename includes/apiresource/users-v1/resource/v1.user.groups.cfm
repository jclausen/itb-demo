<cfscript>
	/**
	* User Groups API (v1)
	**/

	resource(
			pattern='/api/v1/users/:id/groups',
			handler='api.v1.UserGroups',
			action=defaultAPIActions
		)
		.description("List, search and create user groups methods.  Name/value schema keys may be paired as GET request parameters to assemble a search - see below.")
		.methods("GET,POST")
		.defaultFormat("JSON")
		.header(name="Authorization", description="The authorization token which follows the pattern `Bearer {authToken}`. Existing session (desktop) or token authorization (app) is required for all API methods", required=true,type="string")
		//POST requests
		.schema(format="json",description="[POST] Example user group creation",body=fileRead(dirPath & 'request/POST.v1.user.groups.json'))
		.schema(format="json",description="[POST][201] Example response for a POST request with a `postLogin` parameter passed",body=fileRead(dirPath & 'response/GET.v1.user.groups.json'))
		//GET requests
		.schema(format="json",description="[GET] Example response for a get request",body=fileRead(dirPath & 'response/GET.v1.user.groups.json'));

	resource(
			pattern='/api/v1/users/:id/groups/:groupId',
			handler='api.v1.UserGroups',
			action=defaultEntityActions
		)
		.description("Group-specific operations on an entity")
		.methods("GET,PUT,PATCH,DELETE")
		.defaultFormat("JSON")
		.header(name="Authorization", description="The authorization token which follows the pattern `Bearer {authToken}`. Existing session (desktop) or token authorization (app) is required for all API methods", required=true,type="string")
		//GET requests
		.schema(format="json",description="[GET][200] Group Request Response",body=fileRead(dirPath & 'response/GET.v1.users.group.json'))
		//PUT/PATCH requests
		.schema(format="json",description="[PUT/PATCH] Example group modification request",body=fileRead(dirPath & 'request/PUT.v1.users.group.json'))
		.schema(format="json",description="[PUT/PATCH][200] Group modification response.",body=fileRead(dirPath & 'response/PUT.v1.users.group.json'))
		//DELETE Request
		.schema(format="json",description="[DELETE] A delete request may be used on user created groups (e.g. - Those which are not default groups created by the system.  The group will be deleted and status of 204/No Content will be returned.");

		resource(
			pattern='/api/v1/users/:id/groups/:groupId/members',
			handler='api.v1.UserGroups',
			action={"GET":"members","POST":"addUserToGroup"}
		)
		.description("List and add group memberships")
		.methods("GET,POST")
		.defaultFormat("JSON")
		//GET requests
		.schema(format="json",description="[GET][200] Group Memberships Response",body=fileRead(dirPath & 'response/GET.v1.users.groups.memberships.json'))
		//POST requests
		.schema(format="json",description="[POST] Example User group membership addition.  In this example, we are adding a user to the default group Friends, which requires a reciprocating response",body=fileRead(dirPath & 'request/POST.v1.user.groups.membership.json'))
		.schema(format="json",description="[POST][201] User group membership addition response.  When the `inverseMembershipId` key is not empty, the member addition requires a reciprocal response from the end user",body=fileRead(dirPath & 'request/POST.v1.user.groups.membership.json'));


		resource(
			pattern='/api/v1/users/:id/groups/:groupId/members/:memberId',
			handler='api.v1.UserGroups',
			action={"GET":"membership","PUT":"updateGroupMembership","PATCH":"updateGroupMembership","DELETE":"removeUserFromGroup"}
		)
		.description("Retrieval, update and deletion methods on a group membership")
		.methods("GET,PUT,PATCH,DELETE")
		.defaultFormat("JSON")
		.header(name="Authorization", description="The authorization token which follows the pattern `Bearer {authToken}`. Existing session (desktop) or token authorization (app) is required for all API methods", required=true,type="string")
		//PUT/PATCH requests
		.schema(format="json",description="[PUT/PATCH] Example group modification request",body=fileRead(dirPath & 'request/PUT.v1.users.groups.membership.json'))
		.schema(format="json",description="[PUT/PATCH][200] Group modification response.",body=fileRead(dirPath & 'response/PUT.v1.users.groups.membership.json'))
		//GET requests
		.schema(format="json",description="[GET][200] Group membership request. Mostly used to check confirmation of reciprocal requests",body=fileRead(dirPath & 'response/GET.v1.users.groups.membership.json'))
		//DELETE Request
		.schema(format="json",description="[DELETE][204] A delete request is used to remove membership from a group. No content will be returned.");





</cfscript>