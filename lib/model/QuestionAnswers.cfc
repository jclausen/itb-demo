/**
 *
 * @name Question Answers Model
 * @package Suretix.Model
 * @description This is the Question Answers Model
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component persistent="true" table="suretix_question_answers" extends="BaseModel"{

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="Label" column="label" ormtype="string";
	property name="Value" column="value" ormtype="string";
	property name="SortOrder" column="sort" ormtype="integer";
	//Relationships
	property name="Question" cfc="Questions" fieldtype="many-to-one" fkcolumn="question_id";
	
	// Validation
	this.constraints = {
		"Label":{required:true},
		"Value":{required:true},
		"SortOrder":{required:true,type:"numeric"}
	};
	
	// Constructor
	function init(){
		super.init( useQueryCaching="false" );
		return this;
	}
}

