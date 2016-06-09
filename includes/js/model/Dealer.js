/**
* This is the Backbone Model for Dealers/Installers/Servicers
**/
define([
    'Backbone'
],  function(
            Backbone
        ){
        'use strict';
        var Model = Backbone.Model.extend({
            urlRoot: '/api/v1/dealers',
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