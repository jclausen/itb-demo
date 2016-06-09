<cfscript>
  var AppSettings = args.AppSettings;
  var content = args.content;
</cfscript>
<!--- Ick, we have to use a table layout.  Otherwise Outlook,GMail and some others won't play nice --->
<html>
<head>
<style type="text/css">
/**Begin Custom Styles**/

body,#html-content-wrap{
  width: 100%;
  margin: 0px 0px 0px 0px;
  padding: 0px 0px 0px 0px;
	background: #f6f6f6;
	color: #4e4e50;
	font-family: sans-serif;
  font-size: 15px;
}

p {
	line-height: 1.3em;
}

div#content-wrap{
	width: 600px;
	background:#ffffff;
	box-shadow: 0px 0px 14px #999;
}

tr#footer td{
	font-size: .7em;
	padding-top: 40px;
  padding-bottom: 40px;
	color: #ccc;
}

table#content-table td {
  min-height: 500px;
  padding: 0px 0px 0px 0px!important;
  width: 100%!important;
}

img{
  display:block;
  max-width: 100%!important;
}

p {
  display:block;
  padding-top: 0px;
  padding-bottom: 0px;
  font-size: .9em;
  line-height: 1.3em;
  margin-top: 10px;
  margin-bottom: 10px;
}

ul li {
  font-size: .9em;
}

a,a:link{
	color: #0088cc;
	text-decoration: underline;
}

h1 a,h2 a,h3 a,h4 a,h5 a,h6 a{
  color: #0088cc;
  text-decoration:none;
}

h2 {
  font-size: 1.3em;
  font-weight: 300;
}


a:visited{
	color: #0088cc;
}


table,tr,td{
	border: none!important;
}

/** Utility Classes **/
.clearfix {
  display:block!important;
  height: 1px!important;
  width: 99%!important;
  margin-right: auto!important;
  margin-left: auto!important;
  float: none!important;
  clear: both!important;
}
.clearfix:before,
.clearfix:after,
.container:before,
.container:after,
.container-fluid:before,
.container-fluid:after,
.row:before,
.row:after,
.form-horizontal .form-group:before,
.form-horizontal .form-group:after,
.btn-toolbar:before,
.btn-toolbar:after,
.btn-group-vertical > .btn-group:before,
.btn-group-vertical > .btn-group:after,
.nav:before,
.nav:after,
.navbar:before,
.navbar:after,
.navbar-header:before,
.navbar-header:after,
.navbar-collapse:before,
.navbar-collapse:after,
.pager:before,
.pager:after,
.panel-body:before,
.panel-body:after,
.modal-footer:before,
.modal-footer:after {
  display: table;
  content: " ";
}
.clearfix:after,
.container:after,
.container-fluid:after,
.row:after,
.form-horizontal .form-group:after,
.btn-toolbar:after,
.btn-group-vertical > .btn-group:after,
.nav:after,
.navbar:after,
.navbar-header:after,
.navbar-collapse:after,
.pager:after,
.panel-body:after,
.modal-footer:after {
  clear: both;
}

/** Content Containers **/

/**Responsive Media Query to Adjust to Two-Column Width When Screen is > 580**/

@media (max-width: 599px){
  table#content-table,table#content-table td,#content-wrap{
    width: 100%;
  }
  tr#header td {
    width: 100%!important;
  }
  tr#header td a img{
    width: 100%!important;
  }
  div#content-wrap{
    width: 100%!important;
  }
  div#content-wrap table#content-table{
    width:100%!important;
  }
  div.content-buttons div.col-md-4.col-sm-12 br {
    display:none;
  }
}
</style>
</head>
<cfoutput>
	<body>
		<table id="html-content-wrap" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td align="center">
					<div id="content-wrap">
						<table id="content-table" cellspacing="0" cellpadding="0" border="0" align="center">
							<cfif structKeyExists(AppSettings,"tennantLogo")>
                <tr id="header">
                <td align="center">
                      <cfif structKeyExists(AppSettings,"tennantBaseURL")>
                          <a href="#AppSettings.tennantBaseURL#">
                      </cfif>
                          <img class="logo" src="#AppSettings.tennantLogo#" style="width: 300px"/>
                      <cfif structKeyExists(AppSettings,"tennantBaseURL")>
                        </a>
                      </cfif>
                  </td>
                </tr>  
              </cfif>
              <tr id="main_content">
								<td style="min-height: 200px;">
                  <div style="margin-top: 50px;margin-bottom: 50px;padding-left: 30px;padding-right: 30px;">
								  #content#
                  </div>
						  	 </td>
						  	</tr>
							<tr id="footer">
								<td align="center">
						      		
						    </td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table><!--end HTML content wrap table -->
	</body>
</cfoutput>
</html>