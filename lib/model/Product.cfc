/**
 *
 * @name Products Model
 * @package Suretix.Model
 * @description This is the Products Model
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component persistent="true" table="suretix_products" extends="BaseModel"{

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="ModelNumber" column="model_number" notnull=true unique=true ormtype="string";
	property name="SKU" column="sku" ormtype="string" notnull=false unique=true;
	property name="Name" column="name" ormtype="string";
	property name="Description" column="description" ormtype="string";
	property name="Active" column="active_status" ormtype="boolean" sqltype="bit" default=true;
	
	property name="created"  ormtype="timestamp" sqltype="timestamp";
	property name="modified"  ormtype="timestamp" sqltype="timestamp";
	property name="createdBy" fieldtype="many-to-one" cfc="User" fkcolumn="creation_user_id";
	property name="modifiedBy" fieldtype="many-to-one" cfc="User" fkcolumn="modification_user_id";
	
	// Relationships
	property name="Category" fieldtype="many-to-one" cfc="ProductCategory" fkcolumn="category_id";
	property name="Inventory" fieldtype="one-to-many" cfc="ProductInventory" fkcolumn="product_id";

	
	// Validation
	this.constraints = {
		"ModelNumber":{required: true, validator: "UniqueValidator@cborm"},
		"SKU":{required: false, validator: "UniqueValidator@cborm"},
		"Category":{required: true}
	};
	
	// Constructor
	function init(){
		super.init( useQueryCaching="false" );
		return this;
	}
}

