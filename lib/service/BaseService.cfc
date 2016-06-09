/**
 *
 * @name Base Service
 * @package Suretix.Model
 * @description This is the Base Service
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] Silo Web, LLC
 * 
 * 
 **/
component name="BaseService" extends="cborm.models.BaseORMService"{
	property name="Wirebox" inject="wirebox";
	property name="AppSettings" inject="wirebox:properties";

	// all returns structs predictable.
	public struct function newResponse() {
		
		var result = {
			'success': false,
			//A placeholder for the result to be returned
			'result': javacast('null',0),
			// System generated message.
			'message': '',
			// A message that can be relayed to the end user
			'friendlyMessage': '',
			// Errors container for validation or other user friendly messages
			'errors': []
		};

		return result;
	}

	private function textFormatEntityAddress(required entityObj){
		var address = 
			entityObj.getAddress1() & chr(10) &
			(len(entityObj.getAddress2())?entityObj.getAddress2() & chr(10):'') &
			entityObj.getCity() & ', ' & entityObj.getState() & '  ' & entityObj.getZip() & chr(10) &
			entityObj.getCountry();

		return address;

	}

	private function htmlToText(required string text,required removeAnnotations=true){
		var resultString = ARGUMENTS.text;
		//strip html tags
		resultString = reReplaceNoCase(resultString, "<.*?>","","all");
		resultString = reReplaceNoCase(resultString, "^.*?>","");
		resultString = reReplaceNoCase(resultString, "<.*$","");

		//change html entities
		resultString=ReplaceNoCase(resultString,"&apos;","'","ALL");
		resultString=ReplaceNoCase(resultString,"&quot;",'"',"ALL");
		resultString=ReplaceNoCase(resultString,"&rdquo;",'"',"ALL");
		resultString=ReplaceNoCase(resultString,"&ldquo;",'"',"ALL");
		resultString=ReplaceNoCase(resultString,"&rsquo;","'","ALL");
		resultString=ReplaceNoCase(resultString,"&lsquo;","'","ALL");
		resultString=ReplaceNoCase(resultString,"&lt;","<","ALL");
		resultString=ReplaceNoCase(resultString,"&gt;",">","ALL");
		resultString=ReplaceNoCase(resultString,"&amp;","&","ALL");

		//replace any commas so excel doesn't balk
		resultString=replaceNoCase(resultString,',','&##44;',"ALL");
		//remove any annotations
		if(removeAnnotations){
			resultString = reReplaceNoCase(resultString, "\(([^\)]+)\)","","ALL");
		}
		return trim(resultString);
	}

	private function entityFromUpload(required row,required string modelName,save=false){
		var settings = VARIABLES.AppSettings;
		var import_map = settings['import_maps'][arguments.modelName];
		var EntityModel = Wirebox.getInstance(arguments.modelName);
		var entity = EntityModel.entityFromImportMap(row,import_map,false);

		if(save && entity.isValid()){
			entity.save();
		}

		return entity; 		
	}


	private function distributorFromUpload(row,save=true){
		var distributor = entityFromUpload(row,"Distributor",false);
		
		//see if we can find our distributor by name
		var existing = distributor.findByName(distributor.getName());

		if(!isNull(existing)){
			return existing;
		} else if(distributor.getName() == 'Distributor Name'){
			return distributor.get(1);
		} else {
			if(save && distributor.isValid()){
				distributor.save();
			} else if(save){
				writeDump(var=distributor.getValidationResults().getAllErrors());
				abort;
			}
			return distributor;
		} 		
	}

	

}