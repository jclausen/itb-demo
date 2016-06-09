/**
 *
 * @name Comments Model
 * @package Suretix.Model
 * @description This is the the Generic Comments Model
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 *
 **/
component persistent="true" entityname="Comments" table="suretix_comments" output="false" extends="BaseModel" {
	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";

	property name="modelName" column="entity_name" ormtype="string" required=true notnull=true;
	property name="modelId" column="entity_id" ormtype="integer" required=true notnull=true;
	property name="content" column="content" ormtype="string" length=1500;
	property name="created" column="created"  ormtype="timestamp";
	property name="updated" column="updated"  ormtype="timestamp";
	property name="User" fieldtype="many-to-one" cfc="User" fkcolumn="user_id" sqltype="integer" required=true notnull=true;
	property name="versions" column="versions" ormtype="text" sqltype="text" default='[]';

	/**
	* @overload
	**/
	any function save(){
		if(len(this.getId())){
			var originalContent = this.getContentPresave();
			if(this.getContent() NEQ originalContent){
				//handle versioning
				var versions = this.getVersions();
				if(!isArray(versions)){
					versions = deserializeJSON(versions);
				}
				arrayPrepend(versions,{"content":originalContent,"archived":now()});
				if(arrayLen(versions) == 6){
					arrayDeleteAt(versions,6);
				}
				this.setVersions(versions);
			}
			this.setUpdated(now());
		}
		else {
			this.setVersions([]);
			this.setCreated(now());
			if(isNull(this.getUser())){
				this.setUser(ModelUser.findByUsername(getAuthUser()));
			}
		}
		if(isArray(this.getVersions())){
			this.setVersions(serializeJSON(this.getVersions()));
		}

		return super.save(argumentCollection=arguments);
	}

	public function rollback(numeric position = 1,string datetime){
		var versions = deserializeJSON(this.getVersions());
		if(structKeyExists(arguments,'datetime')){
			for(var version in versions){
				if(version['archived'] == arguments.datetime){
					this.setContent(version['content']);
					this.save();
					break;
				}
			}
		} else {
			if(!isNull(versions[arguments.position]['content'])){			
				this.setContent(versions[arguments.position]['content']);
				this.save()	
			}
		}
		return this;
	}

	public function getContentPresave(){
		var q = new query();
		var presave = q.execute(sql="SELECT content from suretix_comments where id = #this.getId()# LIMIT 1").getResult();
		return presave.content;
	}

}