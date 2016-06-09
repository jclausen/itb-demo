/**
 *
 * @name Base Controller
 * @package Suretix.Model
 * @description This is the Base Controller for the Application
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component name="baseHandler" extends="coldbox.system.EventHandler" output=false{
	property name="MessageBox" inject="MessageBox@cbmessagebox";
		
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};

	function preHandler( event, rc, prc, action, eventArguments ){
		prepareAssetBag(event,rc,prc);
		rc.messagebox = MessageBox;
		//check that login keys exist and re-activate the session if necessary
		if(!structKeyExists(session,'currentUser') and len( getAuthUser() )){
			var currentUser = getModel("User").findByEmail(getAuthUser());
			currentUser.initializeAuthSession(currentUser.getLastLogin());
		}
	}
	
	function postHandler( event, rc, prc, action, eventArguments ){
		
	}
	
	// function onMissingAction( event, rc, prc, missingAction, eventArguments ){
	// }
	
	// function onError( event, rc, prc, faultAction, exception, eventArguments ){
	// }

	public function fourOhFour(event,rc,prc){
		log.warn( "404", getHTTPRequestData() );
		header statusCode=404 statusText="Not Found";
		event.setView('error/404');
		
	}

	public void function addToAssetBag(required struct prc, required string assetPath) {
		arrayAppend(PRC.assetBag, assetPath);
		return;
	}

	private any function prepareAssetBag(event, rc, prc) {
		
		PRC.assetBag = [];
		var handler = event.getCurrentHandler();
		var action = event.getCurrentAction();

		// If a css file exists for this controller, include it
		// Naming convention is: {controller}.css
		var cssPathCheck = getSetting("cssPagePath") & "#handler#.css";
		if( fileExists( expandPath(cssPathCheck)) ){ arrayAppend(PRC.assetBag, cssPathCheck); }

		// If a css file exists for this action, include it
		// Naming convention is: view.{controller}.{action}.css
		var cssPathCheck = getSetting("cssPagePath") & "view-#handler#-#action#.css";
		if( fileExists( expandPath(cssPathCheck)) ){ arrayAppend(PRC.assetBag, cssPathCheck); }

		// If a js file exists for this controller, include it 
		// Naming convention is: {controller}.js
		var jsPathCheck = getSetting("jsPagePath") & "#handler#.js";
		if( fileExists( expandPath(jsPathCheck) ) ){ arrayAppend(PRC.assetBag, jsPathCheck); }

		// If a js file exists for this action, include it 
		// Naming convention is: view.{controller}.{action}.js
		var jsPathCheck = getSetting("jsPagePath") & "view.#handler#.#action#.js";
		if( fileExists( expandPath(jsPathCheck) ) ){ arrayAppend(PRC.assetBag, jsPathCheck); }

		return;
	}
		
	/************************************** COLDBOX IMPLICIT ACTIONS *********************************************/

	function onAppInit(event,rc,prc){

	}

	function onRequestStart(event,rc,prc){

	}

	function onRequestEnd(event,rc,prc){

	}

	function onSessionStart(event,rc,prc){

	}

	function onSessionEnd(event,rc,prc){
		var sessionScope = event.getValue("sessionReference");
		var applicationScope = event.getValue("applicationReference");
	}

	function onException(event,rc,prc){
		//Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		//Place exception handler below:

	}

	function onMissingTemplate(event,rc,prc){
		//Grab missingTemplate From request collection, placed by ColdBox
		var missingTemplate = event.getValue("missingTemplate");

	}

	
}
