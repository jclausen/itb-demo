<cfscript>
 var logoPath = '/includes/images/logo.png';
 if(settingExists('tennantAdminLogo')) logopath = getSetting('tennantAdminLogo')
</cfscript>
<!-- navbar -->
<header class="navbar navbar-inverse" role="banner">
    <div class="navbar-header">
        <button class="navbar-toggle" type="button" data-toggle="collapse" id="menu-toggler">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="/">
            <img src="<cfoutput>#logoPath#</cfoutput>" alt="logo" style="max-height: 30px" /><br>   
        </a>
        <a class="navbar-brand" href="/">
            <sub style="color:##ffffff;text-transform:none">by <cfoutput>#getSetting("tennantCompanyName")#</cfoutput></sub>
        </a>
    </div>
    <ul class="nav navbar-nav pull-right hidden-xs">
        <!--- <li class="hidden-xs hidden-sm">
            <input class="search" type="text" placeholder="Search Claims & Registrations" />
        </li> --->
        <cfif structKeyExists(session,'currentUser')>
        <li class="dropdown">
            <a href="#" class="dropdown-toggle hidden-xs hidden-sm" data-toggle="dropdown">
                <cfoutput>
                    #session.currentUser.firstName# #session.currentUser.lastname#
                </cfoutput>
                <b class="caret"></b>
            </a>
            <ul class="dropdown-menu">
                <li><a href="/user/profile/id/<cfoutput>#session.currentUser.id#</cfoutput>"><i class="icon-user"></i> Profile</a></li>
                <li><a href="/user/index"><i class="icon-list"></i> User List</a></li>
                <li><a href="/logout">Logout</a></li>
            </ul>
        </li>
        </cfif>
        <cfif isUserInRole('Admin')>
            <li class="settings hidden-xs hidden-sm">
                <a href="personal-info.html" role="button">
                    <i class="icon-cog"></i>
                </a>
            </li>
        </cfif>
    </ul>
</header>
<!-- end navbar -->