/**
* This is the Backbone View extension for MyView
**/
define([
    'Backbone',
    'moment',
    'model/Claim',
    'view/widgets/comments',
    'view/widgets/editable'
],  function(
            Backbone,
            moment,
            ModelClaims,
            Comments,
            Editable
        ){
        'use strict';
        var View = Backbone.View.extend({
            el:".claim-detail"

            ,events:{
                "click .claim-approval":"onChangeClaimStatus"
            }

            /**
			* ----------------------------------------------
			* Initializes this view
			* ----------------------------------------------
			*/
            ,initialize:function(){
                var _this = this;
                if(typeof($(_this.el).attr('data-claim-id')) === 'undefined'){
                	return this;
                } else {
                	return this.setupDefaults().setupSelectors().render();
                }
            }

            /**
			* ----------------------------------------------
			* Caches the selectors that are used more than once
			* ----------------------------------------------
			*/
            ,setupSelectors:function(){

                this.setupExternalSelectors();

                return this;
            }

            /**
            * Binds selectors outside of this.el
            **/
            ,setupExternalSelectors : function(){
                var _this = this;
                //Control Buttons
                var $controls = $('#detail-controls');
                $('.edit-registration',$controls).bind('click',_this.onEditClaim);
                $('.comment-add',$controls).bind('click',_this.onControlSelectComment);
                $('.print-page',$controls).bind('click',_this.onPrint);
                $('.archive-registration',$controls).bind('click',_this.onSelectArchiveClaim);
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
            ,render:function(claimId,el){
            	var _this = this;
            	if(typeof(el) === 'undefined') el = _this.el;
            	var $container = $(_this.el);
            	if(typeof(claimId) === 'undefined') claimId = $container.attr('data-claim-id');

            	ModelClaims.clear().set('id',claimId).fetch({
            		success:function(data){
            			data.attributes.moment = moment;
            			var claimTemplate = _.template($("#claim-detail-template").html());
            			$container.html(claimTemplate(data.attributes));
                        _this.renderComments();
                        _this.renderEditables();
                        _this.renderUIElements();
            		},
            		error: function(err){
            			console.log(err);
            		}
            	});

                return this;
            }
            
            /**
			* ----------------------------------------------
			* Renders the default UI elements
			* ----------------------------------------------
			*/
            ,renderUIElements:function($scope){
                var _this = this;
                if(typeof($scope) === 'undefined') $scope = $(_this.el);
                $('[data-toggle="tooltip"]',$scope).tooltip();
                $('[data-toggle="popover"]',$scope).popover();
            }

            ,renderEditables:function(){
                var _this = this;
                $('.editable',$(_this.el)).each(function(){
                    var $editable = $(this);
                    if( !$editable.attr('data-classification') ){
                        console.log('No Classification for Element Found.  Could not make editable');
                    } else {
                        console.log('Found Editable');
                        var classification = $editable.attr('data-classification');
                        var classprefix = classification.toLowerCase();
                        var $container = $('[data-' + classprefix + '-id]');
                        if($container.length > 0 ){
                            var Editor = new Editable($container,classification);
                            if(Editor) console.log('Editable ' + classification + ' Initialized!');
                        }
                    }

                })
            }

            ,renderComments:function(){
                var _this = this;
                _this.CommentsView = new Comments('Claim',$(_this.el).attr('data-claim-id'));
                
            }

            /**
 			* ----------------------------------------------
 			* Events
 			* ----------------------------------------------
 			*/

            ,onPrint:function(e){
                window.print()
            }

            ,onEditClaim:function(e){


            }
            
            ,onControlSelectComment:function(e){
                $('button.add-new-comment').click();
            }

            ,onSelectArchiveClaim:function(e){

            }

            ,onChangeClaimStatus:function(e){
                var _this = this;
                var $selector = $(e.currentTarget);
                var statusCode = $selector.attr('data-claim-status');
                ModelClaims.save({"status":statusCode},{
                    success:function(model,resp){
                        _this.render();
                    },
                    error:function(model,err){
                        console.log(err);
                    }
                });
            }
            
            

        });

        return new View;
    }
);		