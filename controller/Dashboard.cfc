/**
* I am a new handler
*/
component extends="BaseController" output=false{
		property name="ClaimService" inject="model:ClaimService";
		property name="RegService" inject="model:RegistrationService";

		public function preHandler( event, rc, prc, action, eventArguments ){
			super.preHandler(argumentCollection=arguments);
			addToAssetBag(prc,'/includes/css/lib/morris.css');
		}

		public function index(event,rc,prc){
			event.setView('dashboard/index');
		}

		/* JSON Return Methods */
		public function history(event,rc,prc){
			event.noLayout();
			var history = {
				"claims":getModel("ClaimService").assembleHistory(rc),
				"registrations":getModel("RegistrationService").assembleHistory(rc),
			}
			event.display();
		}

}
