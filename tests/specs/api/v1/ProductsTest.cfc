/*******************************************************************************
*	Integration Test as BDD (CF10+ or Railo 4.1 Plus)
*
*	Extends the integration class: coldbox.system.testing.BaseTestCase
*
*	so you can test your ColdBox application headlessly. The 'appMapping' points by default to 
*	the '/root' mapping created in the test folder Application.cfc.  Please note that this 
*	Application.cfc must mimic the real one in your root, including ORM settings if needed.
*
*	The 'execute()' method is used to execute a ColdBox event, with the following arguments
*	* event : the name of the event
*	* private : if the event is private or not
*	* prePostExempt : if the event needs to be exempt of pre post interceptors
*	* eventArguments : The struct of args to pass to the event
*	* renderResults : Render back the results of the event
*******************************************************************************/
component extends="coldbox.system.testing.BaseTestCase" appMapping="/"{
	
	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/
	
	function run(){

		describe( "api/v1/Products Suite", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request for this suite, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			});

			it( "index", function(){
				var event = execute( event="api.v1.Products.index", renderResults=true );
				// expectations go here.
				
			});

			it( "get", function(){
				var event = execute( event="api.v1.Products.get", renderResults=true );
				// expectations go here.
				
			});

			it( "list", function(){
				var event = execute( event="api.v1.Products.list", renderResults=true );
				// expectations go here.
				
			});

			it( "add", function(){
				var event = execute( event="api.v1.Products.add", renderResults=true );
				// expectations go here.
				
			});

			it( "update", function(){
				var event = execute( event="api.v1.Products.update", renderResults=true );
				// expectations go here.
				
			});

			it( "delete", function(){
				var event = execute( event="api.v1.Products.delete", renderResults=true );
				// expectations go here.
				
			});

			it( "marshallProduct", function(){
				var event = execute( event="api.v1.Products.marshallProduct", renderResults=true );
				// expectations go here.
				
			});

			it( "marshallProducts", function(){
				var event = execute( event="api.v1.Products.marshallProducts", renderResults=true );
				// expectations go here.
				
			});

		
		});

	}

}