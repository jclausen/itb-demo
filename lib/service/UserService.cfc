/**
 *
 * @name User Service
 * @package Suretix.Service
 * @description This is the User Service
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component extends="BaseService" singleton{
	property name="ModelUser" inject="model:User";
	property name="ModelRoles" inject="model:UserRoles";
	
	/**
	* Constructor
	*/
	function init(){
		
		// init super class
		super.init();
		
		// Use Query Caching
	    setUseQueryCaching( false );
	    // Query Cache Region
	    setQueryCacheRegion( "ormservice.User" );
	    // EventHandling
	    setEventHandling( true );
	    
	    return this;
	}

	/**
	* Create User Method
	**/
	public function createUser(required struct collection){
		var response = newResponse();
		if(!structKeyExists(collection,'Role')){
			collection['Role']=7;
		}

		var user = ModelUser.new(properties=collection,ignoreEmpty=true);

		//handle collection password
		if(
			structKeyExists(collection,'NewPassword') && 
			structKeyExists(collection,"VerifyPassword")  && 
			collection.NewPassword == collection.VerifyPassword)
		{
			user.setPassword(toSecurePassword(collection.NewPassword));
		}
		
		if(user.isValid()){	
			user.save();
			response.success=true;
			response.result=user;
		} else {
			response.friendlyMessage="The user could not be added because the record did not pass validation.  Please try again.";
			response.message = user.getValidationResults().getAllErrors();
			response.errors = user.getValidationResults();
		}

		return response;

	}


	/**
	* Update User
	**/
	public function updateUser(required User User,required struct collection){
		var response = newResponse();
		var currentUser = ModelUser.get(session.currentUser.id);
		//handle any permissions on editing first thing
		if(!currentUser.mayEdit(arguments.User)){
			esponse.friendlyMessage="The user could not be updated your permission do not allow it.";
			response.message = "Not Authorized";
			return response;
		}
			
		//We need to protect certain things from updates
		var tmpCollection = duplicate(collection);
		structDelete(tmpCollection,'password');
		structDelete(tmpCollection,'role');


		//password changes
		if(
			structKeyExists(tmpCollection,'CurrentPassword')
			&&
			len(tmpCollection.currentPassword)
			&&
			structKeyExists(tmpCollection,'NewPassword')
			&&
			structKeyExists(tmpCollection,'VerifyPassword')
			&&
			len(tmpCollection.NewPassword)
			&&
			User.getPassword() == toSecurePassword(tmpCollection.CurrentPassword)
			&&
			tmpCollection.NewPassword == tmpCollection.VerifyPassword
		) {
		
			tmpCollection.password=toSecurePassword(tmpCollection.NewPassword); 
		
		} else if (!structKeyExists(tmpCollection,'CurrentPassword') || (structKeyExists(tmpCollection,'CurrentPassword') && !len(tmpCollection.CurrentPassword)) ) 
		{
			//doing nothing,la dee da
		
		} else if(User.getPassword() != toSecurePassword(tmpCollection.CurrentPassword)){
		
			response.friendlyMessage="The password could not be changed because you did not enter the current password";
			response.message = "Invalid Password Verification";
			return response;
		
		} else if(tmpCollection.NewPassword != tmpCollection.VerifyPassword) {

			response.friendlyMessage="The password could not be changed the two versions of the new password did not match";
			response.message = "Invalid Password Verification";
			return response;

		}


		//begin green light
		User.populate(memento=tmpCollection);


		if(structKeyExists(collection,'Role')){
			var selectedRole = ModelRoles.get(collection.role);
			//FIXME - the < 3 test isn't always going to work
			if(
				currentUser.inRole("Super Administrator") 
				|| 
				(
					currentUser.getRole().getSortOrder() < 3 
					&& 
					currentUser.getRole().getSortOrder() <= selectedRole.getSortOrder()
				) 
			){
				User.setRole(selectedRole);
			}
		}

		if(User.isValid()){

			User.save();

			response.success=true;
			response.result=User;
		} else {
			response.friendlyMessage="The user could not be updated because the changes did not pass validation.  Please try again.";
			response.message = User.getValidationResults().getAllErrors();
			response.errors = User.getValidationResults();
		}

		return response;
	}

	/**
	* Users the MYSQL password Hashing Function to Return a Secure Password String
	**/
	public function toSecurePassword(password){
		var q = new query();
		q.addParam(name='pwd', value=arguments.password, cfsqltype="cf_sql_varchar");
		var sql = 'SELECT PASSWORD(:pwd) as generated_password';
		var qGet = q.execute(sql=sql).getResult();
		return qGet.generated_password;
	}
	
}
