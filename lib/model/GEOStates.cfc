/**
 *
 * @name GEOStates Model
 * @package Suretix.Model
 * @description This is the States Model, which includes geographic data
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component persistent="true" entityname="GEOStates" table="geo_stateprov" output="false" extends="BaseModel"  indexable=false{
	property name="id" column="id" fieldtype="id" generator="native" setter="false";
	property name="abbr" column="abbr" ormtype="string" length=2;
	property name="name" column="name" ormtype="string";
	property name="country" column="country" ormtype="string";
	property name="wkt" column="wkt" ormtype="text" sqltype="longtext";
	property name="loc" column="loc" ormtype="binary" sqltype="geometry";

	function findUS(){
		return this.findAll(query="FROM GEOStates WHERE country = 'US' ORDER BY name ASC");
	}

	function findCanada(){
		return this.findAll(query="FROM GEOStates WHERE country = 'CA' ORDER BY name ASC")
	}
}