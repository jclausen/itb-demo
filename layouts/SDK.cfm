<html>
<head>
	<title>Suretix - Suretix USA</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
    <!-- Remote Included Styles -->
    <link href="/includes/css/remote.css" rel="stylesheet" media="screen"/>
    <!-- this page specific styles -->
    <cfif NOT isNull(PRC.assetBag) && arrayLen(PRC.assetBag)>
        <cfloop array="#PRC.assetBag#" index="assetPath">
            <cfif right(assetPath, 3) EQ "css">
                <link rel="stylesheet" href="<cfoutput>#lcase(assetPath)#</cfoutput>" rel="stylesheet" type="text/css">
            </cfif>
        </cfloop>
    </cfif>

    <!-- open sans font -->
    <link href='//fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css' />

    <!-- lato font -->
    <link href='//fonts.googleapis.com/css?family=Lato:300,400,700,900,300italic,400italic,700italic,900italic' rel='stylesheet' type='text/css' />

    <!--[if lt IE 9]>
      <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
</head>
<body class="ra-enabled">
<cfoutput>
	#renderView()#
<script src="/includes/js/opt/require.js" type="application/javascript"></script>
<script type="application/javascript">
require(['/includes/js/opt/es6-shim.js'],function(){
    require(['/includes/js/opt/remote.js'],function(globals){
        require(['/includes/js/opt/app.js']);
        <cfloop array="#PRC.assetBag#" index="assetPath">
            <cfif right(assetPath, 2) EQ "js">
            require(['#lcase(assetPath)#']);
            </cfif>
        </cfloop>
    });
});
</script>
</script>
<script src="/includes/js/opt/iframeContentWindow.js" type="application/javascript"></script>
</cfoutput>
</body>
</html>