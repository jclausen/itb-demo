/**
* This is the Backbone View extension for MyView
**/
define([
    'Backbone',
    'moment',
    'model/Registration',
    'view/widgets/comments',
    'view/widgets/editable'
],  function(
            Backbone,
            moment,
            ModelRegistrations,
            Comments,
            Editable
        ){
        'use strict';
        var View = Backbone.View.extend({
            el:".registration-detail"

            ,events:{
                
            }

            /**
			* ----------------------------------------------
			* Initializes this view
			* ----------------------------------------------
			*/
            ,initialize:function(){
                var _this = this;
                if(typeof($(_this.el).attr('data-registration-id')) === 'undefined'){
                	return this;
                } else {
                	return this.setupDefaults().setupSelectors().render();
                }
            }

            /**
			* ----------------------------------------------
			* Caches the selectors that are used more than once
			* ----------------------------------------------
			*/
            ,setupSelectors:function(){
                this.setupExternalSelectors();

                return this;
            }

            /**
            * Binds selectors outside of this.el
            **/
            ,setupExternalSelectors : function(){
                var _this = this;
                //Control Buttons
                var $controls = $('#detail-controls');
                $('.edit-registration',$controls).bind('click',_this.onEditRegistration);
                $('.comment-add',$controls).bind('click',_this.onControlSelectComment);
                $('.print-page',$controls).bind('click',_this.onPrint);
                $('.archive-registration',$controls).bind('click',_this.onSelectArchiveRegistration);
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
            ,render:function(registrationId,el){
            	var _this = this;
            	if(typeof(el) === 'undefined') el = _this.el;
            	var $container = $(_this.el);
                
            	if(typeof(registrationId) === 'undefined') registrationId = $container.attr('data-registration-id');

            	ModelRegistrations.clear().set('id',registrationId).fetch({
            		success:function(data){
            			data.attributes.moment = moment;
            			var registrationTemplate = _.template($("#registration-detail-template").html());
            			$container.html(registrationTemplate(data.attributes));
                        _this.renderComments();
                        _this.renderEditables();
                        _this.renderUIElements();
            		},
            		error: function(err){
            			console.log(err);
            		}
            	});

                return this;
            }
            
            /**
			* ----------------------------------------------
			* Renders the default UI elements
			* ----------------------------------------------
			*/
            ,renderUIElements:function($scope){
                var _this = this;
                if(typeof($scope) === 'undefined') $scope = $(_this.el);
                $('[data-toggle="tooltip"]',$scope).tooltip();
                $('[data-toggle="popover"]',$scope).popover();
            }

            ,renderEditables:function(){
                var _this = this;
                $('.editable',$(_this.el)).each(function(){
                    var $editable = $(this);
                    if( !$editable.attr('data-classification') ){
                        console.log('No Classification for Element Found.  Could not make editable');
                    } else {
                        console.log('Found Editable: '+ $editable.attr('data-classification'));
                        var classification = $editable.attr('data-classification');
                        var classprefix = classification.toLowerCase();
                        var $container = $('[data-' + classprefix + '-id]');
                        if($container.length > 0 ){
                            $container.each(function(){
                                var $editableRegion = $(this);
                                var Editor = new Editable($editableRegion,classification);
                               if(Editor) console.log('Editable ' + classification + ' Initialized!');
                            })
                        }
                    }

                })
            }

            ,renderComments:function(){
                var _this = this;
                _this.CommentsView = new Comments('Registration',$(_this.el).attr('data-registration-id'));
                
            }

            /**
 			* ----------------------------------------------
 			* Events
 			* ----------------------------------------------
 			*/

            ,onPrint:function(e){
                window.print()
            }

            ,onEditRegistration:function(e){


            }
            
            ,onControlSelectComment:function(e){
                $('button.add-new-comment').click();
            }

            ,onSelectArchiveRegistration:function(e){

            }
        });

        return new View;
    }
);		