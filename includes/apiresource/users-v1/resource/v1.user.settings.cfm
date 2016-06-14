<cfscript>
	/**
	* User Settings API (v1)
	**/

	resource(
			pattern='/api/v1/users/:id/settings',
			handler='api.v1.UserGroups',
			action={"GET":"get","PUT":"update","PATCH":"update","POST":"onInvalidHTTPMethod","DELETE":"onInvalidHTTPMethod"}
		)
		.description("Retreive or update user settings")
		.methods("GET,PUT,PATCH")
		.defaultFormat("JSON")
		.header(
			name="Authorization", 
			description="The authorization token which follows the pattern `Bearer {authToken}`. Existing session (desktop) or token authorization (app) is required for all API methods. Settings retrieval and modification is restricted to a single user.", 
			required=true,
			type="string"
		)
		//GET requests
		.schema(
			format="json",
			description="[GET][200] Retrieve the settings for a user",
			body=fileRead(dirPath & 'response/GET.v1.user.settings.json')
		)
		.schema(
			format="json",
			description="[PUT|PATCH][200] Update the settings for a user. Several custom keys, including block, unblock, watch, and unwatch are available for use in common settings methods.  See samples for details.",
			body=fileRead(dirPath & 'response/GET.v1.user.settings.json')
		)
		.sample(
			format="json",
			description="[PUT|PATCH] Example request to block another user (form vars or JSON body)",
			body='{"block":"569c1871fd33f3270c8dba48"}'
		)
		.sample(
			format="json",
			description="[PUT|PATCH] Example request to unblock another user (form vars or JSON body)",
			body='{"unblock":"569c1871fd33f3270c8dba48"}'
		)
		.sample(
			format="json",
			description="[PUT|PATCH] Example request to watch (e.g. - receive notifications about) another user (form vars or JSON body)",
			body='{"watch":"569c1871fd33f3270c8dba48"}'
		)
		.sample(
			format="json",
			description="[PUT|PATCH] Example request to unwatch another user (form vars or JSON body)",
			body='{"unwatch":"569c1871fd33f3270c8dba48"}'
		);

</cfscript>