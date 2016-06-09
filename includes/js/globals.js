requirejs.config({
	baseUrl: '/includes/js/opt',
	shim: {
	    'jquery'         : ['jquery'],
	    'bootstrap'       : ['bootstrap'],
	    'backbone'		: ['backbone'],
	    'underscore'	: ['underscore'],
	    'datepicker'	: {exports:'datepicker',deps:['jquery','bootstrap']}
	}
});


/**
* Global Functions and UDFS
**/

/**
* Serialize a jQuery form aray to an object
**/
serializedFormToObject = function(data) {
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


/**
* Title Case String Function
**/
String.prototype.toProperCase = function () {
    return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
};