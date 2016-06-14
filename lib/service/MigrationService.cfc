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

	

}