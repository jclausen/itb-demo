/**
 *
 * @name Request Decorator
 * @package ImageTours.Decorators
 * @description This is the request decorator object for all site requests
 * @author Jon Clausen <jon_clausen@silowebworks.com>
 * @copyright [c] 2013 Image Tours Inc
 *
 **/
component entityname="RequestContextDecorator" output="false" accessors="true"  extends="coldbox.system.web.context.RequestContextDecorator" {
	property name="controller";
	property name="event";
	property name="wirebox" inject="wirebox";
	property name="messagebox" inject="messagebox@cbmessagebox";

	public void function configure(){

		var controller = getController();
		var event = controller.getRequestService().getContext();
		this.controller = controller;
		this.event = event;
	}

	/**
	 * Display Function - Smart Switch Between HTML with layout an AJAX view
	 **/
	 public void function display(view=''){
	 	 var rc = this.event.getCollection();
	 	 var renderer=application.wirebox.getInstance('renderer@coldbox');
	 	 if(structKeyExists(rc,'data')){
	 	 	ensureJSONSafe(rc.data);
	 	 }
	 	 if(structKeyExists(rc,"format") and rc.format eq 'html'){
	 	 	 this.noLayout();
	 	 } else if(!structKeyExists(rc,'format')){
	 	 	 rc.format='json';
	 	 }

	 	 //add our view html as part of the data so that our AJAX methods can use our data for other DOM updates
	 	 if(len(arguments.view) and this.event.valueExists('data') and rc.format EQ 'json'){
	 	 	rc.data['html']=renderer.renderView(arguments.view);
	 	 }

	 	 //PDF filtering
	 	 if(rc.format IS 'pdf'){ 	 
	 	 	this.event.setValue('document_view',arguments.view);
	 	 	arguments.view='layouts/PDF';
	 	 	this.event.setView(arguments.view);
	 	 } else {
	 	 	this.event.setView(arguments.view);	
	 	 }
	 	 
	 	 if(rc.format != 'html'){
		 	 //include our messagebox
		 	 var messages = getMessagebox().getMessage();
		 	 if(isStruct(messages) and !structIsEmpty(messages) and len(messages.message)){
		 	 	rc.data['message']=messages.message;
		 	 	getMessagebox().clearMessage();	
		 	 }
	 	 }
	 	 
	 	 this.event.renderData(data=this.event.getValue("data",{error={message="No data available",statuscode=406}}),formats="display,pdf,xml,json,html",formatsView=arguments.view);
	 }
	 /**
	 * Ensure ORM Objects are JSON Safe for Lucee/Railo
	 **/
	private function ensureJSONSafe(data) {
		if(isStruct(data)){
			for(var key in data){
				//TODO: Add additional filtering for ORM objects
				if(!isNull(data[key]) and isObject(data[key])){
					data[key]=data[key].asStruct();
				} else if(!isNull(data[key]) and isArray(data[key])){
					ensureJSONSafe(data[key]);
				}
			}	
		} else if(isArray(data)){
			i=1;
			for(var item in data){
				if(isObject(item)){
					data[i]=item.asStruct();
				} else if(isArray(item) or isStruct(item)){
					ensureJSONSafe(item);
				}
				i++;
			}
		}
		
	}


	public void function setPagingDefaults(filter_base_url){
		var paging_ban_vars='submit,update,fieldnames';
		var rc = getCollection();
		var prc = getCollection(private=true);
		if(!structKeyExists(arguments,"filter_base_url")){
			filter_base_url=reReplaceNoCase(prc.currentRoutedURL,'/page/([^/]+)/','/',"ALL");
		}
		rc.search_url_appendix='';
		//set default paging variables
	 	 if(!valueExists("maxrows")){
			setValue("maxrows",25);
		}
		if(!valueExists("page") or getValue("page") == 1){
			setValue("startrow",0);
		} else{
			setValue("startrow",(getValue("maxrows")*getValue("page"))+1);
		}
		//if we are posting, turn our post vars in to url structure

		if(getHTTPMethod() is "POST"){
			for(item in FORM){
				if(len(form[item]) and !listFind(paging_ban_vars,lcase(item))){
				filter_base_url &= lcase(item)&'/'&urlEncodedFormat(FORM[item])&'/';
				}
			}
		}

		rc.paging_base_url = filter_base_url;

	}


}