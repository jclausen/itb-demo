/*! Copyright 2015 - Silo Web (Compiled: 14-12-2015) */
define([ "Backbone", "model/Product" ], function(Backbone, ModelProducts) {
    "use strict";
    var View = Backbone.View.extend({
        el: ".content",
        events: {
            "click .product-list-actions .product-approval": "onToggleActiveStatus"
        },
        initialize: function() {
            return this.setupDefaults().setupSelectors().render();
        },
        setupSelectors: function() {
            return this;
        },
        setupDefaults: function() {
            this.listTemplate = _.template($("#product-list-template").html());
            this.rowTemplate = _.template($("#product-list-row-template").html());
            return this;
        },
        render: function() {
            var _this = this;
            var $container = $("#product-list");
            $container.html(_this.listTemplate({}));
            ModelProducts.fetch({
                success: function(model, resp) {
                    var products = model.attributes.products;
                    for (var i in products) {
                        var templateData = {
                            product: products[i]
                        };
                        $("tbody.products-list", $container).append(_this.rowTemplate(templateData));
                    }
                },
                error: function(model, err) {}
            });
            return this;
        },
        onToggleActiveStatus: function(e) {
            var _this = this;
            var $btn = $(e.currentTarget);
            var toggleTo = $btn.attr("data-product-toggle");
            var $row = $btn.closest(".product-data-row");
            $row.find(".icon-check-circle-o").removeClass("icon-check-circle-o icon-2x").addClass("icon-spin icon-spinner");
            var productId = $row.attr("data-product-id");
            ModelProducts.set("id", productId);
            ModelProducts.save({
                active: toggleTo
            }, {
                patch: true,
                success: function(model, resp) {
                    var templateData = model.attributes;
                    $row.replaceWith(_this.rowTemplate(templateData));
                    ModelProducts.clear();
                },
                error: function(model, err) {
                    console.log("Error saving product:");
                    console.log(err);
                }
            });
        }
    });
    return new View();
});