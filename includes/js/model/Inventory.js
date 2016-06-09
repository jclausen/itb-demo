/**
* This is the Backbone Model for Inventory Items
**/
define([
    'Backbone'
],  function(
            Backbone
        ){
        'use strict';
        var Model = Backbone.Model.extend({
            //our urlRoot needs to be set in init
            //urlRoot: '/api/v1/products/:id/inventory',
            defaults:{
                "limit":25,
                "offset":0
            }
            /**
			* ----------------------------------------------
			* Initializes this model
			* ----------------------------------------------
			*/
            ,initialize:function(productId){
            	var _this  = this;
            	_this.urlRoot = '/api/v1/products/'+productId+'/inventory'
                return this;
            }            

        });

        return Model;
    }
);		