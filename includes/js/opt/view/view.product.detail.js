/*! Copyright 2015 - Silo Web (Compiled: 14-12-2015) */
define([ "Backbone", "view/widgets/inventory.list", "view/widgets/editable", "model/Product", "model/Category" ], function(Backbone, InventoryList, Editable, ModelProduct, CategoryModel) {
    "use strict";
    var View = Backbone.View.extend({
        el: ".content",
        events: {
            "click .edit-product": "onEditStart"
        },
        initialize: function() {
            var _this = this;
            var init = function() {
                return _this.setupDefaults().setupSelectors().render();
            };
            if (typeof window.categories === "undefined") {
                CategoryModel.fetch({
                    success: function(model, resp) {
                        window.categories = model.attributes.categories;
                        return init();
                    },
                    error: function(model, err) {
                        console.log(err);
                    }
                });
            } else {
                return init();
            }
            return this;
        },
        setupSelectors: function() {
            return this;
        },
        setupDefaults: function() {
            return this;
        },
        render: function() {
            var _this = this;
            var $product = $("#product-detail");
            var productId = $product.attr("data-product-id");
            ModelProduct.set("id", productId);
            ModelProduct.fetch({
                success: function(model, resp) {
                    var productTemplate = _.template($("#product-detail-template").html());
                    var templateData = model.attributes;
                    $product.html(productTemplate(templateData));
                    if (!$product.attr("data-classification")) {
                        console.log("No Classification for Element Found.  Could not make editable");
                    } else {
                        var classification = $product.attr("data-classification");
                        var classprefix = classification.toLowerCase();
                        var Editor = new Editable($product, classification, false);
                        _this.Editor = Editor;
                    }
                    _this.renderInventory(productId);
                    _this.renderUIElements();
                },
                error: function(model, err) {
                    console.log(err);
                }
            });
            return this;
        },
        renderInventory: function(productId) {
            var $inventoryContainer = $("#inventory-list");
            var inventoryListTemplate = _.template($("#inventory-list-template").html());
            var templateData = {};
            $inventoryContainer.html(inventoryListTemplate(templateData));
            var Inventory = new InventoryList(productId);
        },
        renderUIElements: function($scope) {
            var _this = this;
            if (typeof $scope === "undefined") $scope = $(_this.el);
            $('[data-toggle="tooltip"]', $scope).tooltip();
            $('[data-toggle="popover"]', $scope).popover();
        },
        onEditStart: function(e) {
            var $btn = $(e.currentTarget);
            $(".icon", $btn).removeClass("icon-pencil").addClass("icon-spin icon-spinner");
            return this.Editor.onEditStart(e);
        }
    });
    return new View();
});