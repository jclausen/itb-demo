component output="false" displayname="Unauthorized Event for invalid API requests"  {

	any function index( event, rc, prc ){
		event.renderData( 
			type="JSON", 
			data=structKeyExists(rc,'data') && !structIsEmpty(rc.data)?rc.data:{'message':'Not Authorized'}, 
			statusCode=401, 
			statusMessage=structKeyExists(rc,'statusMessage')?rc.statusMessage:"Your permissions do not allow this operation"
		);
	}

}