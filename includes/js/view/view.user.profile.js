/**
* This is the Backbone View extension for User profiles
**/
define([
    'Backbone',
    'model/User',
    'model/Roles',
    'view/widgets/editable',
    'bootbox'
],  function(
            Backbone,
            ModelUsers,
            ModelRoles,
            Editable,
            bootbox
        ){
        'use strict';
        var View = Backbone.View.extend({
            el:"#user-profile"

            ,events:{

                "click a.edit-user":"onEditStart",
                "click button#deleteUser":"onInitiateDelete"

            }

            /**
			* ----------------------------------------------
			* Initializes this view
			* ----------------------------------------------
			*/
            ,initialize:function(){
            	var _this = this;
                ModelRoles.fetch({
                    success:function(model,resp){
                        
                        window.roles = model.attributes.roles;
                        if(!$(_this.el).attr('data-user-id')) return;
                        _this.Model = ModelUsers.set('id',$(_this.el).attr('data-user-id'));

                        return _this.setupDefaults().setupSelectors().render();
 
                    },
                    error:function(model,err){
                        console.log(err);
                        return;
                    }
                })
            }

            /**
			* ----------------------------------------------
			* Caches the selectors that are used more than once
			* ----------------------------------------------
			*/
            ,setupSelectors:function(){

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
            	var _this = this;
            	_this.Model.fetch({
            		success:function(model,resp){
            			var templateData = model.attributes;
            			var template = _.template($('#user-detail-template').html())
            			$(_this.el).html(template(templateData));
            			//if editable
            			if($('a.edit-user',$(_this.el)).length > 0){
            				_this.renderEditable();
            			}
            		},
            		error: function(model,resp){
            			console.log(resp);
            		}
            	})

                return this;
            }

            ,renderEditable:function(){
                var _this = this;
                $('.editable',$(_this.el)).each(function(){
                    var $editable = $(this);
                    if( !$(_this.el).attr('data-classification') ){
                        console.log('No Classification for Element Found.  Could not make editable');
                    } else {
                        console.log('Found Editable');
                        var classification = $(_this.el).attr('data-classification');
                        console.log("Classification:"+classification);
                        var classprefix = classification.toLowerCase();
                        var Editor = new Editable($(_this.el),classification,false);
                        _this.Editor = Editor;
                    }

                });
            }
            
            /**
 			* ----------------------------------------------
 			* Events
 			* ----------------------------------------------
 			*/
            ,onEditStart:function(e){
                var $btn = $(e.currentTarget);
                $('.icon-pencil',$btn).removeClass('icon-pencil').addClass('icon-spin icon-spinner');
                return this.Editor.onEditStart(e);
            }

            ,onInitiateDelete:function(e){
                var _this = this;
                var $btn = $(e.currentTarget);
                var box = bootbox.dialog({
                    title:'Confirm User Deletion'
                    ,message: '<p class="alert alert-danger"><storng>WARNING:</strong> You are about to permanently delete this user account.  Are you sure you want to do this?</p>'
                    ,onEscape: function(){ bootbox.hideAll() }
                    ,buttons: {
                        error: {
                            label: 'Cancel',
                            className: 'btn btn-warning',
                            callback: function(){
                                return true;
                            }
                        },
                        success: {
                            label: 'Delete User',
                            className: 'btn btn-danger',
                            callback: function(){
                                _this.onConfirmDelete(e);
                            }
                        }
                    }
                });
            }
            ,onConfirmDelete:function(e){
                var _this = this;
                _this.Model.destroy({
                    success:function(model,resp){
                        $.get('/api/v1/flash/message',{"message":"User successfully deleted"},function(data){
                            location.assign('/user/index');  
                        });
                    },
                    error:function(model,err){
                        console.log(err);
                    }
                });
            }
            

        });

        return new View;
    }
);		