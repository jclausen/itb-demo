/*! Copyright 2015 - Silo Web (Compiled: 14-12-2015) */
define([ "Backbone", "datepicker" ], function(Backbone, datepicker) {
    "use strict";
    var View = Backbone.View.extend({
        el: ".content",
        events: {},
        initialize: function() {
            return this.setupSelectors().setupDefaults().render();
        },
        setupSelectors: function() {
            $(".datepicker").each(function() {
                $(this).datepicker();
            });
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