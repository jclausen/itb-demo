/**
* This is the Backbone View extension for Claim.index
**/
define([
    'Backbone',
    'view/widgets/registration.list'
],  function(
            Backbone,
            ListWidget
        ){
        'use strict';
        var View = Backbone.View.extend({
            el:".content"
            ,events:{

            }

            /**
			* ----------------------------------------------
			* Initializes this view
			* ----------------------------------------------
			*/
            ,initialize:function(){
                return this.setupDefaults().setupSelectors().render();
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