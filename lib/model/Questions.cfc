/**
 *
 * @name Quesetions Model
 * @package Suretix.Model
 * @description This is the Questions Model
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component persistent="true" table="suretix_questions" extends="BaseModel"{

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="ModelId" column="model_id" ormtype="integer";
	property name="ModelName" column="model_name" ormtype="string";
	property name="Question" column="question_text" ormtype="string";
	property name="Active" column="active" ormtype="boolean" sqltype="bit";
	property name="SortOrder" column="sort_order" ormtype="integer";
	property name="TextOnly" column="text_only" ormtype="boolean" sqltype="bit";
	property name="DisplayRadio" column="radio_display" ormtype="boolean" sqltype="bit" default=false notnull=true;
	property name="MultiSelect" column="multiselect" ormtype="boolean" sqltype="bit" defult=false notnull=true;
	property name="LongText" column="longtext" ormtype="boolean" sqltype="bit" default=false notnull=true;
	
	property name="Answers" fieldtype="one-to-many" cfc="QuestionAnswers" fkcolumn="question_id" orderby="SortOrder";
	
	// Validation
	this.constraints = {
		// Example: age = { required=true, min="18", type="numeric" }
	};
	
	// Constructor
	function init(){
		super.init( useQueryCaching="false" );
		return this;
	}
}

