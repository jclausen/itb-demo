/**
 *
 * @name Billing Terms Model
 * @package ITIAdvertising.Model
 * @description This is the Billing Terms Model
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 *
 *
 **/
component persistent="true" entityname="SystemMigrations" table="system_migrations" output="false" extends="BaseModel" indexable=false {
	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="created"  ormtype="timestamp" sqltype="timestamp";
	property name="createdBy" fieldtype="many-to-one" cfc="User" fkcolumn="creation_user_id";
	
	property name="completed"  ormtype="timestamp" sqltype="timestamp";
	property name="task" ormtype="string";
	property name="model" ormtype="string";
	property name="description" ormtype="string" length=750;
	property name="audit" ormtype="string" sqltype="text";


}