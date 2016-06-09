/**
 *
 * @name End User Model
 * @package Suretix.Model
 * @description This is the End User Model
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component persistent="true" table="suretix_end_users" extends="BaseModel"{

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="FirstName" column="first_name" ormtype="string";
	property name="LastName" column="last_name" ormtype="string";
	property name="Address1" column="address1" ormtype="string";
	property name="Address2" column="address2" ormtype="string";
	property name="City" column="city" ormtype="string";
	property name="State" column="state" ormtype="string" length="2";
	property name="Zip" column="postal_code" ormtype="string";
	property name="Country" column="country" ormtype="string";
	property name="Phone" column="phone" ormtype="string";
	property name="AltPhone" column="alternate_phone" ormtype="string";
	property name="Email" column="email" ormtype="string";

	property name="Items" fieldtype="one-to-many" cfc="ProductInventory" fkcolumn="enduser_id" inverse=true lazy=true;

	property name="ModelDealer" inject="model:Dealer" persistent=false;
	
	
	// Validation
	this.constraints = {
		// "Phone":{required: false, type:"telephone"},
		// "AltPhone":{required: false, type:"telephone"},
		//"Email":{required: false, type:"email", validator: "UniqueValidator@cborm"}
		"Email":{required: false, type:"email"}
	};
	
	// Constructor
	function init(){
		super.init( useQueryCaching="false" );
		return this;
	}
}

