<cfscript>
if(!isDefined("this")) abort;

private struct function getORMSettings(){
	var settings = {
		eventHandling = true,
		eventHandler = "cborm.models.EventHandler",
		// ENTITY LOCATIONS, ADD MORE LOCATIONS AS YOU SEE FIT
		cfclocation=["lib/model"],
		// THE DIALECT OF YOUR DATABASE OR LET HIBERNATE FIGURE IT OUT, UP TO YOU TO CONFIGURE
		dialect = "MySQL",
		// DO NOT REMOVE THE FOLLOWING LINE OR AUTO-UPDATES MIGHT FAIL.
		dbcreate = "update",
		sqlscript= expandPath("config/initdb.sql"),
		useDBForMapping=true,
		autogenmap=true,
		savemapping=false,
		// FILL OUT: IF YOU WANT CHANGE SECONDARY CACHE, PLEASE UPDATE HERE
		secondarycacheenabled = false,
		cacheprovider		= "ehCache",
		// ORM SESSION MANAGEMENT SETTINGS, DO NOT CHANGE
		logSQL 				= findNoCase("127.0.0.1",CGI.HTTP_HOST)?true:false,
		flushAtRequestEnd 	= false,
		autoManageSession	= false,
		// THIS IS ADDED SO OTHER CFML ENGINES CAN WORK WITH CONTENTBOX
		skipCFCWithError	= true,
		searchenabled		= true,
		search.autoindex	= false,
		search.indexDir		= expandPath('/includes/tmp/searchindex'),
		search.language		= 'English'
	};
	
	//send it back
	return settings;
}

private string function getDatasource(){
	return "itb_suretix";
}

include '/includes/helpers/loginHelper.cfm'
</cfscript>