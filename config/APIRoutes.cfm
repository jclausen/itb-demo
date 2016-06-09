<cfscript>
	// API Routing
	var defaultAPIActions = {"GET":"index","POST":"add","PUT":"onInvalidHTTPMethod","PATCH":"onInvalidHTTPMethod","DELETE":"onInvalidHTTPMethod"}
	var defaultModificationActions = {"GET":"get","PUT":"update","PATCH":"update","DELETE":"delete"}

	/**
	* API Specials
	**/
	addRoute(
		pattern='/api/v1/specials/:action',
		handler='api.v1.Specials'
	);

	/**
	* API Flash Messages
	**/
	addRoute(
		pattern='/api/v1/flash/message/:message?',
		handler='api.v1.Flash',
		action={"GET":"index","PUT":"index","POST":"index"}
	);	

	/**
	* Product API (v1)
	**/
	addRoute(
		pattern='/api/v1/products/categories/:id/products',
		handler='api.v1.Products',
		action={"GET":"getCategoryProducts"}
	);

	addRoute(
		pattern='/api/v1/products/categories/:id',
		handler='api.v1.Products',
		action={"GET":"getCategory","PUT":"updateCategory","DELETE":"deleteCategory"}
	);

	addRoute(
		pattern='/api/v1/products/categories',
		handler='api.v1.Products',
		action={"GET":"getCategories","PUT":"addCategory"}
	);

	addRoute(
		pattern='/api/v1/products/:id/inventory/:inventoryId',
		handler='api.v1.Products',
		action={"GET":"getInventoryItem","PUT":"updateInventoryItem","PATCH":"updateInventoryItem"}
	);

	addRoute(
		pattern='/api/v1/products/:id/inventory',
		handler='api.v1.Products',
		action={"GET":"getProductInventory","POST":"addInventoryItem"}
	);

	addRoute(
		pattern='/api/v1/products/:id',
		handler='api.v1.Products',
		action=defaultModificationActions
	);

	addRoute(
		pattern='/api/v1/products',
		handler='api.v1.Products',
		action=defaultAPIActions
	);

	/**
	* Registrations API (v1)
	**/
	
	addRoute(
		pattern='/api/v1/registrations/questions',
		handler='api.v1.Registrations',
		action={"GET":"questions","POST":"onInvalidHTTPMethod","PUT":"onInvalidHTTPMethod","DELETE":"onInvalidHTTPMethod"}
	);

	addRoute(
		pattern='/api/v1/registrations/comments/:id',
		handler='api.v1.Registrations',
		action={"GET":"comments","PUT":"comments","PATCH":"comments","DELETE":"comments"}
	);

	addRoute(
		pattern='/api/v1/registrations/:id',
		handler='api.v1.Registrations',
		action=defaultModificationActions
	);

	addRoute(
		pattern='/api/v1/registrations',
		handler='api.v1.Registrations',
		action=defaultAPIActions
	);
	

	/**
	* Claims API (v1)
	**/
	

	addRoute(
		pattern='/api/v1/claims/questions',
		handler='api.v1.Claims',
		action={"GET":"questions","POST":"onInvalidHTTPMethod","PUT":"onInvalidHTTPMethod","DELETE":"onInvalidHTTPMethod"}
	);

	addRoute(
		pattern='/api/v1/claims/comments/:id',
		handler='api.v1.Claims',
		action={"GET":"comments","PUT":"comments","PATCH":"comments","DELETE":"comments"}
	);

	addRoute(
		pattern='/api/v1/claims/:id',
		handler='api.v1.Claims',
		action=defaultModificationActions
	);

	addRoute(
		pattern='/api/v1/claims',
		handler='api.v1.Claims',
		action=defaultAPIActions
	);

	/**
	* Dealers API
	**/

	addRoute(
		pattern='/api/v1/dealers/:id',
		handler='api.v1.Dealers',
		action=defaultModificationActions
	);

	addRoute(
		pattern='/api/v1/dealers',
		handler='api.v1.Dealers',
		action=defaultAPIActions
	);


	/**
	* End Users API
	**/

	addRoute(
		pattern='/api/v1/customers/dealer/:dealer',
		handler='api.v1.Customers',
		action={"GET":"index"}
	);

	addRoute(
		pattern='/api/v1/customers/installer/:installer',
		handler='api.v1.Customers',
		action={"GET":"index"}
	);

	addRoute(
		pattern='/api/v1/customers/:id',
		handler='api.v1.Customers',
		action=defaultModificationActions
	);

	addRoute(
		pattern='/api/v1/customers',
		handler='api.v1.Customers',
		action=defaultAPIActions
	);

	/**
	* User API (v1)
	**/

	addRoute(
		pattern='/api/v1/users/roles',
		handler='api.v1.Users',
		action={"GET":"roles"}
	);

	addRoute(
		pattern='/api/v1/users/:id',
		handler='api.v1.Users',
		action=defaultModificationActions
	);

	addRoute(
		pattern='/api/v1/users',
		handler='api.v1.Users',
		action=defaultAPIActions
	);

	/**
	* Distributors API
	**/

	addRoute(
		pattern='/api/v1/distributors/:id/items',
		handler='api.v1.Distributors',
		action={"GET":"inventory","PATCH":"assignInventory"}
	);

	
	addRoute(
		pattern='/api/v1/distributors/:id',
		handler='api.v1.Distributors',
		action=defaultModificationActions
	);

	addRoute(
		pattern='/api/v1/distributors',
		handler='api.v1.Distributors',
		action=defaultAPIActions
	);



	/**
	* States API (v1)
	**/
	addRoute(
		pattern='/api/v1/states',
		handler='api.v1.States',
		action=defaultAPIActions
	);


</cfscript>