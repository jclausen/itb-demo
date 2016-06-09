require.config({
    paths:{
        require:'../../node_modules/requirejs/require'
        ,underscore:'../../bower_components/underscore/underscore-min'
        ,jquery:'../../bower_components/jquery/dist/jquery.min'
        ,Backbone:'../../bower_components/backbone/backbone-min'
        ,bootstrap:'../../bower_components/bootstrap/dist/js/bootstrap.min'
        ,validator:'../../bower_components/bootstrap-validator/dist/validator.min'
        ,select2:'../../bower_components/select2/dist/js/select2.full.min'
        ,moment:'../../bower_components/moment/min/moment.min'
        ,datepicker:'../../bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min'
        ,raphael:'../../bower_components/raphael/raphael-min'
        ,morris:'../../bower_components/morris.js/morris.min'
        ,flot:'../../bower_components/Flot/jquery.flot'
        ,theme:'theme/theme'
        ,md5:'../../bower_components/cryptojslib/rollups/md5'
        ,datatables:'../../bower_components/datatables/media/js/jquery.dataTables.min'
        ,iframeResizer:'../../bower_components/iframe-resizer/js/iframeResizer.min'
        ,iframeContentWindow:'../../bower_components/iframe-resizer/js/iframeResizer.contentWindow.min'
        ,bootbox:'../../bower_components/bootbox.js/bootbox'
        ,"es6-shim": '../../bower_components/es6-shim/es6-shim.min'
    }
    ,shim:{
        underscore:{exports:'_'}
        ,jquery:{exports:['jQuery','$']}
        ,Backbone:{exports:'Backbone', deps:['jquery', 'underscore'] }
        ,bootstrap:{ exports:'Bootstrap', deps:['jquery'] }
        ,validator:{ exports: 'validator', deps: ['jquery'] }
        ,select2: {exports:'select2', deps:['jquery']}
        ,moment: {exports:'moment', deps:[]}
        ,datepicker:{exports:'datepicker',deps:['jquery','bootstrap']}
        ,morris:{exports:'Morris',deps:['jquery','raphael']}
        ,flot:{exports:'flot',deps:['jquery']}
        ,datatables:{exports:'datatables',deps:['jquery']}
        ,bootbox:{exports:'bootbox',deps:['jquery','bootstrap']}
        ,"es6-shim":{exports:'es6-shim'}
    }
    ,deps:['jquery','bootstrap','underscore','backbone','datatables','moment','theme','morris','bootbox']
});