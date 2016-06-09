/**
* This is the Backbone View extension for Editable EndUser information
**/
define([
    'Backbone',
    'model/States'
],  function(
            Backbone,
            States
        ){
        'use strict';
        var Editable = Backbone.View.extend({
        	//no el - that has to be set manually on init
        	editableIcon:'<button class="editable-indicator glow pull-right hide" style="position:absolute;right:0px;top:0px"><i class="icon icon-pencil"></i></button>',
        	editableSaveIcon:'<button class="save-editable btn-flat large primary pull-right" style="margin-bottom: 15px;"><i class="icon icon-save"></i></button>',
            events:{
            	"click .save-editable":"onSave"
            }

            /**
			* ----------------------------------------------
			* Initializes this view
			* ----------------------------------------------
			*/
            ,initialize:function(el,classification,showIndicator){
            	var _this = this;

                //set our global sync value
                _this.syncSiblings = false;

            	_this.el = el;
            	_this.classification = classification;
            	_this.classprefix = classification.toLowerCase();
                if(typeof(showIndicator) === 'undefined'){
                    _this.showIndicator = true;
                } else {
                    _this.showIndicator = showIndicator;
                }

                console.log("Editable Classification: "+_this.classification)

                _this.modelName = _this.getModelName(_this.classification);

            	//can't proceed without a model id
            	if( !$(_this.el).attr('data-' + _this.classprefix + '-id') ) return;

            	_this.modelId = $(_this.el).attr('data-' + _this.classprefix + '-id');
            	console.log('Requiring model '+_this.modelName);	
            	requirejs( ['model/'+_this.modelName] ,function(model){
            		_this.Model = model;
            		_this.Model.set('id',_this.modelId);
            		return _this.setupDefaults().setupSelectors().render();
            	});

            }

            /**
			* ----------------------------------------------
			* Caches the selectors that are used more than once
			* ----------------------------------------------
			*/
            ,setupSelectors:function($el){
            	var _this = this;
                if(typeof($el) === 'undefined') var $el = $(_this.el);

            	if(_this.showIndicator){
                    $el.prepend(_this.editableIcon);
                    $el.parent().on('mouseenter',function(e){
                        $('.editable-indicator',$el).removeClass('hide');
                        setTimeout(function(){
                            $('.editable-indicator',$el).addClass('hide');  
                        },10000);
                    });

                    $('.editable-indicator',$el).on('click',function(){
                        _this.onEditStart(this);
                    });
                    //add a refresh function so that it can be called from outside of the element
                    $('.editable-indicator',$el).on("sibling:updated",function(){
                        console.log("sibling:update triggered")
                        _this.renderEdited()
                    });

                }

                return this;
            }

            /**
			* ----------------------------------------------
			* Setup some default variables to be used later
			* ----------------------------------------------
			*/
            ,setupDefaults:function(){

                return this;
            }

            /**
 			* ----------------------------------------------
 			* Renders UI
 			* ----------------------------------------------
 			*/
            ,render:function(){
            	//return null without a model
            	if(typeof(this.Model) === 'undefined') return;

                return this;
            }

            ,renderEdited:function(model){
            	var _this = this;

                var resolve = function(model){
                    var templateData = model.attributes;
                    //handle the admin template naming conventions
                    if(typeof(templateData.customer) !== 'undefined') templateData.enduser = templateData.customer;

                    templateData.classification = _this.classification;



                    var detailTemplate = _.template($('#' + _this.modelName.toLowerCase() + '-detail-template').html());
                    $(_this.el).html(detailTemplate(templateData));
                    
                    _this.setupSelectors();
                }


                if(typeof(model) === 'undefined'){
                    _this.Model.fetch({
                        success:resolve,
                        error:function(model,err){
                            console.log(err);
                        }
                    })

                } else {
                    resolve(model);
                    //sync our siblings
                    if(_this.syncSiblings) _this.renderUpdatedSiblings(model);
                }
                
                
            }

            ,renderUpdatedSiblings:function(model){
                
                var _this = this;
                switch(_this.modelName){
                    case "Dealer":
                        var siblings = ['Dealer','Installer','Servicer'];
                        break;
                    default:
                        var siblings = [_this.modelName];
                }

                for(var i in siblings){
                    var sibling = siblings[i];
                    $('[data-classification="' + sibling + '"]').each(function(){
                        var $sibling = $(this);

                        if(
                            sibling !== _this.classification 
                            && 
                            $sibling.find('[data-' + sibling.toLowerCase() + '-id]').length
                            && 
                            $sibling.find('[data-' + sibling.toLowerCase() + '-id]').attr('data-' + sibling.toLowerCase() + '-id') === model.get('id')
                        ){
                            console.log($sibling);
                            $('.editable-indicator',$sibling).trigger('sibling:updated');
                        }
                    })
                }

            }
            
            /**
 			* ----------------------------------------------
 			* Events
 			* ----------------------------------------------
 			*/

 			,onEditStart:function(e){
 				var _this = this;

 				$('.editable-indicator',_this.el).find('.icon').removeClass('icon-save').addClass('icon-spin icon-spinner');

 				//we need to fetch our states
 				States.fetch({
 					success:function(model,resp){
 						var states = model.attributes.states;
 						console.log(_this);
 						_this.Model.fetch({
		 					success:function(model,resp){
		 						var templateData = model.attributes;

		 						//handle the admin template naming conventions
		 						if(typeof(templateData.customer) !== 'undefined') templateData.enduser = templateData.customer;

		 						templateData.states = states;
		 						var editTemplate = _.template($('#' + _this.modelName.toLowerCase() + '-edit-form').html());
		 						$(_this.el).html(editTemplate(model.attributes));
		 						$(_this.el).prepend(_this.editableSaveIcon);
		 						$(_this.el).find('.save-editable').on('click',function(e){
		 							_this.onSave(e);
		 						})
		 					},
		 					error:function(model,err){
		 						console.log(err);
		 					}
		 				});		
 					}
 				})
 				
 			}

 			,onSave:function(btn){
 				var _this = this;
 				$('.save-editable',_this.el).find('.icon').removeClass('icon-save').addClass('icon-spin icon-spinner');
 				
				var $form = $('[name="'+_this.modelName.toLowerCase()+'-edit-form"]',_this.el);
				var formData = $form.serializeArray();
				var formData = _this.serializedFormToObject(formData);
                console.log("Form Data:");
                console.log(formData);
			
 				_this.Model.save(formData,{
 					patch:true,
 					success:function(model,resp){
 						_this.renderEdited(model);
 					},
 					error:function(model,err){
 						console.log(err);
 					}
 				})

 			}

 			,serializedFormToObject: function(data) {
                var obj = {};
                for (var i in data) {
                    if (typeof obj[data[i].name] === "undefined" || obj[data[i].name].length === 0) {
                        obj[data[i].name] = data[i].value;
                    } else {
                        obj[data[i].name] = obj[data[i].name] + "," + data[i].value;
                    }
                }
                return obj;

            }
            
            ,getModelName: function(classification){
                var _this = this;

                switch(classification){
                    case "Installer":
                    case "Servicer":
                    case "Dealer":
                        //set our global sync value
                        _this.syncSiblings = true;
                        return "Dealer";
                        break;
                    default:
                        return _this.classification;
                        break;
                }

            }
            

        });

        return Editable;
    }
);		