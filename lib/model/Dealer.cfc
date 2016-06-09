/**
 *
 * @name Dealer Model
 * @package Suretix.Model
 * @description This is the Dealer Model
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component persistent="true" table="suretix_dealers" extends="BaseModel"{

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
	
	property name="isInstaller" column="offers_installation" ormtype="boolean" notnull=true sqltype="bit" default=true;
	property name="isServicer" column="offers_repair" ormtype="boolean" notnull=true sqltype="bit" default=true;

	property name="Customers" fieldtype="one-to-many" cfc="EndUser" linktable="suretix_inventory" fkcolumn="dealer_id" inversejoincolumn="enduser_id" orderby="lastName asc,firstName asc";
	property name="Installations" singularname="Installation" fieldtype="one-to-many" cfc="ProductInventory" fkcolumn="installer_id";
	property name="Claims" singularname="Claim" fieldtype="one-to-many" cfc="Claim" fkcolumn="servicer_id";
	
	
	// Validation
	this.constraints = {
		// "Phone":{required:false, type:"telephone"},
		// "AltPhone":{required:false, type:"telephone"},
		//"Email":{required: false, type:"email",validator: "UniqueValidator@cborm"}
		"Email":{required: false, type:"email"}
	};
	
	// Constructor
	function init(){
		super.init( useQueryCaching="false" );
		return this;
	}

	function getInstallationCustomers(){
		var q = wirebox.getInstance("EndUser").newCriteria();
		q.createAlias('Items','Items');
		q.add(q.restrictions.isEq('Items.Installer',this));
		return q.list();
	}
}

