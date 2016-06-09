/**
* A cool UserPermissions entity
*/
component persistent="true" table="suretix_permissions" extends="BaseModel"{

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="Entity" column="entity" ormtype="string";
	property name="Action" column="action" ormtype="string";
	
	// Constructor
	function init(){
		super.init( useQueryCaching="false" );
		return this;
	}
}

