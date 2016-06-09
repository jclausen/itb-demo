/**
* This is the Backbone Model for Products
**/
define([
    'Backbone'
],  function(
            Backbone
        ){
        'use strict';
        var Model = Backbone.Model.extend({
            urlRoot: '/api/v1/products',
            defaults:{
                "limit":25,
                "offset":0
            }
            /**
			* ----------------------------------------------
			* Initializes this model
			* ----------------------------------------------
			*/
            ,initialize:function(){
                return this;
            }            

        });

        return new Model;
    }
);		