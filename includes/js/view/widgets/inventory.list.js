/**
* This is the Backbone View widget for Inventory Item Lists
**/
define([
    'Backbone',
    'model/Inventory',
    'model/Distributor',
],  function(
            Backbone,
            InventoryModel,
            DistributorModel
        ){
        'use strict';
        var Widget = Backbone.View.extend({
            el:"#inventory-table tbody.inventory-list"

            ,events:{
            	"click .edit-item":"onInventoryItemEditStart",
            	"click .save-editable":"onInventoryItemSave"
            }

            /**
			* ----------------------------------------------
			* Initializes this view
			* ----------------------------------------------
			*/
            ,initialize:function(productId){
            	var _this = this;
            	if(typeof(productId) === 'undefined'){
            		return this;
            	} else {
            		_this.Model = new InventoryModel(productId);
            		_this.rowTemplate = _.template($("#inventory-list-row-template").html());
            		_this.rowEditTemplate = _.template($("#inventory-list-row-edit-form").html());
	                return _this.setupDefaults().setupSelectors().render();	
            	}
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
                var _this = this;
                DistributorModel.fetch({
                    success:function(model,resp){
                        window.distributors = model.attributes.distributors;
                        return _this;
                    },error:function(model,err){

                        console.log("Distributor Fetch Error:");
                        console.log(err);

                        return _this;
                    }
                });
                return this;
            }

            /**
 			* ----------------------------------------------
 			* Renders UI
 			* ----------------------------------------------
 			*/
            ,render:function(){
            	var _this = this;
                //add a loader to our table since assembling inventory items is fairly expensive
                $(_this.el).append('<tr class="loader"><td colspan="5" align="center" class="text-muted"><p>Loading product inventory...</p><i class="icon icon-spin icon-spinner icon-3x"></i></td></tr>');

            	_this.Model.clear().fetch({

            		success:function(model,resp){
                        $('tr.loader',_this.el).remove();
            			var inventory = model.attributes.inventory;
            			if(inventory.length === 0){

                            $(_this.el).append('<tr class="loader"><td colspan="5" align="center"><div class="alert alert-info"><i class="icon-exclamation-sign"></i>This product does not have any inventory.</div></td></tr>');                            
                        }
                        for(var i in inventory){
            				var templateData = {"item":inventory[i]};
            				$(_this.el).append(_this.rowTemplate(templateData));
            			}
                        setTimeout(function(){
                            _this.renderUIElements($(_this.el));
                        },400)

            		},

            		error:function(model,err){
            			console.log("Inventory Fetch Error:");
            			console.log(err);
            		}
            	})

                return this;
            }
            ,renderUIElements:function($scope){
                var _this = this;
                if(typeof($scope) === 'undefined') $scope = $(_this.el);
                $('[data-toggle="tooltip"]',$scope).tooltip();
                $('[data-toggle="popover"]',$scope).popover();
            }
            
            /**
 			* ----------------------------------------------
 			* Events
 			* ----------------------------------------------
 			*/
 			,onInventoryItemEditStart: function(e){
                var _this = this;
 				var $btn = $(e.currentTarget);
                $('.icon',$btn).removeClass('icon-pencil').addClass('icon-spin icon-spinner');
 				var $row = $btn.closest('.inventoryitem-data-row');
 				var itemId = $row.attr('data-item-id');
 				_this.Model.clear().set('id',itemId);
 				_this.Model.fetch({
 					success:function(model,resp){
 						var templateData = model.attributes;
 						$row.replaceWith(_this.rowEditTemplate(templateData));
                        _this.renderUIElements($('[data-item-id="' + itemId + '"]',_this.el));
 					},
 					error:function(model,err){
            			console.log("Inventory Item Fetch Error (onInventoryItemEditStart):");
            			console.log(err);

 					}
 				})
 			}
            ,onInventoryItemSave: function(e){
                var _this = this;
            	var $btn = $(e.currentTarget);

                $('.icon-save',$btn).removeClass('icon-save').addClass('icon-spin icon-spinner');

 				var $row = $btn.closest('.inventoryitem-data-row');
 				var itemId = $row.attr('data-item-id');
 				var formData = {
                    "SerialNumber":$('[name="SerialNumber"]',$row).val(),
                    "Distributor":$('[name="Distributor"]',$row).val()
                };
                console.log(formData);
 				_this.Model.clear().set('id',itemId);
 				_this.Model.save(
 					formData,
 					{
 					patch:true,
 					success:function(model,resp){
 						var templateData = model.attributes;
 						$row.replaceWith(_this.rowTemplate(templateData));
                        _this.renderUIElements($('[data-item-id="' + itemId + '"]',_this.el));
 					},
 					error:function(model,err){
            			console.log("Inventory Item Fetch Error (onInventoryItemSave):");
            			console.log(err);

 					}
 				})
            }
            

        });

        return Widget;
    }
);		