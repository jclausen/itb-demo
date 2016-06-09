/**
 *
 * @name User Roles Model
 * @package Suretix.Model
 * @description This is the User Roles Model
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component persistent="true" table="suretix_roles" extends="BaseModel"{

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="Name" column="name" ormtype="string";
	property name="Description" column="description" ormtype="string";
	property name="SortOrder" column="sort" ormtype="string" default="0";

	property name="Permissions" fieldtype="many-to-many" cfc="UserPermissions" linktable="suretix_roles_permissions" fkcolumn="agent_id" lazy=true indexable=false;
	property name="Users" fieldtype="one-to-many" cfc="User" fkcolumn="role_id" lazy=true indexable=false;
	
	
	// Constructor
	function init(){
		super.init( useQueryCaching="false" );
		return this;
	}
}

