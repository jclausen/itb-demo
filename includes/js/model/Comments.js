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
            urlRoot: '/api/v1/comments',
            defaults:{}
            /**
			* ----------------------------------------------
			* Initializes this model
			* ----------------------------------------------
			*/
            ,initialize:function(ModelName,ModelId){
            	var _this = this;
            	_this.set('modelName',ModelName);
            	_this.set('modelId',ModelId);
                //FIXME (this adding an 's' is janky)
            	_this.urlRoot='/api/v1/' + ModelName.toLowerCase() + 's/comments';
            	_this.set('id',ModelId);
                return this;
            }

            //overload to clear to ensure id persists
            ,clear:function(){
                var _this = this;
                var ModelId = _this.get('modelId');
                var ModelName = _this.get('modelName');
                
                // Call to the original clear function
                Backbone.Model.prototype.clear.call(this);

                // Now re-initialize
                return _this.initialize(ModelName,ModelId);
            }

            ,destroy:function(attrs,options){
                var _this = this;
                
                var ModelId = _this.get('modelId');
                var ModelName = _this.get('modelName');

                if(typeof(attrs.data) === 'undefined' || typeof(attrs.data.commentId) === 'undefined'){
                    console.log("No commentId value was specified for deletion.  Is your casing correct?");
                    return _this;
                } else {
                    //temporarily set our id as the commentid
                    _this.set('id',attrs.data.commentId);
                    Backbone.Model.prototype.destroy.call(this, {
                        success:function(model,response){
                            //respond with a re-init
                            return attrs.success(_this.initialize(ModelName,ModelId),response)
                        },
                        error: attrs.error ? attrs.error : function(model,response){
                            console.log(model);
                            console.log(response);
                        }
                    }, options);
                }
            }            



        });

        return Model;
    }
);		