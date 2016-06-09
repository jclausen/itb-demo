<!-- scripts -->
<!---<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/jquery-ui-1.10.2.custom.min.js"></script>
<!-- knob -->
<script src="js/jquery.knob.js"></script>
<!-- flot charts -->
<script src="js/jquery.flot.js"></script>
<script src="js/jquery.flot.stack.js"></script>
<script src="js/jquery.flot.resize.js"></script>
<script src="/includes/js/theme/theme.js"></script>--->

<!-- dynamic assets -->
<cfoutput>
<script src="/includes/js/opt/require.js" type="application/javascript"></script>
<script type="application/javascript">
require(['/includes/js/opt/es6-shim.js'],function(){
	require(['/includes/js/opt/globals.js'],function(globals){
		require(['/includes/js/opt/app.js']);
		<cfloop array="#PRC.assetBag#" index="assetPath">
			<cfif right(assetPath, 2) EQ "js">
			require(['#lcase(assetPath)#']);
			</cfif>
		</cfloop>
	});
});
</script>

<!--- <cfloop array="#PRC.assetBag#" index="assetPath">
	<cfif right(assetPath, 2) EQ "js">
		<script src="/includes/js/opt/require.js" data-main="#replaceNoCase(lcase(assetPath), '.js','','all')#" type="application/javascript"></script>
	</cfif>
</cfloop> --->
</cfoutput>	