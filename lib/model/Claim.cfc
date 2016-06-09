/**
 *
 * @name Claims Model
 * @package Suretix.Model
 * @description This is the Claims
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component persistent="true" table="suretix_claims" extends="BaseModel"{
	//Injected Properties
	property name="ModelQuestions" inject="model:Questions" persistent=false;
	property name="ModelComments" inject="model:Comments" persistent=false;

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="ClaimAction" column="claim_action" ormtype="string" default="Repair"; //see claim actions below
	property name="Status" column="claim_status" ormtype="integer" default=1; //1 - submitted, 2 - processing, 3 - approved, 4 - resolved
	property name="FailureDate" column="date_of_failure" ormtype="date";
	property name="NotificationEmail" column="notification_email" ormtype="string";
	
	property name="created"  ormtype="timestamp" sqltype="timestamp";
	property name="modified"  ormtype="timestamp" sqltype="timestamp";
	
	property name="Answers" column="question_answers" ormtype="string" sqltype="text";
	
	//Relationships
	property name="Item" fieldtype="many-to-one" cfc="ProductInventory" fkcolumn="inventory_id";
	property name="Servicer" fieldtype="many-to-one" cfc="Dealer" fkcolumn="servicer_id";
	property name="EndUser" fieldtype="many-to-one" cfc="EndUser" fkcolumn="enduser_id";
	
	property name="createdBy" fieldtype="many-to-one" cfc="User" fkcolumn="creation_user_id";
	property name="modifiedBy" fieldtype="many-to-one" cfc="User" fkcolumn="modification_user_id";

	
	this.claimActions = [
		'Repair',
		'Replace'
	];
	
	// Validation
	this.constraints = {
		"FailureDate":{require:true,type:'date'},
		"NotificationEmail":{required: true, type:"email"}
	};
	
	// Constructor
	function init(){
		super.init( useQueryCaching="false" );
		return this;
	}
	
}

