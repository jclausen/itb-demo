/**
* This is the Backbone View extension for all events in the Dashboard Handler
**/
define([
    'Backbone',
    'model/Registration',
    'moment'
],  function(
            Backbone,
            ModelRegistrations,
            moment
        ){
        'use strict';
        var View = Backbone.View.extend({
            el:"#registrations-data"

            ,events:{
                "click .registration-list-actions .registration-approval":"onChangeRegistrationStatus",
                "keyup #registrations_filter [type='text']":"onFilterSearch",
                "click #registrations-table th.sortable":"onSortResults",
                "click #registrations_filter .icon-undo":"onResetSearch"
            }
            //A few reusable display objects
            ,weeSpinner:'<i class="icon icon-spin icon-spinner" style="text-decoration:none!important"></i>'
            
            /**
			* ----------------------------------------------
			* Initializes this view
			* ----------------------------------------------
			*/

            ,initialize:function(listLimit){
                var _this = this;
                //the default number of records to fetch
                if(typeof(listLimit) !== 'undefined'){
                    _this.limit = listLimit;
                } else if(typeof(_this.limit) === 'undefined') {
                    _this.limit = 25;
                }
                ModelRegistrations.clear().fetch({
                    data:{"limit":_this.limit},
                    success:function(data){
                        return _this.setupDefaults().render(data.attributes);
                    },
                    error:function(){
                        $(_this.el).html('<p class="alert alert-danger">There was an error loading the registrations data from the API.  Please reload this page.</o>');
                    }
                })
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
            ,render:function(data,cb){
                var _this = this;
                var resultsTable = _.template($('#registrations-table-content').html());
                $(_this.el).html(resultsTable({}));
                var $resultsBody = $('#registrations-table tbody');
                //now load our list
                _.each(data.registrations,function(registration){
                    
                    _this.renderDataRow(registration,$resultsBody);

                });

                _this.setupPaging(data);
                _this.renderUIElements();

                if(typeof(cb) === 'undefined'){
                    return _this;   
                }  else {
                    return cb();
                }
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

            ,renderDataRow: function(registration,$resultsBody){
                    var resultsItemRow = _.template($('#registrations-table-datarow').html());
                    if(typeof($resultsBody) === 'undefined'){
                        return resultsItemRow({"registration":registration,"moment":moment});
                    } else {
                        $resultsBody.append(resultsItemRow({"registration":registration,"moment":moment}));    
                    }
                    
            }

            ,setupPaging: function(pagingData){
                // var filter = 
            }
            
            /**
 			* ----------------------------------------------
 			* Events
 			* ----------------------------------------------
 			*/
            ,onSortResults : function(e){
                var _this = this;
                var $header = $(e.currentTarget);
                $header.append(_this.weeSpinner);
                var sort = $header.attr('data-sort');
                var order = $header.attr('aria-sort');
                //handle our ordering switches
                if(typeof(order) === 'undefined' || order === 'descending'){
                    order='ascending'
                } else{
                    order='descending';
                }

                var sortData = {"sort":sort,"order":order};
                ModelRegistrations.clear().fetch({
                    data:sortData,
                    success:function(data){
                        _this.render(data.attributes,function(){
                            _this.setSortAssignments(sortData);
                        });
                    },
                    error:function(err){
                        console.log(err);
                    }
                });

            }
            ,onResetSearch :function(e){
                var $btn = $(e.currentTarget);
                $btn.removeClass('icon-undo').addClass('icon-spin icon-spinner');
                this.initialize();
            }

            ,onFilterSearch : function(e){
                var $input = $(e.currentTarget);

                var keycode = e.which;
                if(keycode==13 && !e.shiftKey) {
                    this.onSearchRegistrations($input.val());
                }

            }

            ,onSearchRegistrations : function(search){
                var _this = this;
                $("#registrations_filter input").before(_this.weeSpinner);
                ModelRegistrations.clear();
                ModelRegistrations.fetch({data:{"search":search},
                    success:function(data){
                        $("#registrations_filter .icon-spin").remove();
                        _this.render(data.attributes);
                    },
                    error:function(err){
                        console.log(err);
                    }
                });


            }


            ,onChangeRegistrationStatus:function(e){
                var $selector = $(e.currentTarget);
                $selector.closest('.btn-group').find('i.icon-gears').removeClass('icon-gears').addClass('icon-gear').addClass('icon-spin');
                if(parseInt($selector.attr('data-registration-status')) < 4){
                    this.onIncrementStatus(e);
                } else {
                    this.onDecrementStatus(e);
                }
            }
            ,onIncrementStatus: function(e){
                var $selector = $(e.currentTarget);
                var $dataRow = $selector.closest('.registration-data-row');
                var registrationStatus = parseInt($selector.attr('data-registration-status'));
                this.onUpdateStatus($dataRow,registrationStatus+1);
            }

            ,onDecrementStatus: function(e){
                var $selector = $(e.currentTarget);
                var $dataRow = $selector.closest('.registration-data-row');
                var registrationStatus = parseInt($selector.attr('data-registration-status'));
                this.onUpdateStatus($dataRow,registrationStatus-2);
            }

            ,onUpdateStatus: function($dataRow,statusCode){
                var _this = this;
                var registrationId = $dataRow.attr('data-registration-id');
                if(registrationId){
                    ModelRegistrations.clear().set('id',registrationId);
                    ModelRegistrations.save({"status":statusCode},{
                        success:function(data){
                            if(typeof(data) !== 'undefined') $dataRow.replaceWith(_this.renderDataRow(data.attributes.registration));
                        },
                        error:function(err){
                            console.log(err);
                        }
                    });
                }

            }

            ,onViewRegistrationDetail: function(e){
                var $dataRow = $(e.currentTarget).closest('.registration-data-row');
                var registrationId = $dataRow.att('data-registration-id');
                window.location.assign('/registration/detail/id/'+registrationId);
            }
            

            /**
 			* ----------------------------------------------
 			* DOM Utility Methods
 			* ----------------------------------------------
 			*/
            ,setSortAssignments:function(sortConfig){
                var _this = this;
                var $sortHeaders = $('#registrations-table thead th.sortable');
                $sortHeaders.each(function(){
                    var $header = $(this);
                    if($header.attr('data-sort') === sortConfig.sort){
                        $header.attr('aria-sort',sortConfig.order);
                        $header.addClass('text-primary');
                        if(sortConfig.order === 'descending'){
                            $header.removeClass('sorting').addClass('sorting_desc');
                        } else {
                            $header.removeClass('sorting').addClass('sorting_asc');
                        }
                    } else {
                        $header.removeAttr('aria-sort').removeClass('sorting_desc').removeClass('sorting_asc').addClass('sorting');
                    }
                })
            }

        });

        return new View;
    }
);