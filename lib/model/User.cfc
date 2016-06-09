/**
 *
 * @name User Model
 * @package Suretix.Model
 * @description This is the User Model
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component persistent="true" table="suretix_user" extends="BaseModel"{
	// Null out self from base so we don't run in to stack overflow errors

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="password" ormtype="string" notnull=true;
	property name="Email" column="email" ormtype="string" notnull=true;
	property name="FirstName" column="first_name" ormtype="string";
	property name="LastName" column="last_name" ormtype="string";
	property name="Company" column="company" ormtype="string";
	property name="Title" column="title" ormtype="string";
	property name="Phone" column="phone" ormtype="string";
	property name="Skype" column="skype_id" ormtype="string";
	property name="loggedIn" ormtype="boolean" sqltype="bit" default=false notnull=true;
	property name="lastLogin"  ormtype="timestamp" sqltype="timestamp";
	property name="resetToken" column="reset_token" ormtype="string";
	
	//Relationships
	property name="Role" fieldtype="many-to-one" fkcolumn="role_id" cfc="UserRoles" lazy="false" fetch="join";

	//null out self reference from the Base Model to prevent stack overflows
	property name="ModelUser" persistent=false;

	
	// Validation
	this.constraints = {
		"phone":{type="telephone"},
		"Email":{required: false, type:"email", validator: "UniqueValidator@cborm"},
		"password":{required=true}
	};
	
	// Constructor
	function init(){
		super.init( useQueryCaching="false" );
		return this;
	}

	public function getUserFromLogin(rc){
		var q = new query();
		q.addParam(name='email',value=rc.email,cfslqtype="cf_sql_varchar");
		q.addParam(name='password',value=rc.password,cfslqtype="cf_sql_varchar");
		var sql ='SELECT id from suretix_user WHERE email = :email and password = PASSWORD(:password)';
		var qUser = q.execute(sql=sql).getResult();
		if(qUser.recordCount){
			return this.get(qUser.id);
		}

		return javacast('null',0);
	}


	public function inRole(required roleName){

		if(isArray(arguments.roleName)){

			return javacast('boolean',arrayFindNoCase(arugments.rolename,this.getRole().getName()));
		
		} else {
			//if our role is set in our cflogin
			if(isUserInRole(roleName)) return true;

			return javacast('boolean',(arguments.rolename == this.getRole().getName()))
		}
	}

	public function hasPermission(required permissionName){
		if(this.inRole('Super Admin')) return true;
		var permission = {
			"Entity":listFirst(PermissionName,":"),
			"Action":listLast(PermissionName,":")
		}

		var q = this.newCriteria();
		
		q.withRole(q.INNER_JOIN);
		q.withPermissions(q.INNER_JOIN);
		q.add(q.restrictions.eq('Entity',permission.Entity));
		q.add(q.restrictions.eq('Action',permission.Action));
		return javacast('boolean',q.count());
	}

	//User editing of other users
	public function mayEdit(required User User){
		var mayEdit = false;


		//evaluate the permissions for editing
		if(this.getId() == arguments.User.getId()) mayEdit = true;
		 
		if(this.inRole("Administrator") && !arguments.User.inRole("Administrator")){
			mayEdit = true;
		}

		if(this.inRole('Super Administrator') && arguments.User.getId() != this.getId()){
			mayEdit = true;
		} 
		
		return mayEdit
	}

	//User deletion of other users
	public function mayDelete(required User User){
		var mayDelete = false;
		//evaluate the permissions for deletion (never delete the inital system admin account)
		if(this.inRole('Super Adminstrator') && arguments.User.getId() != this.getId() && arguments.User.getId() != 1){
			mayDelete = true;
		} 
		if(this.inRole("Administrator") && !arguments.User.inRole("Administrator")){
			mayDelete = true;
		} 

		return mayDelete;
		
	}

	public function initializeAuthSession(lastLogin=now(),tokenAuth=false){
		this.setLastLogin(arguments.lastLogin);
		this.setLoggedIn(true);
		this.save();
		session.currentUser = this.asStruct();
		session.currentUser['role'] = this.getRole().asStruct();
		session.tokenAuthentication = arguments.tokenAuth;
	}

	public function finalizeAuthSession(){
		this.setLoggedIn(javacast('short',0));
		this.save();
	}
}

