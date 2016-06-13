/**
 *
 * @name Users API Controller
 * @package Suretix.API.v1
 * @description This is the Users API Controller
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseAPIController"{
	property name="ModelUsers" inject="model:User";
	property name="ModelRoles" inject="model:UserRoles";
	property name="UserService" inject="UserService";
	property name="AccessRoles" default="Administrator,Editor";
	
	this.API_BASE_URL = "/api/v1/users";
		
	//(GET) /api/v1/users
	function index(event,rc,prc){
		runEvent('api.v1.Users.list');
	}	

	//(GET) /api/v1/users/:id
	function get(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallUser(argumentCollection=arguments);
	}	

	//(GET) /api/v1/users (search)
	function list(event,rc,prc){
		this.marshallUsers(argumentCollection=arguments);
	}	

	//(POST) /api/v1/users
	function add(event,rc,prc){
		requireRole("Administrator");
		var creation = UserService.createUser(rc);

		if(creation.success){

			rc.id = creation.result.getId();
			marshallUser(argumentCollection=arguments);
			rc.statusCode = STATUS.CREATED;
	
		} else {
	
			rc.statusCode = STATUS.NOT_ACCEPTABLE;
			rc.data['error'] = creation.friendlyMessage;
			rc.data['validationErrors'] = creation.message;	
	
		}
			
	}	

	//(PUT) /api/v1/users/:id
	function update(event,rc,prc){
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallUser(argumentCollection=arguments);
		if(structKeyExists(prc,'user') and (isUserInRole("Administrator") or prc.user.getId() == session.currentUser.id)){
			var updated = UserService.updateUser(prc.user,rc);

			if(updated.success){

				rc.id = updated.result.getId();
				marshallUser(argumentCollection=arguments);
		
			} else {
		
				rc.statusCode = STATUS.NOT_ACCEPTABLE;
				rc.data['error'] =updated.friendlyMessage;
				rc.data['validationErrors'] = updated.message;	
		
			}
		} else {
			onAuthorizationFailure();
		}
	}	

	//(DELETE) /api/v1/users/:id
	function delete(event,rc,prc){
		requireRole("Administrator");
		var currentUser = getModel("User").get(session.currentUser.id);
		//404 default
		rc.statusCode = STATUS.NOT_FOUND;
		this.marshallUser(argumentCollection=arguments);
		if(structKeyExists(prc,'user') && prc.user.getId() != currentUser.getId()){
			prc.user.delete();

		} else if(structKeyExists(prc,'user')){
			rc.statusCode = STATUS.NOT_ALLOWED;
			rc.data['error'] = "You are not authorized to delete this user";	
		}
	}	

	//(GET) /api/v2/users/roles
	function roles(event,rc,prc){
		var roles = getModel("UserRoles").list(asQuery=false,sortOrder='SortOrder');
		rc.statusCode = STATUS.SUCCESS;
		rc.data['roles'] = [];
		for(var role in roles){
			arrayAppend(rc.data.roles,role.asStruct());
		}
	}


	private function marshallUser(event,rc,prc){
		var user = ModelUsers.get(rc.id);
		if(!isNull(user)){
			var sUser = user.asStruct(false,true);
			structDelete(sUser,'password');
			rc.data['user'] = sUser;
			rc.data.user['href'] = this.API_BASE_URL&'/'&user.getId();
			rc.data.user['role'] = user.getRole().asStruct(false,true);
			rc.data.user['gravatar'] = '//www.gravatar.com/avatar/' & lcase(Hash(lcase(user.getEmail()))) & '?d=mm';
			prc.user = user;
			rc.statusCode = STATUS.SUCCESS;
		}
	}	

	private function marshallUsers(event,rc,prc){
		rc.data['users']=[];
		if(structKeyExists(rc,'roleid')){
			var users = ModelUsers.list(criteria={"Role":ModelRoles.findById(rc.roleid)},asQuery=false);
		} else {
			var qUsers = ModelUsers.newCriteria();
			qUsers.createAlias('Role','Role');
			qUsers.add(qUsers.restrictions.le('Role.id',javacast('integer',3)));
			qUsers.order('Role.SortOrder','ASC');
			qUsers.order('LastName','ASC');

			var users = qUsers.list(asQuery=false);
		}
		
		prc.users = users;

		for(var user in users){
			sUser = user.asStruct(false,true);
			structDelete(sUser,'password');
			sUser['href'] = this.API_BASE_URL&'/'&user.getId();
			sUser['role'] = user.getRole().asStruct(false,true);
			sUser['gravatar'] = '//www.gravatar.com/avatar/' & lcase(Hash(lcase(user.getEmail()))) & '?d=mm';
			arrayAppend(rc.data.users,sUser);
		}

		rc.statusCode = STATUS.SUCCESS;

	}	


	
}
