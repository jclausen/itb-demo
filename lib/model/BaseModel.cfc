/**
 *
 * @name Base Model
 * @package Suretix.Model
 * @description This is the Base Model for the Application
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component name="BaseModel" extends="cborm.models.ActiveEntity" output=false{
	//default logger
	property name="logbox" inject="logbox" persistent=false;
	property name="logger" inject="logbox:logger:{this}" persistent=false;
	property name="wirebox" inject="wirebox" persistent=false;
	property name="appSettings" inject="wirebox:properties" persistent=false;
	property name="messagebox" inject="messagebox@cbmessagebox" persistent=false;

	property name="ModelUser" inject="model:User" persistent=false;
	
	//default nulls
	property name="ModelQuestions" persistent=false;

	/**
	* Overloads to new and populate methods
	**/
	public function new(struct properties={}, boolean composeRelationships=true, nullEmptyInclude="", nullEmptyExclude="", boolean ignoreEmpty=false, include="", exclude=""){
		arguments.properties = verifyNumerics(arguments.properties);
		return super.new(argumentcollection=arguments);
	}

	public function populate(
		any target=this,
		required struct memento,
		string scope="",
		boolean trustedSetter=false,
		string include="",
		string exclude="",
		boolean ignoreEmpty=false,
		string nullEmptyInclude="",
		string nullEmptyExclude="",
		boolean composeRelationships=true
		)
	{
		verifyNumerics(arguments.memento);
		return super.populate(argumentcollection=arguments);
	}

	public function save(){
		var ModelUser = Wirebox.getInstance('User');
		if(!len(this.getId()) and hasOwnProperty('created')){
			this.setCreated(now());
			if(!isNull(ModelUser) and hasOwnProperty('CreatedBy')){
				this.setCreatedBy(ModelUser.findByEmail(getAuthUser()));
			}

		} else if(len(this.getId()) and hasOwnProperty('modified')){
			this.setModified(now());
			
			if(!isNull(ModelUser) and hasOwnProperty('ModifiedBy')){
				this.setModifiedBy(ModelUser.findByEmail(getAuthUser()));
			}
			
		}
			
		return super.save(argumentCollection=arguments);
		
		
	}

	/**
	* Verify that all numeric properties have the correct javatype before passing them on to Hibernate
	**/
	public function verifyNumerics(sProperties){
		var props = getMetadata(this).properties;
		for (var prop in props){
			if(structKeyExists(sProperties,prop.name) and structKeyExists(prop,'ormtype') and !structKeyExists(prop,"cfc")){
				switch(prop.ormtype){
					case "numeric":
					case "float":
					case "integer":
					case "short":
					case "long":
						try{
						//check for non numerics in numeric fields
						if(isSimpleValue(sProperties[prop.name]) and len(sProperties[prop.name]) and !isBoolean(sProperties[prop.name]) and !isNumeric(sProperties[prop.name])){
							sProperties[prop.name] = LSParseNumber(sProperties[prop.name]);
							sProperties[prop.name] = javacast(prop.ormtype,sProperties[prop.name]);
						}
						} catch(any e){
							
						}
						break;
					default:
						break;
				}
			}
		}
		return sProperties;
	}

	/**
	* Pseudo Accessor for Questions
	* 
	* @param boolean active 	Whether to restrict to active or inactive questions
	**/

	public function getQuestions(active){
		if(!isDefined('ModelQuestions')) return;

		var criteria = {"modelName":getMetaData(this).name};

		if(len(this.getId())) criteria["modelId"]=this.getId();
		if(!isNull(arguments.active)) criteria["Active"]=arguments.active;

		return ModelQuestions.findAllWhere(criteria=criteria,sortOrder="SortOrder ASC");
	}


	/**
	* Comments Functionality
	**/

	/**
	* Pseudo Accessor for Commments
	**/

	public function getComments(){
		if(!isDefined('ModelComments')) return;
		if(!len(this.getId())) return [];
		var q = ModelComments.newCriteria();
		q.add(whereThisEntity(q));
		q.order('created','desc');
		return q.list();
	}

	public function addComment(message){
		if(!isDefined('ModelComments')) return;

		var newComment = ModelComments.new(
			properties={
				"content":message,
				"modelName":getMetadata(this).name,
				"modelId":javacast('integer',this.getId()),
				"User":len(getAuthUser()) ? ModelUser.findByEmail( getAuthUser() ).getId() : 1
			});
		newComment.save(transactional=true);
		return newComment;
	}


	public function whereThisEntity(q){
		if(!isDefined('ModelComments') || isNull('ModelComments')) throw(message="This Model Is Not Setup For Commenting Features");
		
		return 
		[
			q.restrictions.isEq('modelName',getMetaData(this).name),
			q.restrictions.isEq('modelId',javacast('integer',this.getId())),
		]
	}

	/**
	 * Where facade for criterion builder query
	 * Note: handles equals conditions only at this time
	 * TODO: add dynamic handling
	 * @param struct sWhere - structure of conditions
	 * @param boolean default=false asQuery = whether to return the recordset as a CF query object. If blank, will return criterion builder object
	 *
	 **/

	public function where(struct sWhere,asQuery=false){
		var criterion = this.newCriteria();
		for(condition in arguments.sWhere){
  			criterion.add(criterion.restrictions.isEQ(condition,arguments.sWhere[condition]));
		}
		if(arguments.asQuery){
			return criterion.list(asQuery=arguments.asQuery);
		} else{
			return criterion;
		}
	}

	

	/**
	* Dynamic accessor function to set two properties to the same value
	* @param string from - the property name of the origin field
	* @param string to - the property name of the target field
	**/
	public function setPropertySame(from,to){
		var getter = "get"&from;
		var setter = "set"&to;
		if(structKeyExists(this,getter) and structKeyExists(this,setter)){
			this.getField = this[getter];
			this.setField=this[setter];
			this.setField(this.getField());
		}
	}

	public boolean function hasOwnProperty(required string propName){
		var props = getMetaData(this).properties;
		for(var prop in props){
			if(prop.name is arguments.propName){
				return true;
			}
		}	
		return false;
	}
	
	/**
	* Handle boolean casting from postgres boolean value
	**/
	public function boolean(value){
		if(isBoolean(value)){
			return javacast('boolean',value);
		} else {
			switch(value){
				case 't':
				case 'true':
				case 'yes':
				case 'y':
				case 1:
					return true;
					break;
				default:
					return false;
			}
		}
	}

	/**
	 * Returns the current instance of a single result as a query
	 * @param boolean dirty - whether or not to allow for an unsave record to be returned as a query 
	 **/
	public function getRecordAsQuery(dirty=false){
			var name ="get"&this.getKey();
			var s = structNew();
			var qget = '';
			var qresult = '';
			this.dynName = this[name];
			if(this.dynName() != ''){
			s[this.getKey()]=this.dynName();
			return this.list(criteria=s);
			} else {
			qget = new query();
			qresult = qget.execute(sql='
			SELECT * from '&this.getTableName()&'
			WHERE 1=0
			').getResult();

			if(arguments.dirty){
				columns=this.getPropertyNames();
				queryAddRow(qResult);
				for(column in columns){
					colname="get"&column;
					this.getField=this[colname];
					try{
						querySetCell(qResult,column,(isNumeric(this.getField())?javacast("string",this.getField()):javacast("string",this.getField())));
					} catch(Any exception){
						//TODO: Just lettting exceptions go for now
					}
				}
			}
			return qresult;
			}
	}

	/**
	 * Facade for getRecordAsQuery()
	 **/

	 public function asQuery(){
	 	 return this.getRecordAsQuery();
	 }

	 /**
	 * returns an array of properties that make up the identifier
	 * @output false
	 **/
	  public array function getIdentifierColumnNames()
	  {
	    return ORMGetSessionFactory().getClassMetadata( getClassName() ).getIdentifierColumnNames() ;
	  }
	  
	  /**
	  * returns the name of the Entity
	  * @output false
	  */
	  public string function getEntityName()
	  {
	    return ORMGetSessionFactory().getClassMetadata( getClassName() ).getEntityName();
	  }
  

	 /**
	 * Returns an array of all ORM properties in the entity
	 **/
	 public function getOrmPropertyNames(){
	 	var metadata = getMetadata(this);
	 	var identifiers = getIdentifierColumnNames();
	 	if (StructKeyExists(metadata,"datasource")){
        	return ORMGetSessionFactory(metadata.datasource).getAllClassMetadata()[ getClassName() ].getPropertyNames();
	    } else {
	    	return ORMGetSessionFactory().getAllClassMetadata()[ getClassName() ].getPropertyNames();
	    }
	 
	 }

	 public string function getClassName() {

	    return ListLast( GetMetaData( this ).fullname, "." );

	 }

	/**
	 * Returns the current entity (dirty or otherwise) as a structure
	 *
	 * @param boolean renamekey 	Whether or not to rename the "id" column of the structure to reflect the entity name (important for auto-population of new models)
	 * @param boolean lower 		Whether or not to lower case all property names
	 **/
	public function getRecordAsStruct(renamekey=false,lower=false){
		var s = structNew();
		var properties = [].append(getOrmPropertyNames(),true);
		properties.append(getIdentifierColumnNames(),true);
		
		for(fieldName in properties){

			var accessor="get"&fieldName;
			var getField=this[accessor];
			var field = fieldName;
			if(lower){
				field = lcase(fieldName);
			}
    		var fieldValue = getField();
    		var nullField = isNull(fieldValue);
    		
    		if(!nullField && isSimpleValue(fieldValue)){
    			s[field]  = getField();
	    		
	    		//auto-unpack any json fields
	    		if(isSimpleValue(s[field]) and (left(trim(s[field]),1) == '[' || left(trim(s[field]),1) == '{') and isJSON(s[field])) s[field] = deSerializeJSON(s[field]);

    		} else if(!nullField && isObject(fieldValue)) {
    			s[field] = fieldValue.getId();
    		} else {
    			s[field] = '';
    		}
		}

		if(arguments.renamekey AND structKeyExists(s,"id")){
			s[lcase(getMetadata(this).name) & "_id"] = s.id;
			structDelete(s,"id");
		}

		return s;
	}

	public function asStruct(renamekey=false,lower=true){
		return this.getRecordAsStruct(argumentCollection=arguments);
	}

	/**
	* Returns the query columns with correct casing;
	**/
	public function queryColumnList(q){
		var md = getMetdata(q);
		var columnList = '';
		for(column in md){
			listAppend(columnList,column['name']);
		}
		return columnList;
	}

	/**
	* Import Functionality
	**/

	public function entityFromImportMap(iRow,import_map,save=false){
		var sEntity = entityStructFromImportMap(iRow,import_map);
		var entity = this.new(properties=sEntity,ignoreEmpty=true);
		if(save){
			entity.save();
		}
		return entity;
	}


	/**
	* Create an entiy struct from an import map (e.g. column => importKey)
	**/
	public function entityStructFromImportMap(iRow,import_map){
		var sEntity = structNew();
		for(var key in import_map){
			//single field
			if(!isArray(import_map[key]) and structKeyExists(iRow,import_map[key])){
				sEntity[key]=iRow[import_map[key]];
			} else if(isArray(import_map[key])) {
				//multiple fields
				var concat = '';
				for(var ikey in import_map[key]){
					if(structKeyExists(iRow,ikey)){
						concat = listAppend(concat,iRow[ikey],' ');	
					} else {
						concat = listAppend(concat,ikey,' ');
					}
				}
				sEntity[key]=concat;
			} else {
				//default value
				sEntity[key]=import_map[key];
			}
			//handle any numeric values
			if(isNumeric(replace(sEntity[key],',','',"ALL")) and !findNoCase('.',sEntity[key])){
				sEntity[key]=javacast('int',LSParseNumber(sEntity[key]));
			} else if (isNumeric(replace(sEntity[key],',','',"ALL"))){
				sEntity[key]=javacast('float',LSParseNumber(sEntity[key]));
			} else{
				//handle uppercase strings and title case them
				if(len(sEntity[key]) and len(sEntity[key]) GE 4 and compare(sEntity[key],UCase(sEntity[key])) EQ 0){
					if(isValid("email",sEntity[key])){
						sEntity[key]=lcase(sEntity[key]);
					} else {
						sEntity[key]=REReplace( sEntity[key], "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" );
					}
					
				}
			}
		}
		return sEntity;
	}
}