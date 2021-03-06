/**
* Copyright Ortus Solutions, Corp, All rights reserved
* www.ortussolutions.com
* ---
*/
component {

	// DI
	property name="settings" 		inject="coldbox:setting:relax";
	property name="APIService"		inject="id:APIService@relax";

	/**
	* Pre handler
	*/
	function preHandler( event, rc, prc ){
		// module root
		prc.root 			= event.getModuleRoot();
		// settings
		prc.settings 		= variables.settings;
		// exit handlers
		prc.xehHome 		= "relax";
		prc.xehRelax		= "relax/home/relax";
		prc.xehRelaxer		= "relax/relaxer";
		prc.xehOpenAPIDocs	= "relax/home/OpenAPIDocs";
		prc.xehDSLDocs		= "relax/home/DSLDocs";

		prepareRuntimeAssets(argumentCollection=arguments);
	}

	function prepareRuntimeAssets(event,rc,prc){
		var handler = listLast(event.getCurrentHandler(),":");
		var action = event.getCurrentAction();
		var cssViewPath = prc.root & '/includes/css/views/';
		var jsViewPath = prc.root & '/includes/js/views/';

		prc.runtimeAssets = {
			"js":[],
			"css":[]
		};

		prc.addCSS = function( assetPath ){
			arrayAppend( prc.runtimeAssets.css, assetPath );
		};

		prc.addJS = function(assetPath){
			arrayAppend( prc.runtimeAssets.js, assetPath );
		};

		// Naming convention is: {handler}.css
		var cssPathCheck = cssViewPath & "#lcase(handler)#.css";
		if( fileExists( expandPath( cssPathCheck )) ){ prc.addCSS( cssPathCheck ); }

		// Naming convention is: {handler}-{action}.css
		var cssPathCheck = cssViewPath & "#lcase(handler)#-#action#.css";
		if( fileExists( expandPath( cssPathCheck )) ){ prc.addCSS( cssPathCheck ); }

		// Naming convention is: {handler}.js
		var jsPathCheck = jsViewPath & "#lcase(handler)#.js";
		if( fileExists( expandPath(jsPathCheck) ) ){ prc.addJS( jsPathCheck ); }

		// Naming convention is: {handler}.{action}.js
		var jsPathCheck = jsViewPath & "#lcase(handler)#.#action#.js";
		if( fileExists( expandPath(jsPathCheck) ) ){ prc.addJS( jsPathCheck ); }

	}

}