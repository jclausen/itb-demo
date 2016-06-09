define([
    'Backbone'
],  function(
            Backbone
        ){
        'use strict';
        var App =  Backbone.View.extend({
            el: 'body'
            
            ,events:{

            }

            /**
			* ----------------------------------------------
			* Initializes professional development
			* ----------------------------------------------
			*/
            ,initialize:function(){
                var bigLoaderCircle = '<div class="centered"><i class="icon icon-spin icon-circle-o-notch icon-5x text-muted"></i></div>';
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
        return new App;
    }
);
