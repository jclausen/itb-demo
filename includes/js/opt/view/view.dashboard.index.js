/*! Copyright 2015 - Silo Web (Compiled: 14-12-2015) */
define([ "Backbone", "morris", "view/widgets/registration.list", "view/widgets/claim.list" ], function(Backbone, Morris, RegistrationList, ClaimsList) {
    "use strict";
    var View = Backbone.View.extend({
        el: ".content",
        events: {},
        initialize: function() {
            this.setupDefaults().setupSelectors().render();
            return this;
        },
        setupSelectors: function() {
            return this;
        },
        setupDefaults: function() {
            this.renderCharts();
            return this;
        },
        render: function() {
            return this;
        },
        renderCharts: function() {
            $.get("/api/v1/specials/product_activity", function(data) {
                $("#product-comparison-chart .loader").remove();
                Morris.Bar({
                    element: "product-comparison-chart",
                    data: data.product_activity,
                    xkey: "product",
                    ykeys: [ "registrations", "claims" ],
                    labels: [ "Registrations", "Claims" ],
                    barRatio: .4,
                    xLabelMargin: 10,
                    hideHover: "auto",
                    barColors: [ "#96bf48", "#d94774" ]
                });
            });
            $.get("/api/v1/specials/activity_counts", function(data) {
                $("#activity-counts .loader").remove();
                Morris.Donut({
                    element: "activity-counts",
                    data: data.activity_counts,
                    colors: [ "#96bf48", "#30a1ec", "#d94774", "#76bdee", "#c4dafe" ],
                    formatter: function(y) {
                        return y;
                    }
                });
            });
            var tax_data = [ {
                period: "2013-04",
                visits: 2407,
                signups: 660
            }, {
                period: "2013-03",
                visits: 3351,
                signups: 729
            }, {
                period: "2013-02",
                visits: 2469,
                signups: 1318
            }, {
                period: "2013-01",
                visits: 2246,
                signups: 461
            }, {
                period: "2012-12",
                visits: 3171,
                signups: 1676
            }, {
                period: "2012-11",
                visits: 2155,
                signups: 681
            }, {
                period: "2012-10",
                visits: 1226,
                signups: 620
            }, {
                period: "2012-09",
                visits: 2245,
                signups: 500
            } ];
            Morris.Line({
                element: "hero-graph",
                data: tax_data,
                xkey: "period",
                xLabels: "month",
                ykeys: [ "visits", "signups" ],
                labels: [ "Visits", "User signups" ]
            });
            Morris.Area({
                element: "hero-area",
                data: [ {
                    period: "2010 Q1",
                    iphone: 2666,
                    ipad: null,
                    itouch: 2647
                }, {
                    period: "2010 Q2",
                    iphone: 2778,
                    ipad: 2294,
                    itouch: 2441
                }, {
                    period: "2010 Q3",
                    iphone: 4912,
                    ipad: 1969,
                    itouch: 2501
                }, {
                    period: "2010 Q4",
                    iphone: 3767,
                    ipad: 3597,
                    itouch: 5689
                }, {
                    period: "2011 Q1",
                    iphone: 6810,
                    ipad: 1914,
                    itouch: 2293
                }, {
                    period: "2011 Q2",
                    iphone: 5670,
                    ipad: 4293,
                    itouch: 1881
                }, {
                    period: "2011 Q3",
                    iphone: 4820,
                    ipad: 3795,
                    itouch: 1588
                }, {
                    period: "2011 Q4",
                    iphone: 15073,
                    ipad: 5967,
                    itouch: 5175
                }, {
                    period: "2012 Q1",
                    iphone: 10687,
                    ipad: 4460,
                    itouch: 2028
                }, {
                    period: "2012 Q2",
                    iphone: 8432,
                    ipad: 5713,
                    itouch: 1791
                } ],
                xkey: "period",
                ykeys: [ "iphone", "ipad", "itouch" ],
                labels: [ "iPhone", "iPad", "iPod Touch" ],
                lineWidth: 2,
                hideHover: "auto",
                lineColors: [ "#81d5d9", "#a6e182", "#67bdf8" ]
            });
        }
    });
    return new View();
});