/**
* This is the Backbone View extension for the event Dashboard.index
**/
define([
    'Backbone'
],  function(
            Backbone
        ){
        'use strict';
        var View =  Backbone.View.extend({
            el:"body.ra-enabled"

            ,events:{

            }
            /**
			* ----------------------------------------------
			* Initializes this view extension
			* ----------------------------------------------
			*/
            ,initialize:function(){
                this.setupDefaults().setupSelectors().render();
                return this;
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

                return this;
            }
            
            /**
 			* ----------------------------------------------
 			* Events
 			* ----------------------------------------------
 			*/
            
                       

        });
        
        return new View;
    }
);