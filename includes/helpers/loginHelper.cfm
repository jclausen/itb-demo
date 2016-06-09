<!--- Login/Logout Functions--->
<cffunction name="loginUser" access="public" hint="I am the helper function to log in a user" returntype="void">
<cfargument name="user" type="lib.Model.User" required="true">
<cfargument name="rc" required="true" hint="The request collection">
<cfargument name="tokenAuthentication" required="true" default=false>
<cflogin>
<cfset roleName = user.getRole().getName()>
<cfif roleName == "Super Administrator">
	<cfset roleName &=',Administrator'>
</cfif>
<cfloginuser name="#user.getEmail()#" password="#hash(user.getPassword())#" roles="#roleName#">
</cflogin>
<cfscript>
	user.initializeAuthSession(tokenAuth=ARGUMENTS.tokenAuthentication)
</cfscript>
<cfset rc.authUser=arguments.user/>
</cffunction>


<cffunction name="logoutUser" access="public" hint="I logout the user" returntype="void">
<cfscript>
	if(len(getAuthUser())){
		var sessionUser = application.wirebox.getInstance('User').findByEmail(getAuthUser());
		if(!isNull(sessionUser)){
			sessionUser.finalizeAuthSession();
		}
	}
</cfscript>
<cflogout>
</cffunction>