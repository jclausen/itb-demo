module.exports = function(grunt) {
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		watch: {
			sass: {
				files: ['includes/scss/**/**/*.{scss,sass}','includes/scss/**/*.{scss,sass}'],
				tasks: ['sass:dist','sass:distTheme','sass:distViews']
			},
			//Turn off the big compile watching for now
			//javascript: {
            //    files: ['includes/js/*.js','includes/js/model/*.js','includes/js/view/*.js','includes/js/theme/*.js'],
            //    tasks: ['requirejs:compile']
            //},
            jsView: {
            	files: ['includes/js/view/*.js','includes/js/view/widgets/*.js'],
            	tasks: ['uglify:viewJS']
            },

            jsCollection: {
            	files: ['includes/js/collection/*.js'],
            	tasks: ['uglify:collectionJS']
            },

            jsModel: {
            	files: ['includes/js/model/*.js'],
            	tasks: ['uglify:modelJS']
            },

			livereload: {
				files: ['css/*.css'],
				options: {
					livereload: false
				}
			},

			cfml: {
        		files: [ "tests/**/*.cfc"],
        		tasks: [ "testbox" ]
		    }

		},
		
		shell: {
    		testbox: {
        		command: "node c:/www/itb-demo/node_modules/testbox-runner/index.js --colors --runner http://127.0.0.1:53874/tests/runner.cfm --directory /tests/specs --recurse true"
        	}
		},

		sass: {
			options: {
				sourceMap: true,
				outputStyle: 'compressed'
			},
			dist: {
				files: {
						'includes/css/base.css': 'includes/scss/compile/base.scss',
						'includes/css/lib.css': 'includes/scss/compile/lib.scss',
						'includes/css/remote.css': 'includes/scss/compile/remote.scss',
						'includes/css/ie.css': 'includes/scss/compile/ie.scss',
				}
			},
			distTheme: {
			    options: {
			      style: 'expanded',
			      lineNumbers: true, // 1
			      sourcemap: false
			    },
			    files: [{
			      expand: true, // 2
			      cwd: 'includes/scss/include/theme',
			      src: [ '*.scss','**/*.scss' ],
			      dest: 'includes/css/theme',
			      ext: '.css'
			    }]
			 },
			 distViews: {
			    options: {
			      style: 'expanded',
			      lineNumbers: true, // 1
			      sourcemap: false
			    },
			    files: [{
			      expand: true, // 2
			      cwd: 'includes/scss/view',
			      src: [ '**.scss','**/**.scss' ],
			      dest: 'includes/css/view',
			      ext: '.css'
			    }]
			 }
		},

		requirejs: {
		  compile: {
		    options: {
				baseUrl: "includes/js",
				mainConfigFile: "build.config.js",
				wrap:true,
				optimize: "none",
				dir:"includes/js/opt",
				// Define the modules to compile.
				modules: [
					//Core application libraries, including theme
				    {
				        name: "globals",

				        // Use the *shallow* exclude; otherwise, dependencies of
				        // (including jQuery and text and util modules). In other
				        // words, a deep-exclude would override our above include.
				        excludeShallow: []
				    },
				    //Our remote libraries - excludes the theme config
				    {
				        name: "remote",
				        // Use the *shallow* exclude; otherwise, dependencies of
				        // the FAQ module will also be excluded from this build
				        // (including jQuery and text and util modules). In other
				        // words, a deep-exclude would override our above include.
				        excludeShallow: []
				    }
				]
		    }
		  }
		},

		//uglification/copy of views and pages
		uglify: {
			 viewJS: {
			 	options: {
			  	beautify: true,
			  	mangle: false,
			  	compress: false,
			    // the banner is inserted at the top of the output
			    banner: '/*! Copyright <%= grunt.template.today("yyyy") %> - Silo Web (Compiled: <%= grunt.template.today("dd-mm-yyyy") %>) */\n'
			  	},
			  	files: [{
		          expand: true,
			      cwd: 'includes/js',
		          src: 'view/**/*.js',
		          dest: 'includes/js/opt/'
			    }]
		    },
		    modelJS: {
			 	options: {
			  	beautify: true,
			  	mangle: false,
			  	compress: false,
			    // the banner is inserted at the top of the output
			    banner: '/*! Copyright <%= grunt.template.today("yyyy") %> - Silo Web (Compiled: <%= grunt.template.today("dd-mm-yyyy") %>) */\n'
			  	},
			  	files: [{
		          expand: true,
			      cwd: 'includes/js',
		          src: 'model/**/*.js',
		          dest: 'includes/js/opt/'
			    }]
		    },
		    collectionJS: {
			 	options: {
			  	beautify: true,
			  	mangle: false,
			  	compress: false,
			    // the banner is inserted at the top of the output
			    banner: '/*! Copyright <%= grunt.template.today("yyyy") %> - Silo Web (Compiled: <%= grunt.template.today("dd-mm-yyyy") %>) */\n'
			  	},
			  	files: [{
		          expand: true,
			      cwd: 'includes/js',
		          src: 'collection/**/*.js',
		          dest: 'includes/js/opt/'
			    }]
		    }
		}

	});

	grunt.loadNpmTasks('grunt-shell');
	grunt.loadNpmTasks('grunt-sass');
	grunt.loadNpmTasks('grunt-contrib-requirejs');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.registerTask('default', ['sass:dist','sass:distTheme','sass:distViews','requirejs:compile','uglify:viewJS','uglify:modelJS','uglify:collectionJS', 'watch']);
	grunt.registerTask("testbox", [ "shell:testbox" ]);
};