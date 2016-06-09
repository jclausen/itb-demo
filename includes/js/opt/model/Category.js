/*! Copyright 2015 - Silo Web (Compiled: 08-12-2015) */
define([ "Backbone" ], function(Backbone) {
    "use strict";
    var Model = Backbone.Model.extend({
        urlRoot: "/api/v1/products/categories",
        defaults: {},
        initialize: function() {
            return this;
        }
    });
    return new Model();
});