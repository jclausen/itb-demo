component displayname="extension provider" output="false" {

	instance = {
		thisAddress = "http://#cgi.SERVER_NAME#:#cgi.SERVER_PORT#/lib/luceeExtensions/cfspreadsheet/"
	};


	remote struct function getInfo(){
		var info = {
			title="Leftbower",
			description="A spreadsheet extension for Lucee",
			image="#instance.thisAddress#leftbower.png",
			url="https://github.com/Leftbower/cfspreadsheet-lucee",
			mode="develop"
		};
		return info;
	}

	remote query function listApplications(){
		var apps = queryNew('type,id,name,label,description,version,category,image,download,author,codename,video,support,documentation,forum,mailinglist,network,created');
		var rootURL=getInfo().url;
		var desc = "cfspreadsheet";
		QueryAddRow(apps);
		QuerySetCell(apps,'id','C092CE1F-C769-4E92-8A7AB609204D8F71');
		QuerySetCell(apps,'name','cfspreadsheet');
		QuerySetCell(apps,'type','web');
		QuerySetCell(apps,'label','&lt;cfspreadsheet /&gt;');
		QuerySetCell(apps,'description',desc);
		QuerySetCell(apps,'author','Extension by Andrew Kretzer (forked from Andy Jarrett)<br/>CFPOI by Matt Woodward');
		QuerySetCell(apps,'image','#instance.thisAddress#Apps-Spreadsheet-App-icon.png');
		QuerySetCell(apps,'support','https://github.com/Leftbower/cfspreadsheet-lucee/issues');
		QuerySetCell(apps,'documentation','https://github.com/Leftbower/cfspreadsheet-lucee/wiki');
		QuerySetCell(apps,'created',CreateDate(2015,3,17));
		QuerySetCell(apps,'version',"4.00");
		QuerySetCell(apps,'category',"Application");
		QuerySetCell(apps,'download','#instance.thisAddress#/cfpoi.zip');
		//QuerySetCell(apps,'download','https://github.com/Leftbower/cfspreadsheet-lucee/raw/master/cfpoi.zip');

		return apps;
	}
}
