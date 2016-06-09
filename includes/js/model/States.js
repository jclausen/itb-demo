/**
* This is the Backbone Model for myModel
**/
define([
    'Backbone'
],  function(
            Backbone
        ){
        'use strict';
        var Model = Backbone.Model.extend({
            urlRoot: '/api/v1/states',
            defaults:{}
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