/*! Copyright 2015 - Silo Web (Compiled: 14-12-2015) */
define([ "Backbone", "model/User", "model/Roles" ], function(Backbone, ModelUsers, ModelRoles) {
    "use strict";
    var View = Backbone.View.extend({
        el: ".content",
        events: {
            "click #createUserBtn": "onCreateUser",
            "click #btnProcessAddUser": "onProcessUserAdd",
            "click #btnCancelAddUser": "onCancelAddUser"
        },
        initialize: function() {
            return this.setupDefaults().setupSelectors().render();
        },
        setupSelectors: function() {
            var _this = this;
            return this;
        },
        setupDefaults: function() {
            return this;
        },
        render: function() {
            var userListTemplate = _.template($("#user-list-template").html());
            $("#user-list").html(userListTemplate({}));
            ModelUsers.fetch({
                success: function(model, resp) {
                    var users = model.attributes.users;
                    for (var i in users) {
                        var user = users[i];
                        var templateData = {
                            user: user
                        };
                        var template = _.template($("#user-list-row-template").html());
                        $("tbody.user-list", $("table.user-list-table")).append(template(templateData));
                    }
                },
                error: function(model, err) {
                    console.log(err);
                }
            });
            return this;
        },
        onCreateUser: function(e) {
            var _this = this;
            var $btn = $(e.currentTarget);
            var userForm = _.template($("#user-edit-form").html());
            ModelRoles.fetch({
                success: function(model, resp) {
                    window.roles = model.attributes.roles;
                    $("#user-form").append("<h3>Add New User <a class='pull-right btn btn-link' id='btnCancelAddUser'><i class='icon icon-undo'></i> Cancel</a></h3>" + userForm({
                        user: {
                            role: {}
                        }
                    }) + '<fieldset style="padding: 30px"><a href="javascript:void(0)" id="btnProcessAddUser" class="btn-flat default pull-right"><i class="icon icon-save"></i> Create User</a></fieldset>');
                },
                error: function(model, err) {
                    console.log(err);
                }
            });
        },
        onCancelAddUser: function(e) {
            $("#user-form").fadeOut(400, function() {
                $("#user-form").html("");
                $("#user-form").show();
            });
        },
        onProcessUserAdd: function(e) {
            var _this = this;
            var $btn = $(e.currentTarget);
            $btn.find(".icon").removeClass("icon-save").addClass("icon-spin icon-spinner");
            var $form = $('[name="user-edit-form"]');
            var formData = $form.serializeArray();
            var formData = _this.serializedFormToObject(formData);
            ModelUsers.save(formData, {
                success: function(model, resp) {
                    $("#user-form").html('<p id="user-creation-notice" class="alert alert-success">User successfully created</p>');
                    _this.render();
                    setTimeout(function() {
                        $("#user-creation-notice").fadeOut(300, function() {
                            $("#user-creation-notice").remove();
                        });
                    }, 1e3);
                },
                error: function(model, err) {
                    console.log(err);
                }
            });
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