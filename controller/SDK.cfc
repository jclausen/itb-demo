/**
 *
 * @name SDK Controller
 * @package Suretix.Controller
 * @description This is the SDK controller
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component name="SDK" extends="BaseController" output=false{
	
	function preHandler( event, rc, prc, action, eventArguments ){
		super.preHandler(argumentCollection=arguments);
		event.setDefaultLayout('SDK');
		//set our access control allow origin header for cross-domain requests
		header name="Access-Control-Allow-Origin" value="*";
	}
	
	public function registration(event,rc,prc){
		event.setView('sdk/registration.html');
	}

	public function claim(event,rc,prc){
		event.setView('sdk/claim.html');
	}

}