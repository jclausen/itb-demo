/*! Copyright 2015 - Silo Web (Compiled: 14-12-2015) */
define([ "Backbone", "datepicker", "theme/fuelux.wizard", "view/widgets/country.select" ], function(Backbone, datepicker, fuelux, CountrySelects) {
    "use strict";
    var View = Backbone.View.extend({
        el: "section#suretix-registration",
        events: {
            "change input#SerialNumber": "onValidateSerialNumber",
            "click #btnAdvanceRegistration.advance": "onAdvanceRegistration",
            "click #btnAdvanceRegistration.confirmation": "onSubmitRegistration",
            "click #btnReverseRegistration": "onReverseRegistration"
        },
        initialize: function() {
            var _this = this;
            _this.setupDefaults().then(function() {
                return _this.setupSelectors().render();
            });
        },
        setupSelectors: function() {
            return this;
        },
        setupDefaults: function() {
            var _this = this;
            if (typeof window.STX_HTTP_SERVER === "undefined") {
                window.STX_HTTP_SERVER = "";
            }
            _this.API_BASE_URI = window.STX_HTTP_SERVER + "/api/v1/";
            var promise = new Promise(function(resolve, reject) {
                $.ajaxSetup({
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("Authorization", "STX-TOKEN " + window.STX_TOKEN);
                    }
                });
                _this.templateData = {};
                _this._marshallDefaultData().then(function(data) {
                    $("#stx-reg-form.wizard").wizard();
                    resolve();
                });
            });
            return promise;
        },
        render: function() {
            var _this = this;
            _this.renderUIElements();
            $(".step-pane").each(function() {
                var $pane = $(this);
                if (typeof $pane.attr("data-content-id") !== "undefined") {
                    var paneContent = _.template($("#" + $pane.attr("data-content-id")).html());
                    var content = paneContent(_this.templateData);
                    var $contentArea = $pane.find(".pane-content");
                    $contentArea.html(content);
                    $contentArea.find(".form-group").each(function() {
                        $(this).addClass("field-box");
                        if ($(this).is(".country")) {
                            var countrySelect = new CountrySelects($(this), function(cs) {
                                if ($('[name="InstallState"]', _this.el).find("options").length === 0) countrySelect.renderStateSelect($("select#InstallState"), "all");
                            });
                        }
                    });
                    _this.markRequiredFields($contentArea);
                    _this.renderUIElements($contentArea);
                }
            });
            return this;
        },
        onValidateSerialNumber: function(e) {
            var _this = this;
            var $snField = $(e.currentTarget);
            if ($snField.val().length > 0) {
                var productId = $('[name="ModelNumber"]', _this.el).val();
                $.get(_this.API_BASE_URI + "products/" + productId + "/inventory/" + $snField.val()).done(function(data) {
                    _this.renderValidField($snField, "Your serial number is valid.  Please continue with registration.");
                    $("#btnAdvanceRegistration").prop("disabled", false);
                }).fail(function(data) {
                    _this.renderInvalidField($snField);
                    $("#btnAdvanceRegistration").prop("disabled", true);
                });
            } else {
                _this.renderInvalidField($snField);
                $("#btnAdvanceRegistration").prop("disabled", true);
            }
        },
        onAdvanceRegistration: function(e) {
            var _this = this;
            e.preventDefault();
            var $btn = $(e.currentTarget);
            _this.onValidateRegistrationForm(e);
        },
        onReverseRegistration: function(e) {
            if ($("#btnAdvanceRegistration").hasClass("confirmation")) $("#btnAdvanceRegistration").removeClass("confirmation").addClass("advance");
            $("#stx-reg-form.wizard").wizard("previous");
        },
        onValidateRegistrationForm: function(e, data) {
            e.preventDefault();
            var _this = this;
            var $btn = $(e.currentTarget);
            var $activePane = $(".step-pane.active", _this.el);
            if ($btn.hasClass("advance")) {
                var scope = $activePane;
            } else {
                var scope = $("form#stx-reg-form");
            }
            var validation = new Promise(function(resolve, reject) {
                $(".req input", scope).each(function() {
                    var fieldIsValid = true;
                    var $field = $(this);
                    var $formGroup = $field.closest(".form-group");
                    var $pane = $formGroup.closest("pane");
                    var inputType = $field.attr("type");
                    switch (inputType) {
                      case "radio":
                        var fieldName = $field.attr("name");
                        if ($('[name="' + fieldName + '"]:checked').length === 0) fieldIsValid = false;
                        break;

                      case "text":
                        if ($field.val().trim().length === 0) fieldIsValid = false;
                        break;
                    }
                    if (!fieldIsValid) {
                        return reject($field);
                    }
                }).promise().done(function() {
                    return resolve();
                });
            });
            return validation.then(function() {
                _this.renderStepsButtonProgress($btn);
                return true;
            }).catch(function($field) {
                _this.onFieldValidationFail($field);
                return false;
            });
        },
        onSubmitRegistration: function(e) {
            var _this = this;
            var $btn = $(e.currentTarget);
            var defaultBtnText = $btn.html();
            $btn.html('Processing Registration <i class="fa fa-gears fa-spin"></i>');
            $btn.prop("disabled", true);
            var postData = _this._marshallRegistrationData();
            $.post(_this.API_BASE_URI + "registrations", postData).done(function(data) {
                if (typeof data.registration !== "undefined") {
                    $btn.addClass("hide").prop("disabled", true);
                    $("#btnReverseRegistration").addClass("hide").prop("disabled", true);
                    $(".step-pane.registration-confirmation .pane-title").html("<h2>Registration Received</h2>");
                    var $contentArea = $(".step-pane.registration-confirmation .pane-content");
                    var confirmationData = _.clone(_this.templateData);
                    confirmationData.registration = data.registration;
                    var confirmationTemplate = _.template($("#registration-confirmation").html());
                    $contentArea.html(confirmationTemplate(confirmationData));
                    $contentArea.find(".form-group").each(function() {
                        $(this).addClass("field-box");
                    });
                    _this.markRequiredFields($contentArea);
                    _this.renderUIElements($contentArea);
                    $("#stx-reg-form").wizard("next");
                    $("#stx-reg-form ul.steps").find("li").each(function() {
                        var $step = $(this);
                        if ($step.hasClass("active")) {
                            $step.removeClass("active").addClass("complete");
                        }
                    });
                } else {
                    $btn.html(defaultBtnText);
                    $btn.prop("disabled", false);
                    _this.renderAPIResponseError(data);
                }
            }).fail(function(jqXHR) {
                $btn.html(defaultBtnText);
                $btn.prop("disabled", false);
                _this.renderAPIResponseError(jqXHR.responseJSON);
            });
        },
        renderStepsButtonProgress: function($btn) {
            if (!$(".step-pane").last().prev(".step-pane").is(":visible")) {
                $("#stx-reg-form.wizard").wizard("next");
                $(".step-pane:visible").find("input").first().focus();
            } else {
                $btn.removeClass("advance").addClass("confirmation").click();
            }
            if (!$(".step-pane").first().is(":visible")) {
                $("#btnReverseRegistration").removeClass("hide").prop("disabled", false);
            } else {
                $("#btnReverseRegistration").addClass("hide").prop("disabled", true);
            }
        },
        renderAPIResponseError: function(response) {
            $("button.confirmation").removeClass("confirmation").addClass("advance");
            if (typeof response.error === "undefined") {
                response.error = "An unexpected error occurred while transmitting to the API.  Please try again.";
            }
            var apiErrorTemplate = _.template($("#api-error").html());
            var templateData = {
                errorMessage: response.error
            };
            if (typeof response.errorDetail !== "undefined") {
                templateData.errorDetail = response.errorDetail;
            }
            $(".submits").prepend(apiErrorTemplate(templateData));
            setTimeout(function() {
                $(".alert.alert-danger", $(".submits")).fadeOut(300, function() {
                    $(".alert.alert-danger", $(".submits")).remove();
                });
            }, 8e3);
        },
        onFieldValidationFail: function($field) {
            var _this = this;
            _this.renderInvalidField($field);
        },
        renderInvalidField: function($field, msg) {
            $field.next(".alert-msg").remove();
            var $formGroup = $field.closest(".form-group");
            $formGroup.removeClass("success has-success").addClass("error has-error");
            $field.focus();
            if ($field.attr("data-validation-message")) {
                var msg = $field.attr("data-validation-message");
            } else if (typeof msg === "undefined") {
                var msg = "We could not proceed as this field is required.";
            }
            if ($field.attr("type") === "radio" || $field.attr("type") === "checkbox") {
                $formGroup.find("label").first().after('<div class="col-xs-12 alert-msg text-danger bg-danger"><i class="fa-close"></i> ' + msg + "</div>");
                $formGroup.find(".alert-msg").find("i.fa-close").bind("click", function() {
                    $(this).css("cursor", "pointer");
                    $formGroup.find(".alert-msg").fadeOut(300, function() {
                        $field.next(".alert-msg").remove();
                    });
                });
            } else {
                $field.after('<span class="alert-msg text-danger bg-danger"><i class="fa-close"></i> ' + msg + "</span>");
                $field.next(".alert-msg").find("i.fa-close").bind("click", function() {
                    $(this).css("cursor", "pointer");
                    $field.next(".alert-msg").fadeOut(300, function() {
                        $field.next(".alert-msg").remove();
                    });
                });
            }
            setTimeout(function() {
                if ($formGroup.find(".alert-msg").length > 0) {
                    $formGroup.find("span-alert-msg").fadeOut(300, function() {
                        $formGroup.find("span-alert-msg").remove();
                    });
                }
            }, 8e3);
        },
        renderValidField: function($field, msg) {
            $field.next(".alert-msg").remove();
            var $formGroup = $field.closest(".form-group");
            $formGroup.removeClass("error has-error").addClass("success has-success");
            if (typeof msg !== "undefined") {
                $field.after('<div class="col-xs-12 alert-msg text-success bg-success"><i class="fa-check-circle"></i> ' + msg + "</div>");
            }
        },
        markRequiredFields: function($area) {
            if (typeof $area === "undefined") $area = $("body");
            var $indicator = $(".req-indicator").first();
            $(".form-group.req", $area).each(function() {
                var $group = $(this);
                if ($group.find("label").length > 0) {
                    $group.find("label").first().append($indicator[0].outerHTML);
                }
            });
        },
        renderUIElements: function($scope) {
            var _this = this;
            if (typeof $scope === "undefined") $scope = $(_this.el);
            $("input.input-datepicker,input.datepicker", $scope).datepicker({
                todayBtn: "linked",
                orientation: "top auto",
                autoclose: true,
                todayHighlight: true
            });
            $('[data-toggle="tooltip"]', $scope).tooltip();
            $('[data-toggle="popover"]', $scope).popover({
                template: '<div class="popover" role="tooltip" style="min-width: 600px!important;"><div class="arrow"></div><h3 class="popover-title text-primary"></h3><div class="popover-content"><div class="data-content"></div></div></div>',
                autoclose: true,
                trigger: "hover"
            });
        },
        _marshallDefaultData: function() {
            var _this = this;
            var promise = new Promise(function(resolve, reject) {
                $.get(_this.API_BASE_URI + "registrations/questions", function(data) {
                    _this.templateData.questions = data.questions;
                    $.get(_this.API_BASE_URI + "products", function(data) {
                        _this.templateData.products = data.products;
                        _this.templateData["settings"] = {
                            warranty_info_url: "http://www.intothebox.org/warranty-info.pdf",
                            warranty_claim_url: "http://intothebox.org/warranty-claim",
                            products_url: "http://intothebox.org/products"
                        };
                        resolve();
                    });
                });
            });
            return promise;
        },
        _marshallRegistrationData: function() {
            return this.serializedFormToObject($("#stx-reg-form").serializeArray());
        },
        serializedFormToObject: function(data) {
            var obj = {};
            for (var i in data) {
                if (typeof obj[data[i].name] === "undefined" || obj[data[i].name].length === 0) {
                    obj[data[i].name] = data[i].value;
                } else {
                    obj[data[i].name] = obj[data[i].name] + "," + data[i].value;
                }
            }
            return obj;
        }
    });
    return new View();
});