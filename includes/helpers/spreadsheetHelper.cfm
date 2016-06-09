<cfscript>
include "CSVToQuery.cfm";
if (!isDefined("changeColumName")){
	include "queryHelper.cfm";
}
</cfscript>

/**
 * File download delivery
 **/

<cffunction name="downloadFile" access="public" returntype="void">
	<cfargument name="filePath" required="true" type="string">
	<cfscript>
	var file_separator = '/';
	var mimeType=getMimeType(arguments.filePath);
	if(findNoCase("windows",server.os.name)){
		file_separator = '\';
	}
	</cfscript>
	<cfheader name="Content-disposition" value="attachment;filename=#scrubFileName(listLast(filePath,file_separator))#">
	<cfcontent type="#mimeType#" file="#arguments.filePath#" deleteFile="true" reset="true">
</cffunction>

<cfscript>
/**
* Process the first column of a query as the headers
* Note: Utility function to prevent errors on duplicate column names
**/
public query function processFirstRowHeaders(qSpreadsheet){
	var i = 1;
	var columns="";
	var qNew = queryNew('deleteme');
	var header = structNew();
	var ids = listToArray(qSpreadsheet.getColumnList());
	//create an array from our query
	for (row in qSpreadsheet){
		if(i EQ 1){
			for(var id in ids){
				var colname="";
				if(len(trim(row[id]))){
					if(ListValueCount(columns, row[id]) EQ 0){
						colname = row[id];
					} else {
						colname = row[id]&'['&listValueCount(columns,row[id])&']';
					}	
				} else{
					colname=id;
				}
				columns = listAppend(columns,colname);
				queryAddColumn(qNew,colname);
			}
			queryDeleteColumn(qNew,'deleteme');
			header['columns'] = listToArray(columns,',',true);
			header['ids']=ids;
		} else {
			colvals = "";
			for(var skey in row){
				colvals = listAppend(colvals,row[skey]);
			}
			var qRow = queryAddRow(qNew);
			for(var id in header.ids){
				querySetCell(qNew,header.columns[arrayFind(header.ids,id)],row[id],qRow);
			}
		}
		i=i+1;
	}
	//now delete any empty columns
	for(var col in header.columns){
		if(findNoCase("COL_",col) and !listLen(valueList(qNew[col]))){
			queryDeleteColumn(qNew,col);
		}
	}
	//cleanup memory - we're going to need it
	qSpreadsheet = javacast('null',0);
	return qNew;
}

public query function createBlankQueryFromRow(row){
	writeDump(var=row,top=1);
	abort;

}

/**
 * Convert Query to Excel Spreadsheet
 * @via help http://gist.github.com/imageaid/884140
 **/
public string function QueryToExcel(q,name="DataFile",sort=false){
	var columnList=getColumnListArray(arguments.q,arguments.sort);
	var filePath = this.tmp_directory&arguments.name&".xlsx";
	// first we create the spreadsheet object
	var spreadsheet = spreadsheetNew(arguments.name,true);
	// next we add the header row
	spreadsheetAddRow(spreadsheet,arrayToList(columnList));
	// I want to format my headers so that they're bold and centered
	spreadsheetFormatRow(spreadsheet,{bold=true,alignment="left"},1);
	//loop our columns and add our row
	var r = 2;
	for (var row in arguments.q){
		var vals = arrayNew(1);
		var i = 1;
		//vals = arrayToList(vals);
		spreadsheetAddRow(spreadsheet,arrayToList(columnList));
		//loop through our columns and set each cell individually - avoiding the comma issues caused by populating with a delimited list
		for(i=1; i LTE arrayLen(columnList);i=i+1){
			SpreadsheetSetCellValue(spreadsheet, row[columnList[i]],r,i);			
		} 
		r=r+1;
	}
	// finally, write the file to the server/file system
	spreadsheetWrite(spreadsheet,filePath,true);
	return filePath;
	
}

public string function QueryToCSV(q,name="DataFile",sort=false){
	var filePath = this.tmp_directory&arguments.name&".csv";
	var columnList = getColumnListArray(arguments.q,arguments.sort);
	var d = chr(10);
	var content = arrayToList(columnList)&d;
	for(row in arguments.q){
		var vals = arrayNew(1);
		var i = 1;
		//create an array from our row structure and santize the data
		for(i=1; i LTE arrayLen(columnList);i=i+1){
			 	arrayAppend(vals,replace(row[columnList[i]],',','&##44;','all'));			
		} 
		content &= arrayToList(vals)&d;
	}
	//write the file
	fileWrite(filePath,content);
	return filePath;
}	

private array function getColumnListArray(q,sort=false){
	var columnList=q.getColumnNames();
	if(arguments.sort){
		//convert and reconvert our array to make it sortable
		columnList=arrayToList(columnList);
		columnList=listToArray(columnList);
		//now sort our list and return it
		arraySort(columnList,'textnocase','asc');
	}
	return columnList;	
}	

	

private string function getMimeType(required string file){
	switch(listLast(file,'.')){
		case "xlsx":
			return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

		case "xls":
			return "application/vnd.ms-excel";

		default:
		 return fileGetMimeType(arguments.file);
	}

}

private string function scrubFileName(required string fileName){
    var extension = reverse(listfirst(reverse(arguments.fileName),"."));
    arguments.fileName = reverse(listrest(reverse(arguments.fileName),"."));
    arguments.fileName = Replace(arguments.fileName, ' ', '_', 'all');
    arguments.fileName = REReplace(arguments.fileName, '\W', '', 'all');
    return arguments.fileName & "." & extension;
}
</cfscript>

