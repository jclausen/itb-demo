/*! Copyright 2015 - Silo Web (Compiled: 14-12-2015) */
define([ "Backbone" ], function(Backbone) {
    "use strict";
    var View = Backbone.View.extend({
        el: "body.ra-enabled",
        events: {},
        initialize: function() {
            this.setupDefaults().setupSelectors().render();
            return this;
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