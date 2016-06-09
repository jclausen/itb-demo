/*! Copyright 2015 - Silo Web (Compiled: 14-12-2015) */
define([ "Backbone", "view/widgets/registration.list" ], function(Backbone, ListWidget) {
    "use strict";
    var View = Backbone.View.extend({
        el: ".content",
        events: {},
        initialize: function() {
            return this.setupDefaults().setupSelectors().render();
        },
        setupSelectors: function() {
            return this;
        },
        setupDefaults: function() {
            return this;
        },
        render: function() {
            return this;
        }
    });
    return new View();
});