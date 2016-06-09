/**
 *
 * @name Product Inventory Model
 * @package Suretix.Model
 * @description This is the Product Inventory Model
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component persistent="true" table="suretix_inventory" extends="BaseModel"{

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="serialNumber" column="serial_number" unique=true notnull=true ormtype="string";
	property name="InstallDate" column="install_date"  ormtype="date" sqltype="date";
	property name="InstallType" column="install_type" ormtype="string";//Residential,Multi-Family Residential, Commercial
	property name="OrderNumber" ormtype="string";
	property name="created" ormtype="timestamp" sqltype="timestamp";
	property name="modified" ormtype="timestamp" sqltype="timestamp";
	
	//Relationships
	property name="createdBy" fieldtype="many-to-one" cfc="User" fkcolumn="creation_user_id";
	property name="modifiedBy" fieldtype="many-to-one" cfc="User" fkcolumn="modification_user_id";

	property name="Product" fieldtype="many-to-one" cfc="Product" fkcolumn="product_id" lazy=false fetch="join";
	property name="EndUser" fieldtype="many-to-one" cfc="EndUser" fkcolumn="enduser_id";
	property name="Dealer" fieldtype="many-to-one" cfc="Dealer" fkcolumn="dealer_id";
	property name="Installer" fieldtype="many-to-one" cfc="Dealer" fkcolumn="installer_id";
	property name="Claims" fieldtype="one-to-many" cfc="Claim" fkcolumn="inventory_id";
	property name="Distributor" fieldtype="many-to-one" cfc="Distributor" fkcolumn="distributor_id";

	
	// Validation
	this.constraints = {
		"serialNumber":{required: true, validator: "UniqueValidator@cborm"},
		"Product":{required:true},
		"Distributor":{required:true}
	};
	
	// Constructor
	function init(){
		super.init( useQueryCaching="false" );
		return this;
	}


	/**
	* Pseudo accessor
	**/
	function getRegistration(){
		var qReg = Wirebox.getInstance("Registration").newCriteria();
		qReg.add(qReg.restrictions.isEq('Item',this));
		var registrations = qReg.list();
		if(arrayLen(registrations)){
			return registrations[1];
		} else {
			return javacast('null',0);
		}
	}
}

