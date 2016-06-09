/**
 *
 * @name File Service
 * @package ImageTours.Model.Service
 * @description This is the File Service for processing file uploads and batch operations
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] 2013 Image Tours Inc
 * 
 **/
component entityname="FileService" output="false" singleton {
property name="tmp_path" default="";
property name="tmp_directory" default="";

//bring in external udf
include "/includes/helpers/spreadsheetHelper.cfm";

public function init(){
	this.tmp_path = "/includes/tmp/";
	this.tmp_directory = expandPath(this.tmp_path);	
}

/**
 * Base spreadsheet upload processing function
 **/
public any function processSpreadsheetUpload(event,input,save=false){
	var sFile = uploadToTemp(arguments.input);
	var ext ="csv";
	var file_path = sfile.serverdirectory&"/"&sFile.serverfile;
	var qSpreadSheet = '';
	if(isStruct(sFile)){
		ext = listLast(sFile.serverfile,".");
		if(ext IS "csv"){
			var qSpreadsheet = trim(fileRead(file_path));
			qSpreadSheet =  HeaderRowDelimitedToQuery(qSpreadsheet).data;
		} else if(ext IS "xls" or ext is "xlsx") {
			qSpreadSheet = SpreadsheetToQuery(file_path);	
		}
		//clean up
		if(!save){
			fileDelete(file_path);	
		} else {
			event.setValue('uploaded_file',file_path);
		}
		//return our query
		return qSpreadSheet;
	} else {
		return sFile;
	}
}
/**
 * convert CSV file to query
 **/
public any function csvToQuery(file){
	var qFile = '';
	var http = new http(name="qFile");
	var url = "http://"&CGI.server_name&this.tmp_path&arguments.file;
	//first try the easy way using http
	try{
		http.setMethod("get");
		http.setURL(url);
		qFile = http.send().getPrefix();
		return qFile;
	} catch(any excpt){
		//now try the hard way by looping over CSV content
		qFile = fileRead(this.tmp_directory&arguments.file);
			try{
				qFile = HeaderRowDelimitedToQuery(qFile);
				return qFile.data;
			} catch(any excpt){
				return "Failure to read file.  The file provided is not a valid format.<br/>The exception message provided was:<br/>"&excpt.message;		
			}	
	}//end try-catch csv
		
	}
	/**
	 * Upload file to temp directory
	 **/
public any function uploadToTemp(input){
	var tmp_dir = this.tmp_directory;
	var uploaded = "";
	try{
		uploaded = fileUpload(tmp_dir,arguments.input,"*","makeunique");
		return uploaded;		
	} catch(any excpt){
		return "File upload failed.  There may be a problem with the permissions on the directory or the file input provided did contain a valid file type.<br/> The Message provided was:<br/>"&excpt.message;
	}

}




}
