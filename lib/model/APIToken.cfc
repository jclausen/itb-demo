component persistent="true" table="suretix_api_tokens" extends="BaseModel"{
	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="Token" column="token" ormtype="string";
	property name="Description" column="description" ormtype="string";
	property name="User" fieldtype="many-to-one" cfc="User" fkcolumn="user_id";

	property name="created"  ormtype="timestamp" sqltype="timestamp";
}