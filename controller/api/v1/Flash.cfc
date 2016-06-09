/**
 *
 * @name Products API Controller
 * @package Suretix.API.v1
 * @description This is the Products API Controller
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseAPIController"{
	property name="Messagebox" inject="MessageBox@cbmessagebox";
	
	public function index(event,rc,prc){
		rc.data = {"success":false};
		if(event.valueExists('message')){
			switch(event.getValue('messageType','info')){
				case "warn":
					Messagebox.warn(rc.message);
					break;
				case "error":
					Messagebox.error(rc.message);
					break;
				default:
					Messagebox.info(rc.message);
			}
		}
		rc.data.success=true;
		rc.statusCode=STATUS.SUCCESS;
	}
}