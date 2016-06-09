requirejs.config({
    baseUrl: '/includes/js/opt',
    shim: {
        'backbone'      : ['backbone'],
	    'datepicker'	: {exports:'datepicker',deps:['jquery','bootstrap']}
    }
})