/**
* This is the Backbone View extension for Claims export
**/
define([
    'Backbone',
    'datepicker'
],  function(
            Backbone,
            datepicker
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
                return this.setupSelectors().setupDefaults().render();
            }

            /**
            * ----------------------------------------------
            * Caches the selectors that are used more than once
            * ----------------------------------------------
            */
            ,setupSelectors:function(){
            	$('.datepicker').each(function(){
            		$(this).datepicker();
            	})

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