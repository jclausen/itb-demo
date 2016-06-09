/**
 *
 * @name Distributor Model
 * @package Suretix.Model
 * @description This is the Distributor Model
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component persistent="true" table="suretix_distributors" extends="BaseModel"{

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="Name" column="company_name" ormtype="string";
	property name="Address1" column="address1" ormtype="string";
	property name="Address2" column="address2" ormtype="string";
	property name="City" column="city" ormtype="string";
	property name="State" column="state" ormtype="string" length="2";
	property name="Zip" column="postal_code" ormtype="string";
	property name="Country" column="country" ormtype="string";
	property name="Phone" column="phone" ormtype="string";
	property name="AltPhone" column="alternate_phone" ormtype="string";
	property name="Email" column="email" ormtype="string";
	property name="ContactName" column="contact_name" ormtype="string";

	property name="Inventory" fieldtype="one-to-many" cfc="ProductInventory" fkcolumn="distributor_id";
	
	
	// Validation
	this.constraints = {
		"Name":{required:true,validator: "UniqueValidator@cborm"},
		"Phone":{type:"telephone"},
		"AltPhone":{type:"telephone"},
		"Email":{required:false ,type:"email"}
	};
	
	// Constructor
	function init(){
		super.init( useQueryCaching="false" );
		return this;
	}
}

