/*! Copyright 2015 - Silo Web (Compiled: 08-12-2015) */
define([ "Backbone" ], function(Backbone) {
    "use strict";
    var Model = Backbone.Model.extend({
        urlRoot: "/api/v1/comments",
        defaults: {},
        initialize: function(ModelName, ModelId) {
            var _this = this;
            _this.set("modelName", ModelName);
            _this.set("modelId", ModelId);
            _this.urlRoot = "/api/v1/" + ModelName.toLowerCase() + "s/comments";
            _this.set("id", ModelId);
            return this;
        },
        clear: function() {
            var _this = this;
            var ModelId = _this.get("modelId");
            var ModelName = _this.get("modelName");
            Backbone.Model.prototype.clear.call(this);
            return _this.initialize(ModelName, ModelId);
        },
        destroy: function(attrs, options) {
            var _this = this;
            var ModelId = _this.get("modelId");
            var ModelName = _this.get("modelName");
            if (typeof attrs.data === "undefined" || typeof attrs.data.commentId === "undefined") {
                console.log("No commentId value was specified for deletion.  Is your casing correct?");
                return _this;
            } else {
                _this.set("id", attrs.data.commentId);
                Backbone.Model.prototype.destroy.call(this, {
                    success: function(model, response) {
                        return attrs.success(_this.initialize(ModelName, ModelId), response);
                    },
                    error: attrs.error ? attrs.error : function(model, response) {
                        console.log(model);
                        console.log(response);
                    }
                }, options);
            }
        }
    });
    return Model;
});