component{

	// Configure ColdBox Application
	function configure(){

		// coldbox directives
		coldbox = {
			//Application Setup
			appName 				= "Suretix",
			eventName 				= "event",

			//Development Settings
			reinitPassword			= "",
			handlersIndexAutoReload = false,

			//Implicit Events
			defaultEvent			= "",
			requestStartHandler		= "Main.onRequestStart",
			requestEndHandler		= "",
			applicationStartHandler = "Main.onAppInit",
			applicationEndHandler	= "",
			sessionStartHandler 	= "",
			sessionEndHandler		= "",
			missingTemplateHandler	= "",

			//Extension Points
			applicationHelper 			= "includes/helpers/ApplicationHelper.cfm",
			viewsHelper					= "",
			modulesExternalLocation		= [],
			viewsExternalLocation		= "",
			layoutsExternalLocation 	= "",
			handlersExternalLocation  	= "",
			requestContextDecorator 	= "lib.decorators.RequestContextDecorator",
			controllerDecorator			= "",

			//Error/Exception Handling
			exceptionHandler		= "",
			onInvalidEvent			= "",
			//our generic error template handles everything
			customErrorTemplate 	= "/views/_templates/generic_error.cfm",

			//Application Aspects
			handlerCaching 			= true,
			eventCaching			= true,
			proxyReturnCollection 	= false
		};

		//custom Messagebox template
		messagebox = {
			template = "/views/modules/cbmessagebox/MessageBox.cfm"
		};
		// custom settings
		settings = {
			//Default HTML Variables
			site_title="Into The Box Customer Support",
			seo_title="",
			author="Into The Box",
			meta_desc="",
			meta_keywords="",
			//default urls
			base_url="http://suretix.intothebox.org",
			secure_url="https://suretix.intothebox.org",
			//production debug variables
			show_debug="false",
			//Email variables
			email_from="suretix@intothebox.org",
			error_from="suretix@intothebox.org",
			error_to="support@intothebox.org",
			registration_to="registrations@intothebox.org",
			claim_to="suretix@intothebox.org",
			//Misc settings
			//Paging
			PagingMaxRows = 50,
			PagingBandGap = 10,
			//Authentication PW Salt
			pw_salt='5ur3T1XW4rr4n7y',
			//Asset Paths
			cssPagePath = '/includes/css/view/',
			jsPagePath = '/includes/js/opt/view/',
			//Tenant Settings - Required
			tennantCompanyName='Ortus Solutions',
			tennantCompanyShortName='Ortus',
			tennantLogo = 'http://www.intothebox.org/includes/images/itblogo-mini.png',
			tennantBaseURL = 'http://intothebox.org',
			tennantSupportPhone = '1-800-555-1212',

			//Default ad/agent values
			import_maps = {
				"ProductInventory" = {
					'serialNumber':'Serial Number',
					'InstallationDate':'Installation Date'
				},
				'Product':{
					'ModelNumber':'Product Model Number',
					'Name':'Product Name'
				},
				'Distributor':{
					'Name':'Distributor Name',
					'Address1':'End User Address',
					'City':'End User City',
					'State':'End User State',
					'Zip':'End User PostalCode'
				},
				'EndUser':{
					'FirstName':'End User Name',
					'LastName':'End User Name',
					'Address1':'End User Address',
					'City':'End User City',
					'State':'End User State',
					'Zip':'End User PostalCode',
					'Phone':'End User Phone',
					'Email':'End User Email'
				},
				'Dealer':{
					'Name':'Dealer Name',
					'Address1':'Dealer Address',
					'City':'Dealer City',
					'State':'Dealer State',
					'Zip':'Dealer PostalCode',
					'Phone':'Dealer Phone',
					'Email':'Dealer Email'
				}

			},

			// ORM services, injection, etc
			orm = {
				// entity injection
				injection = {
					// enable it
					enabled = true,
					// the include list for injection
					include = "",
					// the exclude list for injection
					exclude = ""
				}
			}

		};

		//Mailsettings
		mailSettings = {
			username="abc123",
			password="ITB2016",
			server="smtp.sendgrid.net",
			port=587,
			//default from address
			from='suretix@intothebox.org',

		    // The default token Marker Symbol
		    tokenMarker = "@"
		};

		//RELAX Configuration
		relax = {
			APILocation 	= "includes.apiresource",
			defaultAPI 		= "users-v1",
			maxHistory		= 10
		};


		// environment settings, create a detectEnvironment() method to detect it yourself.
		// create a function with the name of the environment so it can be executed if that environment is detected
		// the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = {
			development = "^*localhost,127.0.0.1,192.168.1.143",
			staging = "^*silowebworks.com"
		};

		// Module Directives
		modules = {
			//Turn to false in production
			autoReload = false,
			// An array of modules names to load, empty means all of them
			include = [],
			// An array of modules names to NOT load, empty means none
			exclude = []
		};

		//LogBox DSL
		logBox = {
			// Define Appenders
			appenders = {
				coldboxTracer = { class="coldbox.system.logging.appenders.ConsoleAppender" }
			},
			// Root Logger
			root = { levelmax="INFO", appenders="*" },
			// Implicit Level Categories
			info = [ "coldbox.system" ]
		};

		//Layout Settings
		layoutSettings = {
			defaultLayout = "",
			defaultView   = ""
		};

		//Interceptor Settings
		interceptorSettings = {
			throwOnInvalidStates = false,
			customInterceptionPoints = ""
		};

		//Register interceptors as an array, we need order
		interceptors = [
			//SES
			{
				class="coldbox.system.interceptors.SES",
				properties={}
			},
			//Security Interceptor
			{
				class="cbsecurity.interceptors.Security", 
				name="ApplicationSecurity", 
				properties={
					useRegex = true, 
					rulesSource = "json", 
					rulesFile = findNoCase('intothebox.org',CGI.SERVER_NAME)?"config/security.json.cfm":"config/security.dev.json.cfm"
				}
			}
		];

		//Conventions
		conventions = {
			handlersLocation = "controller",
			viewsLocation 	 = "views",
			layoutsLocation  = "layouts",
			modelsLocation 	 = "lib/model",
			eventAction 	 = "index"
		};

	}

	// Development Environment
	function development(){
		//Override Settings
		coldbox.debugmode=false;
		coldbox.handlersIndexAutoReload = true;
		coldbox.handlerCaching = false;
		coldbox.eventCaching = false;
		coldbox.reinitpassword = "";
		coldbox.debugpassword = "";
		wirebox.singletonreload = true;
		modules.autoReload=true;

		//Debugger Settings
		debugger.showRCPanel = false;

		logbox.debug = ["root"];
		
		//Custom Settings
		coldbox.customErrorTemplate = "/coldbox/system/includes/BugReport.cfm";
		settings.show_debug="true";
		settings.email_from="suretix@intothebox.org";
		settings.error_from="suretix@intothebox.org";
		settings.error_to="jon_clausen@silowebworks.com";
		settings.registration_to="jon_clausen@silowebworks.com";
		settings.claim_to="jon_clausen@silowebworks.com";
			
	}

	function staging(){
		return development();
	}

}