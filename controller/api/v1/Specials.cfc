/**
 *
 * @name Registrations API Controller
 * @package Suretix.API.v1
 * @description This is the Registrations API Controller
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseAPIController"{
	property name="AccessRoles" default="Administrator,Editor";
	property name="ReportService" inject="model:ReportService";

	function activity_counts(event,rc,prc){
		rc.statusCode = STATUS.SUCCESS;
		rc.data['activity_counts'] = ReportService.getActivityCounts();
	}

	function product_activity(event,rc,prc){
		rc.statusCode = STATUS.SUCCESS;
		rc.data['product_activity'] = ReportService.getProductsComparison();
	}
	
	
}
