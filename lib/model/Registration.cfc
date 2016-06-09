/**
 *
 * @name Registration Model
 * @package Suretix.Model
 * @description This is the Registration Model
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component name="Registration" persistent="true" table="suretix_registration" extends="BaseModel"{
	//Injected Properties
	property name="ModelQuestions" inject="model:Questions" persistent=false;
	property name="ModelComments" inject="model:Comments" persistent=false;

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="Answers" column="question_answers" ormtype="string" sqltype="text";
	property name="created"  ormtype="timestamp" sqltype="timestamp";
	property name="modified"  ormtype="timestamp" sqltype="timestamp";
	property name="OrderNumber" ormtype="string";
	
	//Relationships
	property name="createdBy" fieldtype="many-to-one" cfc="User" fkcolumn="creation_user_id";
	property name="modifiedBy" fieldtype="many-to-one" cfc="User" fkcolumn="modification_user_id";
	property name="Item" fieldtype="one-to-one" cfc="ProductInventory" fkcolumn="inventory_id";

	
	// Constructor
	function init(){
		super.init( useQueryCaching="false" );
		return this;
	}

}

