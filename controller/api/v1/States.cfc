/**
 *
 * @name States API Controller
 * @package Suretix.API.v1
 * @description This is the States API Controller
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseAPIController"{
	property name="ModelStates" inject="model:GEOStates";
	
	this.API_BASE_URL = "/api/v1/states";
		
	//(GET) /api/v1/states
	function index(event,rc,prc){
		runEvent('api.v1.States.list');
	}	

	//(GET) /api/v1/states/:abbr
	//TODO: implement later for geolocation
	function get(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_IMPLEMENTED;
	}	

	//(GET) /api/v1/states (search)
	function list(event,rc,prc){
		this.marshallStates(argumentCollection=arguments);
	}		

	private function marshallStates(event,rc,prc){
		rc.data['states']=[];
		if(!structKeyExists(rc,'country')) rc.country = 'US';
		var states = ModelStates.list(criteria={"country":rc.country},asQuery=false);
		
		for(var state in states){
			sState = {};
			sState['abbr']=state.getAbbr();
			sState['name']=state.getName();
			if(structKeyExists(rc,'geo') and rc.geo){
				sState['wkt']=state.getWkt();
			}
			arrayAppend(rc.data.states,sState);
		}

		rc.statusCode = STATUS.SUCCESS;

	}	


	
}
