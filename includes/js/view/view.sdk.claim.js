/**
* This is the Backbone View extension for the event Dashboard.index
**/
define([
    'Backbone',
    'datepicker',
    'theme/fuelux.wizard',
    'view/widgets/country.select'
],  function(
            Backbone,
            datepicker,
            fuelux,
            CountrySelects
        ){
        'use strict';
        var View =  Backbone.View.extend({
            el:"section#suretix-claim"
            ,events:{
                "change input#SerialNumber":"onValidateSerialNumber",
                "click #btnAdvanceClaim.advance":"onAdvanceClaim",
                "click #btnAdvanceClaim.confirmation":"onSubmitClaim",
                "click #btnReverseClaim":"onReverseClaim",
                "click #btnAutoFill":"onAutoFillSelect",
                "click #btnCancelAutoFill":"onAutoFillDecline"
            }
            ,autoFillTemplate:'<div id="autoFillNotice" class="alert alert-info margin-bottom-30" style="display:none; margin-top: 20px">\
                                <p>Existing registration information was found for this serial number.  Would you like to use the registration information for this claim?</p>\
                                <p class="text-center">\
                                    <a href="javascript:void(0)" id="btnAutoFill" class="btn-flat primary">Yes</a>\
                                    <a href="javascript:void(0)" id="btnCancelAutoFill" class="btn-flat danger">No</a>\
                                </p>\
                                </div>'
            /**
			* ----------------------------------------------
			* Initializes this view extension
			* ----------------------------------------------
			*/
            ,initialize:function(){
                var _this = this;
                _this.setupDefaults().then(function(){
                    return _this.setupSelectors().render();
                });
            }

            /**
			* ----------------------------------------------
			* Caches the selectors that are used more than once
			* ----------------------------------------------
			*/
            ,setupSelectors:function(){
                var _this = this;
                return _this;
            }

            /**
			* ----------------------------------------------
			* Setup some default variables to be used later
			* ----------------------------------------------
			*/
            ,setupDefaults:function(){
                var _this = this;
                if(typeof(window.STX_HTTP_SERVER) === 'undefined'){
                    window.STX_HTTP_SERVER = "";
                }
                _this.API_BASE_URI = window.STX_HTTP_SERVER+'/api/v1/';
                var promise = new Promise(function(resolve,reject){
                    //set our authentication headers
                    $.ajaxSetup({
                        beforeSend: function (xhr)
                        {
                           xhr.setRequestHeader("Authorization","STX-TOKEN "+window.STX_TOKEN);    
                        }
                    });
                    _this.templateData = {};
                    _this._marshallDefaultData().then(function(data){

                        $('#stx-reg-form.wizard').wizard();
                        resolve();

                    });
                });
                return promise;

            }

            /**
 			* ----------------------------------------------
 			* Renders UI
 			* ----------------------------------------------
 			*/
 
            ,render:function(){
                var _this = this;
                _this.renderUIElements();

                $('.step-pane').each(function(){
                    var $pane = $(this);
                    if(typeof($pane.attr('data-content-id')) !== 'undefined'){
                        //customize our fields
                        _this.templateData.questionsTitle = "Explanation of Failure";
                        switch($pane.attr('data-content-id')){
                            case "claim-servicer":
                                _this.templateData.title="Product Servicer Information";
                                _this.templateData.intro="";
                                _this.templateData.classification="Servicer";
                                break;
                            case "claim-customer":
                                _this.templateData.title="End User / Customer Information";
                                break;
                            default: 
                                delete _this.templateData.title;
                                if(typeof(_this.templateData.intro) !== 'undefined') delete _this.templateData.intro;
                                if(typeof(_this.templateData.classification) !== 'undefined') delete _this.templateData.classification;
                                break;
                        }
                        var paneContent = _.template($('#'+$pane.attr('data-content-id')).html());
                        var content = paneContent(_this.templateData);
                        var $contentArea = $pane.find('.pane-content'); 
                        $contentArea.html(content);
                        $contentArea.find('.form-group').each(function(){
                            $(this).addClass('field-box')
                            if($(this).is('.country')){

                                var countrySelect = new CountrySelects($(this),function(cs){

                                    //after we have our template data for the states, populate our all states select
                                    if($('[name="InstallState"]',_this.el).find('options').length === 0) countrySelect.renderStateSelect($("select#InstallState"),"all");
                                
                                });
                               
                            }
                        });
                        _this.markRequiredFields($contentArea);
                        _this.renderUIElements($contentArea);
                    }
                });

                return this;
            }

            ,renderAutoFillOptions:function(){
                var _this = this;
                var $group = $('[name="InstallDate"]').closest('.form-group');
                $group.append(_this.autoFillTemplate);
                $("#autoFillNotice").fadeIn('400');
            }
            
            /**
 			* ----------------------------------------------
 			* Events
 			* ----------------------------------------------
 			*/
            ,onValidateSerialNumber:function(e){
                var _this = this;
                var $snField = $(e.currentTarget);
                if($snField.val().length > 0){
                    var productId = $('[name="ModelNumber"]',_this.el).val();
                    $.get(_this.API_BASE_URI+'products/'+productId+'/inventory/'+$snField.val())
                        .done(function(data){
                            _this.renderValidField($snField,'Your serial number is valid.  Please continue with claim.');
                            $('#btnAdvanceClaim').prop('disabled',false);
                            if(typeof(data.item.registration) !== 'boolean'){
                                _this.validatedItem = data.item;
                            }
                        })
                        .fail(function(data){
                            _this.renderInvalidField($snField);
                            $('#btnAdvanceClaim').prop('disabled',true);
                        });
                } else {
                    _this.renderInvalidField($snField);
                    $('#btnAdvanceClaim').prop('disabled',true);
                }
                

            }

            ,onAdvanceClaim:function(e){
                var _this = this;
                e.preventDefault();
                var $btn = $(e.currentTarget);
                _this.onValidateClaimForm(e);
            }

            ,onReverseClaim:function(e){
                if($("#btnAdvanceClaim").hasClass('confirmation')) $("#btnAdvanceClaim").removeClass('confirmation').addClass('advance');
                $('#stx-reg-form.wizard').wizard('previous');
            }

            ,onValidateClaimForm:function(e,data){
                e.preventDefault();
                var _this = this;
                var $btn = $(e.currentTarget);
                var $activePane = $('.step-pane.active',_this.el);
                if($btn.hasClass('advance')){
                    var scope = $activePane;
                } else {
                    var scope = $('form#stx-reg-form');
                }               
                //validate all required fields
                var validation = new Promise(function(resolve,reject){
                    $('.req input',scope).each(function(){
                        var fieldIsValid = true;
                        var $field = $(this);
                        var $formGroup = $field.closest('.form-group');
                        var $pane = $formGroup.closest('pane');
                        var inputType = $field.attr('type');
                        switch(inputType){
                            case "radio":
                                var fieldName = $field.attr('name');
                                if($('[name="'+fieldName+'"]:checked').length === 0) fieldIsValid=false;
                                break;
                            case "text":
                                if($field.val().trim().length === 0) fieldIsValid = false;
                                break;

                        }
                        if(!fieldIsValid){
                            return reject($field);
                        }
                    }).promise().done(function(){
                        return resolve();
                    });

                });
                
                return validation
                    .then(
                        //resolved
                        function(){
                            _this.renderStepsButtonProgress($btn);
                            return true;
                        }
                    ).catch(function($field){
                        _this.onFieldValidationFail($field);
                        return false;
                    });
            }

            ,onSubmitClaim: function(e){
                var _this = this;
                var $btn = $(e.currentTarget);
                var defaultBtnText = $btn.html();
                $btn.html('Processing Claim <i class="fa fa-gears fa-spin"></i>');
                //prevent a double-click
                $btn.prop('disabled',true);
                var postData = _this._marshallClaimData();

                $.post(_this.API_BASE_URI+'claims',postData)
                    .done(function(data){
                        if(typeof(data.claim) !== 'undefined'){

                            //hide our buttons, as we're now complete
                            $btn.addClass('hide').prop('disabled',true);
                            $("#btnReverseClaim").addClass('hide').prop('disabled',true);
                            
                            //add our confirmation step information
                            $('.step-pane.claim-confirmation .pane-title').html('<h2>Claim Received</h2>')
                            var $contentArea = $('.step-pane.claim-confirmation .pane-content');
                            var confirmationData = _.clone(_this.templateData);
                            confirmationData.claim = data.claim;
                            var confirmationTemplate = _.template($("#claim-confirmation").html());  
                            $contentArea.html(confirmationTemplate(confirmationData));
                            $contentArea.find('.form-group').each(function(){$(this).addClass('field-box')});
                            _this.markRequiredFields($contentArea);
                            _this.renderUIElements($contentArea);
                            $('#stx-reg-form').wizard('next');

                            $('#stx-reg-form ul.steps').find('li').each(function(){
                                var $step=$(this);
                                if($step.hasClass('active')){
                                    $step.removeClass('active').addClass('complete');
                                }
                            });

                        } else {

                            $btn.html(defaultBtnText);
                            $btn.prop('disabled',false);
                            _this.renderAPIResponseError(data);

                        }
                        
                    })
                    .fail(function(jqXHR){
                        $btn.html(defaultBtnText);
                        $btn.prop('disabled',false);
                        _this.renderAPIResponseError(jqXHR.responseJSON);
                    });
            }

            ,onChangeInstallDate:function(e){
                var _this = this;

                if(typeof(_this.validatedItem) === 'undefined') return;

                var $dateField = $(e.currentTarget);
                var inputDate = new Date($dateField.val());
                var installDate = new Date(this.validatedItem.installdate);

                if(
                    inputDate.getFullYear() === installDate.getFullYear() 
                    && 
                    inputDate.getDate() === installDate.getDate() 
                    && 
                    inputDate.getMonth() === installDate.getMonth()
                ){

                    _this.renderAutoFillOptions();

                }

            }

            ,onAutoFillSelect:function(e){
                var _this = this;
                if(typeof(_this.validatedItem) !== 'undefined'){
                    var item = _this.validatedItem;
                    var endUser = item.customer;
                    var installer = item.installer;
                    $('input,select').each(function(){
                        var $field = $(this);
                        var namePair = $field.attr('name').split('_');
                        switch(namePair[0]){
                            case "EndUser":
                                var key = namePair[1].toLowerCase();
                                if(typeof(endUser[key]) !== 'undefined' && endUser[key].length){
                                    $field.val(endUser[key]);
                                }
                                break;

                            case "Servicer":
                                var key = namePair[1].toLowerCase();
                                if(typeof(installer[key]) !== 'undefined' && installer[key].length){
                                    $field.val(installer[key]);
                                }
                                break;
                        }
                    });  

                    $("#autoFillNotice p.text-center").fadeOut('400',function(){$('#autoFillNotice p.text-center').remove()});
                    $("#autoFillNotice p:first-child").css('text-align','center').html('The available registration information has been populated to the form fields for the remaining steps');

                    setTimeout(function(){
                        $('#autoFillNotice').fadeOut('400',function(){$('#autoFillNotice').remove()});
                    },7000);
                }
            }


            ,onAutoFillDecline:function(e){
                $('#autoFillNotice').fadeOut('400',function(){$('#autoFillNotice').remove()});
            }

            ,renderStepsButtonProgress: function($btn){

                //advance steps
                if(!$(".step-pane").last().prev('.step-pane').is(":visible")) {
                    $('#stx-reg-form.wizard').wizard('next');
                    $(".step-pane:visible").find('input').first().focus();
                } else {                    
                    $btn.removeClass('advance').addClass('confirmation').click();   
                }
                
                //handle button
                if(!$(".step-pane").first().is(":visible")){
                    $("#btnReverseClaim").removeClass('hide').prop('disabled',false);
                } else {
                    $("#btnReverseClaim").addClass('hide').prop('disabled',true);
                }
            }

            ,renderAPIResponseError: function(response){
                // console.log("Reponse:");
                // console.log(response);

                $('button.confirmation').removeClass('confirmation').addClass('advance');

                if(typeof(response.error) === 'undefined'){
                    response.error = "An unexpected error occurred while transmitting to the API.  Please try again.";
                }
                var apiErrorTemplate =_.template($("#api-error").html()); 
                
                var templateData = {"errorMessage":response.error};
                if(typeof(response.errorDetail) !== 'undefined'){
                    templateData.errorDetail = response.errorDetail;
                }

                $('.submits').prepend(apiErrorTemplate(templateData));
                setTimeout(function(){
                    $('.alert.alert-danger',$('.submits')).fadeOut(300,function(){$('.alert.alert-danger',$('.submits')).remove()})
                },8000);
            }

            ,onFieldValidationFail:function($field){
                var _this = this;
                _this.renderInvalidField($field);
            }

            ,renderInvalidField:function($field,msg){
                $field.next('.alert-msg').remove();
                var $formGroup=$field.closest('.form-group');
                $formGroup.removeClass('success has-success').addClass('error has-error');
                $field.focus();
                if($field.attr('data-validation-message')){
                    var msg = $field.attr('data-validation-message');
                } else if(typeof(msg) === 'undefined') {
                    var msg = "We could not proceed as this field is required."
                }


                if($field.attr('type') === 'radio' || $field.attr('type') === 'checkbox'){
                    $formGroup.find('label').first().after('<div class="col-xs-12 alert-msg text-danger bg-danger"><i class="fa-close"></i> ' + msg + '</div>');
                    $formGroup.find('.alert-msg').find('i.fa-close').bind('click',function(){
                        $(this).css('cursor','pointer');
                        $formGroup.find('.alert-msg').fadeOut(300,function(){$field.next('.alert-msg').remove()});
                    });
                } else {
                    $field.after('<span class="alert-msg text-danger bg-danger"><i class="fa-close"></i> ' + msg + '</span>');
                    $field.next('.alert-msg').find('i.fa-close').bind('click',function(){
                        $(this).css('cursor','pointer');
                        $field.next('.alert-msg').fadeOut(300,function(){$field.next('.alert-msg').remove()});
                    });
                }
                setTimeout(function(){
                    if($formGroup.find('.alert-msg').length > 0){
                        $formGroup.find('span-alert-msg').fadeOut(300,function(){$formGroup.find('span-alert-msg').remove()});
                    }
                },8000)

            }

            ,renderValidField:function($field,msg){
                $field.next('.alert-msg').remove();
                var $formGroup=$field.closest('.form-group');
                $formGroup.removeClass('error has-error').addClass('success has-success');
                if(typeof(msg) !== 'undefined'){
                    $field.after('<div class="col-xs-12 alert-msg text-success bg-success"><i class="fa-check-circle"></i> ' + msg + '</div>');    
                }
            }

            ,markRequiredFields:function($area){
                if(typeof($area) === 'undefined') $area = $('body');
                var $indicator = $('.req-indicator').first();
                $('.form-group.req',$area).each(function(){
                    var $group = $(this);
                    if($group.find('label').length > 0){
                        $group.find('label').first().append($indicator[0].outerHTML);
                    }
                }) 
            }

            ,renderUIElements:function($scope){
                var _this = this;
                if(typeof($scope) === 'undefined') $scope = $(_this.el);
                $('input.input-datepicker,input.datepicker',$scope).datepicker(
                    {
                        todayBtn: "linked",
                        orientation: "top auto",
                        autoclose: true,
                        todayHighlight: true
                    }
                    ).on('changeDate',function(e) {
                        if($(e.currentTarget).is("#InstallDate")){
                           _this.onChangeInstallDate(e);
                        }
                    });
                $('[data-toggle="tooltip"]',$scope).tooltip();
                $('[data-toggle="popover"]',$scope).popover({
                    template: '<div class="popover" role="tooltip" style="min-width: 600px!important;"><div class="arrow"></div><h3 class="popover-title text-primary"></h3><div class="popover-content"><div class="data-content"></div></div></div>',
                    autoclose:true,
                    trigger:'hover'
                })
                
            }
                       
            /**
 			* ----------------------------------------------
 			* Private Methods
 			* ----------------------------------------------
 			*/
            ,_marshallDefaultData:function(){

                var _this = this;
                
                var promise = new Promise(function(resolve, reject){
                    _this.templateData.states = {};
                    //US States
                    $.get(_this.API_BASE_URI+'states/country/us',function(data){ 
                        _this.templateData.states=data.states;
                        //Canadian Provinces
                        $.get(_this.API_BASE_URI+'states/country/ca',function(data){
                            _this.templateData.provinces=data.states;
                            //get our claim questions
                            $.get(_this.API_BASE_URI+'claims/questions',function(data){
                                _this.templateData.questions=data.questions;
                                //wrap up with products and set our default settings
                                $.get(_this.API_BASE_URI+'products',function(data){
                                    _this.templateData.products=data.products;

                                     _this.templateData["settings"]={
                                        warranty_info_url: "http://www.intothebox.org/warranty-info.pdf",
                                        warranty_claim_url: "http://intothebox.org/warranty-claim",
                                        products_url: "http://intothebox.org/products"
                                     }

                                    resolve();
                                });
                            });
                        });
                    });

                });
                return promise;
            }

            ,_marshallClaimData:function(){
                return this.serializedFormToObject($("#stx-reg-form").serializeArray());
            }

            ,serializedFormToObject:function(data){
                var obj = {}
                for(var i in data){
                    if(typeof(obj[data[i].name]) === 'undefined' || obj[data[i].name].length === 0){
                        obj[data[i].name]=data[i].value;
                    } else {
                        obj[data[i].name]=obj[data[i].name]+','+data[i].value;
                    } 
                }
                return obj;
            }

        });
        
        return new View;
    }
);