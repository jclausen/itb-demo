component displayname="Migration Service" hint="I handle automated schema migrations" output="false"  {
	property name="Wirebox" inject="wirebox";
	property name="Logger" inject="logbox:logger:{this}";
	property name="ModelMigration" inject="model:SystemMigrations";
	property name="AppSettings" inject="wirebox:properties";
	
	function migrate(){
		var tasks = getIncompleteTasks();
		for(var task in tasks){
			var migrated = execute(task);
			if(!isNull(migrated)){
				Logger.info("Migrations completed for task: #task#");	
			} else {
				throw("Failed to save migration record for task #task#","System Migration Exception")
			}
		}
		return true;
	}

	private function execute(task){

		if(!structKeyExists(this,task)) return false;

		var executeTask = this[task];
		var migration = executeTask();
		migration['task']=task;
		migration['completed']=now();
		if(!isSimpleValue(migration['audit'])) migration['audit'] = serializeJSON(migration['audit']);

		var migrated = ModelMigration.populate(memento=migration,ignoreEmpty=true);
		migrated.save();
		return migrated;

	}

	private function getIncompleteTasks(){
		var tasks = getTasks();
		var incompletes = [];
		for(var task in tasks){
			if(isNull(ModelMigration.findByTask(task))){
				arrayAppend(incompletes,task);
			}
		}
		return incompletes;
	}

	private function getTasks(){
		var tasks = [];
		for(var fn in getMetadata(this).functions){
			if(left(fn.name,4) is 'task'){
				arrayAppend(tasks,fn.name);
			}
		}
		return tasks;
	}

	/**
	* ////////////////////
	*  Migration Tasks Go Below Here
	*  Function names should be prefixed with "task"
	* ///////////////////
	**/

	function taskRemoveInstallersAndServicersTables(){
		var migration = {
			"model":"Dealer",
			"description":"Remove Unused Servicers and Installers Tables",
			"audit":[]
		}

		var q = new query();
		var sql = "DROP TABLE IF EXISTS `itb_warranty`.`suretix_installers`";
		var idelete = q.execute(sql=sql).getResult();

		arrayAppend(migration.audit,{"installers":idelete});

		q = new query();
		var sql = "DROP TABLE IF EXISTS `itb_warranty`.`suretix_servicers`";
		var sdelete = q.execute(sql=sql).getResult();

		arrayAppend(migration.audit,{"servicers":sdelete});

		return migration;

	}

	function taskResetDataFromTestingToProductionEnvironment(){
		var migration = {
			"model":"Claim",
			"description":"Restore the environment to production mode by deleting all test data",
			"audit":[]
		};
		//remove claims first
		var DeletedClaims = Wirebox.getInstance("Claim").deleteAll(flush=true);
		arrayAppend(migration.audit,{"DeletedClaims":DeletedClaims});
		//delete registrations
		var DeletedRegistrations = Wirebox.getInstance("Registration").deleteAll(flush=true);
		arrayAppend(migration.audit,{"DeletedRegistrations":DeletedClaims});
		//delete all product inventory
		var DeletedInventory = Wirebox.getInstance("ProductInventory").deleteAll(flush=true);
		arrayAppend(migration.audit,{"DeletedInventory":DeletedInventory});

		//delete all dealers
		var DeletedDealers = Wirebox.getInstance("Dealer").deleteAll(flush=true);
		arrayAppend(migration.audit,{"DeletedDealers":DeletedDealers});

		//delete all customers
		var DeletedEndusers = Wirebox.getInstance("EndUser").deleteAll(flush=true);
		arrayAppend(migration.audit,{"DeletedEndUsers":DeletedEndusers});

		//set new indexes on claims and registrations
		var qsequence = new query();
		var sql = "ALTER TABLE suretix_registration AUTO_INCREMENT = 1500";
		qsequence.execute(sql=sql);

		var qsequence = new query();
		var sql = "ALTER TABLE suretix_claims AUTO_INCREMENT = 100";
		qsequence.execute(sql=sql);

		return migration;


	}

	function taskCreateDefaultUsers(){
		
	}

	
// 	function taskConvertPossiblesToRunnable(){
// 		var migration = {
// 			"model":"AdvertisementDates",
// 			"description":"Move all possible dates to runnable type",
// 			"audit":""
// 		};
// 		var q= new query();
// var sql ="
// UPDATE adv_advertisement_dates 
// SET column_count=q2.column_count,
// width=q2.width,
// height=q2.height,
// cost=q2.cost,
// copay_amount=q2.copay_amount,
// copay_percent=q2.copay_percent,
// net_cost=q2.net_cost
// FROM (
// 	SELECT campaign_id,column_count,width,height,cost,copay_amount,copay_percent,net_cost 
// 	FROM adv_advertisement_dates d2 
// 	) as q2
// WHERE possible = 1
// AND q2.campaign_id = adv_advertisement_dates.campaign_id
// ";

// 		var q.execute(sql=sql);
		
// 		return migration;
// 	}

	

}