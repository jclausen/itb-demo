/*! Copyright 2015 - Silo Web (Compiled: 14-12-2015) */
define([ "Backbone", "model/States" ], function(Backbone, ModelStates) {
    "use strict";
    var View = Backbone.View.extend({
        el: ".form-group.country",
        events: {
            "change select.country-select": "onChangeCountrySelect"
        },
        initialize: function($el, cb) {
            var _this = this;
            if (typeof $el !== "undefined") {
                _this.el = $el;
                _this.$el = $el;
            }
            if (typeof window.STX_HTTP_SERVER === "undefined") {
                window.STX_HTTP_SERVER = "";
            }
            _this.API_BASE_URI = window.STX_HTTP_SERVER + "/api/v1/";
            _this.setupDefaults().then(function() {
                if (typeof cb !== "undefined") {
                    return cb(_this.setupSelectors().render());
                } else {
                    return _this.setupSelectors().render();
                }
            });
        },
        setupSelectors: function() {
            var _this = this;
            _this.$countrySelect = $(".country-select", _this.el);
            _this.$addressBlock = _this.$countrySelect.closest(".form-group").prev(".address-block");
            _this.$stateSelect = _this.$addressBlock.find(".state-select");
            return this;
        },
        setupDefaults: function() {
            var _this = this;
            _this.stateOptionsTemplate = '<% for(var i in states){ %>					<option value="<%= states[i].abbr %>"><%= states[i].name %></option>				<% } %>';
            _this.templateData = {};
            _this.templateData.states = {};
            var Defaults = new Promise(function(resolve, reject) {
                _this.states("all", function(states) {
                    return resolve(_this);
                });
            });
            return Defaults;
        },
        render: function() {
            var _this = this;
            _this.renderStateSelect();
            return this;
        },
        renderStateSelect: function($select, countryAbbr) {
            var _this = this;
            if (typeof $select === "undefined") $select = _this.$stateSelect;
            if (typeof countryAbbr === "undefined") countryAbbr = _this.countryAbbr(_this.$countrySelect.val());
            var stateOptionsTemplate = _.template(_this.stateOptionsTemplate);
            _this.states(countryAbbr, function(states) {
                $select.html(stateOptionsTemplate({
                    states: states
                }));
            });
        },
        onChangeCountrySelect: function(e) {
            this.render();
        },
        countryAbbr: function(countryName) {
            switch (countryName) {
              case "all":
                return;

              case "United States":
                return "US";

              case "Canada":
                return "CA";

              case "Mexico":
                return "MX";

              default:
                return "US";
            }
        },
        states: function(country, cb) {
            var _this = this;
            var resolve = function(templateData) {
                if (typeof country === "undefined" || country === "all") {
                    var allStates = templateData.states.US.concat(templateData.states.CA);
                    allStates.sort(function(a, b) {
                        return a.abbr.localeCompare(b.abbr);
                    });
                    var response = allStates;
                } else if (typeof templateData.states[country] !== "undefined") {
                    var response = templateData.states[country];
                } else {
                    var response = templateData.states;
                }
                if (typeof cb === "undefined") {
                    return response;
                } else {
                    return cb(response);
                }
            };
            if (typeof _this.templateData.states.US === "undefined" || typeof _this.templateData.states.CA === "undefined") {
                if (typeof _this.templateData.states === "undefined") _this.templateData.states = {};
                ModelStates.fetch({
                    data: {
                        country: "us"
                    },
                    success: function(model, resp) {
                        _this.templateData.states["US"] = model.attributes.states;
                        ModelStates.fetch({
                            data: {
                                country: "ca"
                            },
                            success: function(model, resp) {
                                _this.templateData.states["CA"] = model.attributes.states;
                                return resolve(_this.templateData);
                            },
                            error: function(model, err) {}
                        });
                    },
                    error: function(model, err) {
                        console.log(err);
                    }
                });
            } else {
                return resolve(_this.templateData);
            }
        },
        stateOptionsTemplate: function(data) {
            var _this = this;
            var template = _.template(_this.stateOptionsTemplate);
            return template(data);
        }
    });
    return View;
});