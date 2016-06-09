<cfscript>
	/**
	* Formats a telephone number in to a standard international formation
	**/
	function formatTel(phone){
		var tel = reReplaceNoCase(arguments.phone,'[^[:digit:]]', '', 'ALL');
		if(left(tel,1) NEQ '1'){
			tel = '+1'&tel;
		} 
		return tel;
	}
</cfscript>