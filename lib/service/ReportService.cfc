/**
 *
 * @name Reports Service
 * @package Suretix.Service
 * @description This is the Claims Service
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseService" singleton{

	public function getActivityCounts(){

		var q = new query(useQueryCaching=true);
		q.addParam(name='startdate', value=dateAdd('d',-30,now()),cfsqltype="cf_sql_timestamp");

		var sql = "
		SELECT 
		(SELECT count(*) from suretix_registration WHERE created >= :startdate) as registrationsCount,
		(SELECT count(*) from suretix_claims WHERE created >= :startdate) as claimsSubmitted,
		(SELECT count(*) from suretix_claims WHERE created >= :startdate and claim_status = 1) as claimsPending,
		(SELECT count(*) from suretix_claims WHERE created >= :startdate and claim_status = 2) as claimsProcessing,
		(SELECT count(*) from suretix_claims WHERE created >= :startdate and claim_status = 3) as claimsApproved,
		(SELECT count(*) from suretix_claims WHERE created >= :startdate and claim_status = 4) as claimsResolved"

		var qResult = q.execute(sql=sql).getResult();

		return [
                {"label": 'Registrations', "value": qResult.registrationsCount },
                {"label": 'Claims Submitted', "value": qResult.claimsSubmitted },
                {"label": 'Claims Pending', "value": qResult.claimsPending },
                {"label": 'Claims Processing', "value": qResult.claimsProcessing },
                {"label": 'Claims Approved', "value": qResult.claimsApproved },
                {"label": 'Claims Resolved', "value": qResult.claimsResolved }
            ];
			
	} 


	public function getProductsComparison(){
		var q = new query(useQueryCaching=true);
		q.addParam(name='startdate',value=dateAdd('d',-365,now()),cfsqltype="cf_sql_timestamp")

		var sql = "SELECT DISTINCT products.model_number as modelNumber, 
		(
			SELECT count(*) from suretix_claims claims 
			INNER JOIN suretix_inventory inv1 on inv1.id = claims.inventory_id 
			WHERE inv1.product_id = products.id and claims.created > :startdate 
		) as claimsCount, 
		(
			SELECT count(*) from suretix_registration registrations 
			INNER JOIN suretix_inventory inv2 on inv2.id = registrations.inventory_id 
			WHERE inv2.product_id = products.id and registrations.created > :startdate
		) as registrationsCount
		FROM suretix_products products
		ORDER BY products.model_number ASC";
		
		var qResults = q.execute(sql=sql).getResult();

		var results = [];

		for(var row in qResults) {
			arrayAppend(results,{"product":row.modelNumber,"registrations":row.registrationsCount,"claims":row.claimsCount});
		}

		return results;
	}
	


}