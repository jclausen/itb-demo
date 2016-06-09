/**
* I am a new handler
*/
component extends="BaseController" output=false{
		
	function index(event,rc,prc){
		event.setView("Registration/index");
	}	

	function detail(event,rc,prc){
		if(event.valueExists('id')){
			rc.registration = 	getModel("Registration").get(rc.id);
		}
		event.setView("Registration/detail");
	}	

	function export(event,rc,prc){
		if(event.getHttpMethod() == "POST"){
			if(!structKeyExists(rc,"startDate") || !len(rc.startDate)) {
				MessageBox.error('You did not specify a start date for your export.  Please correct the form and try again.');
			} else {
				if(structKeyExists(rc,'endDate') && !len(rc.endDate)) structDelete(rc,'endDate');
				var serviceResp = getModel("RegistrationService").processRegistrationsExport(startDate=rc.startDate,endDate=event.getValue('endDate',now()));
				if(!isNull(serviceResp.result) && fileExists(serviceResp.result)){
					cfheader(name='Content-Disposition',value='attachment; filename="Registrations-#dateFormat(rc.startDate,'mm-dd-yyyy')#.#listLast(serviceResp.result,'.')#"');
					cfheader(name="Cache-control",value="max-age=10");
					cfcontent(reset="true",file=serviceResp.result,type="application/vnd.ms-excel",deletefile=true);
					abort;
				} else {
					MessageBox.error(serviceResp.friendlyMessage);
				}	
			}
		}
		event.setView('Registration/export');
	}
	
}
