/**
* I am a new handler
*/
component extends="BaseController" output=false{
	
	function index(event,rc,prc){

		event.setView("user/index");

	}	

	function profile(event,rc,prc){
		var mayEdit = false;
		var mayDelete = false;
	
		if(event.valueExists('id')){
			rc.user = 	getModel("User").get(rc.id);
			if(!isNull(rc.user)){

					var currentUser = getModel("User").get(session.currentUser.id);

					rc.mayEdit = currentUser.mayEdit(rc.user);
					rc.mayDelete = currentUser.mayDelete(rc.user);
					
					event.setView("user/profile");
				
				} else {
				
					this.fourOhFour(argumentCollection=arguments);
				
				}			
		} else {
			this.fourOhFour(argumentCollection=arguments);
		}

	}	
		

	
}
