/**
 * Gruntfile
 *
 * If you created your Sails app with `sails new foo --linker`, 
 * the following files will be automatically injected (in order)
 * into the EJS and HTML files in your `views` and `assets` folders.
 *
 * At the top part of this file, you'll find a few of the most commonly
 * configured options, but Sails' integration with Grunt is also fully
 * customizable.  If you'd like to work with your assets differently 
 * you can change this file to do anything you like!
 *
 * More information on using Grunt to work with static assets:
 * http://gruntjs.com/configuring-tasks
 */

module.exports = function (grunt) {

  require('coffee-script/register');
  var assetsService = require('./api/services/AssetsService');

  var basePublicPath = assetsService.BASE_PUBLIC_PATH;
  var baseAssetsPath = assetsService.BASE_ASSETS_PATH;
  var jsBaseAssetsPath = assetsService.JS_BASE_ASSETS_PATH;
  var styleBaseAssetsPath = assetsService.STYLE_BASE_ASSETS_PATH;
  var jsVendorBaseAssetsPath = assetsService.JS_VENDOR_BASE_ASSETS_PATH;
  var styleVendorBaseAssetsPath = assetsService.STYLE_VENDOR_BASE_ASSETS_PATH;
  var imageBaseAssetsPath = assetsService.IMAGE_BASE_ASSETS_PATH;
  var templateBaseAssetsPath = assetsService.TEMPLATE_BASE_ASSETS_PATH;
  var fontBaseAssetsPath = assetsService.FONT_BASE_ASSETS_PATH;
  var productionJsPath = assetsService.PRODUCTION_JS_PATH;
  var productionStylePath = assetsService.PRODUCTION_STYLE_PATH;

  var bowerBasePath = './bower_components/';

  /**
   * CSS files to inject in order
   * (uses Grunt-style wildcard/glob/splat expressions)
   *
   * By default, Sails also supports LESS in development and production.
   * To use SASS/SCSS, Stylus, etc., edit the `sails-linker:devStyles` task 
   * below for more options.  For this to work, you may need to install new 
   * dependencies, e.g. `npm install grunt-contrib-sass`
   */

  var cssFilesToInject = [
    styleBaseAssetsPath + 'bootstrap.css',
    styleBaseAssetsPath + 'bootstrap-theme.css',
    styleBaseAssetsPath + 'font-awesome.css',
    styleBaseAssetsPath + 'angular-motion.css'
  ];


  /**
   * Javascript files to inject in order
   * (uses Grunt-style wildcard/glob/splat expressions)
   *
   * To use client-side CoffeeScript, TypeScript, etc., edit the 
   * `sails-linker:devJs` task below for more options.
   */

  var jsFilesToInject = [

    // Below, as a demonstration, you'll see the built-in dependencies 
    // linked in the proper order order

    // bower resources
    jsVendorBaseAssetsPath + 'jquery.js',
    jsVendorBaseAssetsPath + 'bootstrap.js',
    jsVendorBaseAssetsPath + 'angular.js',
    jsVendorBaseAssetsPath + 'angular.js',
    jsVendorBaseAssetsPath + 'angular-route.js',
    jsVendorBaseAssetsPath + 'angular-route-segment.js',
    jsVendorBaseAssetsPath + 'angular-animate.js',
    jsVendorBaseAssetsPath + 'angular-strap.js', 
    jsVendorBaseAssetsPath + 'angular-strap.tpl.js',

    // Bring in the socket.io client
    jsVendorBaseAssetsPath + 'socket.io.js',

    // then beef it up with some convenience logic for talking to Sails.js
    jsVendorBaseAssetsPath + 'sails.io.js',

    jsVendorBaseAssetsPath + 'async.js',

    jsVendorBaseAssetsPath + 'require.js',
    jsBaseAssetsPath + 'setup.js'

    // A simpler boilerplate library for getting you up and running w/ an
    // automatic listener for incoming messages from Socket.io.


    // *->    put other dependencies here   <-*

    // All of the rest of your app scripts imported here
  ];


  /**
   * Client-side HTML templates are injected using the sources below
   * The ordering of these templates shouldn't matter.
   * (uses Grunt-style wildcard/glob/splat expressions)
   * 
   * By default, Sails uses JST templates and precompiles them into 
   * functions for you.  If you want to use jade, handlebars, dust, etc.,
   * edit the relevant sections below.
   */

  var templateFilesToInject = [
    //'linker/**/*.html'
  ];



  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  //
  // DANGER:
  //
  // With great power comes great responsibility.
  //
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////

  // Modify css file injection paths to use 
  // cssFilesToInject = cssFilesToInject.map(function (path) {
  //   return '.tmp/public/' + path;
  // });

  // Modify js file injection paths to use 
  // jsFilesToInject = jsFilesToInject.map(function (path) {
  //   return '.tmp/public/' + path;
  // });
  
  
  // templateFilesToInject = templateFilesToInject.map(function (path) {
  //   return 'assets/' + path;
  // });


  // Get path to core grunt dependencies from Sails
  var depsPath = grunt.option('gdsrc') || 'node_modules/sails/node_modules';
  grunt.loadTasks(depsPath + '/grunt-contrib-clean/tasks');
  grunt.loadTasks(depsPath + '/grunt-contrib-copy/tasks');
  grunt.loadTasks(depsPath + '/grunt-contrib-concat/tasks');
  grunt.loadTasks(depsPath + '/grunt-sails-linker/tasks');
  grunt.loadTasks(depsPath + '/grunt-contrib-jst/tasks');
  grunt.loadTasks(depsPath + '/grunt-contrib-watch/tasks');
  grunt.loadTasks(depsPath + '/grunt-contrib-uglify/tasks');
  grunt.loadTasks(depsPath + '/grunt-contrib-cssmin/tasks');
  grunt.loadTasks(depsPath + '/grunt-contrib-less/tasks');
  grunt.loadTasks(depsPath + '/grunt-contrib-coffee/tasks');

  grunt.loadNpmTasks('grunt-bower-task');

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    bower: {
      install: {
        options: {
          install: true
        }
      }
    },

    copy: {
      dev: {
        files: [{
          expand: true,
          cwd: './assets/',
          src: ['*'],
          dest: basePublicPath,
          filter: 'isFile'
        }, {
          expand: true,
          cwd: './assets/js',
          src: ['**/*.!(coffee)'],
          dest: jsBaseAssetsPath
        }, {
          expand: true,
          cwd: './assets/js',
          src: ['**/*.!(coffee)'],
          dest: jsBaseAssetsPath
        }, {
          expand: true,
          cwd: './assets/styles',
          src: ['**/*.!(less)'],
          dest: styleBaseAssetsPath
        }, {
          expand: true,
          cwd: './assets/images',
          src: ['**/*'],
          dest: imageBaseAssetsPath
        }, {
          expand: true,
          cwd: './assets/templates',
          src: ['**/*'],
          dest: templateBaseAssetsPath
        }, { //bower requirejs
          expand: true,
          cwd: bowerBasePath + 'requirejs',
          src: ['require.js'],
          dest: jsVendorBaseAssetsPath
        }, { //bower jquery
          expand: true,
          cwd: bowerBasePath + 'jquery/dist/',
          src: ['jquery.js'],
          dest: jsVendorBaseAssetsPath
        }, { //bower boostrap js
          expand: true,
          cwd: bowerBasePath + 'bootstrap/dist/js/',
          src: ['bootstrap.js'],
          dest: jsVendorBaseAssetsPath
        }, { //bower boostrap css
          expand: true,
          cwd: bowerBasePath + 'bootstrap/dist/css/',
          src: ['bootstrap.css'],
          dest: styleBaseAssetsPath
        }, { //bower boostrap theme css
          expand: true,
          cwd: bowerBasePath + 'bootstrap/dist/css/',
          src: ['bootstrap-theme.css'],
          dest: styleBaseAssetsPath
        }, { //bower boostrap font
          expand: true,
          cwd: bowerBasePath + 'bootstrap/dist/fonts/',
          src: ['**/*'],
          dest: fontBaseAssetsPath
        }, { //bower angularjs
          expand: true,
          cwd: bowerBasePath + 'angular/',
          src: ['angular.js'],
          dest: jsVendorBaseAssetsPath
        }, { //bower angular-route
          expand: true,
          cwd: bowerBasePath + 'angular-route',
          src: ['angular-route.js'],
          dest: jsVendorBaseAssetsPath
        }, { //bower angular-route-segment
          expand: true,
          cwd: bowerBasePath + 'angular-route-segment/build/',
          src: ['angular-route-segment.js'],
          dest: jsVendorBaseAssetsPath
        }, { //bower angular-animate
          expand: true,
          cwd: bowerBasePath + 'angular-animate',
          src: ['angular-animate.js'],
          dest: jsVendorBaseAssetsPath
        }, { //bower fontawesome
          expand: true,
          cwd: bowerBasePath + 'fontawesome/css/',
          src: ['font-awesome.css'],
          dest: styleBaseAssetsPath
        }, { //bower fontawesome font
          expand: true,
          cwd: bowerBasePath + 'fontawesome/fonts/',
          src: ['**/*'],
          dest: fontBaseAssetsPath
        }, { //bower angularAMD
          expand: true,
          cwd: bowerBasePath + 'angularAMD/',
          src: ['angularAMD.js', 'ngload.js'],
          dest: jsVendorBaseAssetsPath
        }, { //bower angular-strap
          expand: true,
          cwd: bowerBasePath + 'angular-strap/dist/',
          src: ['angular-strap.js', 'angular-strap.tpl.js'],
          dest: jsVendorBaseAssetsPath
        }, { //bower angular-motion
          expand: true,
          cwd: bowerBasePath + 'angular-motion/dist/',
          src: ['angular-motion.css'],
          dest: styleBaseAssetsPath
        }, { //bower async
          expand: true,
          cwd: bowerBasePath + 'async/lib',
          src: ['async.js'],
          dest: jsVendorBaseAssetsPath
        }]
      },
      build: {
        files: [
          {
          expand: true,
          cwd: '.tmp/public',
          src: ['**/*'],
          dest: 'www'
        }
        ]
      }
    },

    clean: {
      dev: ['.tmp/public/**'],
      build: ['www']
    },

    jst: {
      dev: {

        // To use other sorts of templates, specify the regexp below:
        // options: {
        //   templateSettings: {
        //     interpolate: /\{\{(.+?)\}\}/g
        //   }
        // },

        files: {
          '.tmp/public/jst.js': templateFilesToInject
        }
      }
    },

    less: {
      dev: {
        files: [
          {
            expand: true,
            cwd: 'assets/styles/',
            src: ['*.less'],
            dest: styleBaseAssetsPath,
            ext: '.css'
          }
        ]
      }
    },
    
    coffee: {
      dev: {
        options:{
          bare:true
        },
        files: [
          {
            expand: true,
            cwd: 'assets/js/',
            src: ['**/*.coffee'],
            dest: jsBaseAssetsPath,
            ext: '.js'
          }
        ]
      }
    },

    concat: {
      js: {
        src: jsFilesToInject,
        dest: '.tmp/public/concat/production.js'
      },
      css: {
        src: cssFilesToInject,
        dest: '.tmp/public/concat/production.css'
      }
    },

    uglify: {
      dist: {
        src: ['.tmp/public/concat/production.js'],
        dest: productionJsPath
      },
      files: {
        files: [{
            expand: true,
            cwd: jsBaseAssetsPath,
            src: '**/*.js',
            dest: jsBaseAssetsPath
        }]
      }
    },

    cssmin: {
      dist: {
        src: ['.tmp/public/concat/production.css'],
        dest: productionStylePath
      },
      minify: {
        expand: true,
        cwd: styleBaseAssetsPath,
        src: ['*.css'],
        dest: styleBaseAssetsPath
      }
    },

    'sails-linker': {

      devJs: {
        options: {
          startTag: '<!--SCRIPTS-->',
          endTag: '<!--SCRIPTS END-->',
          fileTmpl: '<script src="%s"></script>',
          appRoot: '.tmp/public'
        },
        files: {
          '.tmp/public/**/*.html': jsFilesToInject,
          'views/**/*.html': jsFilesToInject,
          'views/**/*.ejs': jsFilesToInject
        }
      },

      prodJs: {
        options: {
          startTag: '<!--SCRIPTS-->',
          endTag: '<!--SCRIPTS END-->',
          fileTmpl: '<script src="%s"></script>',
          appRoot: '.tmp/public'
        },
        files: {
          '.tmp/public/**/*.html': [productionJsPath],
          'views/**/*.html': [productionJsPath],
          'views/**/*.ejs': [productionJsPath]
        }
      },

      devStyles: {
        options: {
          startTag: '<!--STYLES-->',
          endTag: '<!--STYLES END-->',
          fileTmpl: '<link rel="stylesheet" href="%s">',
          appRoot: '.tmp/public'
        },

        // cssFilesToInject defined up top
        files: {
          '.tmp/public/**/*.html': cssFilesToInject,
          'views/**/*.html': cssFilesToInject,
          'views/**/*.ejs': cssFilesToInject
        }
      },

      prodStyles: {
        options: {
          startTag: '<!--STYLES-->',
          endTag: '<!--STYLES END-->',
          fileTmpl: '<link rel="stylesheet" href="%s">',
          appRoot: '.tmp/public'
        },
        files: {
          '.tmp/public/index.html': [productionStylePath],
          'views/**/*.html': [productionStylePath],
          'views/**/*.ejs': [productionStylePath]
        }
      },

      // Bring in JST template object
      devTpl: {
        options: {
          startTag: '<!--TEMPLATES-->',
          endTag: '<!--TEMPLATES END-->',
          fileTmpl: '<script type="text/javascript" src="%s"></script>',
          appRoot: '.tmp/public'
        },
        files: {
          '.tmp/public/index.html': ['.tmp/public/jst.js'],
          'views/**/*.html': ['.tmp/public/jst.js'],
          'views/**/*.ejs': ['.tmp/public/jst.js']
        }
      },


      /*******************************************
       * Jade linkers (TODO: clean this up)
       *******************************************/

      devJsJADE: {
        options: {
          startTag: '// SCRIPTS',
          endTag: '// SCRIPTS END',
          fileTmpl: 'script(type="text/javascript", src="%s")',
          appRoot: '.tmp/public'
        },
        files: {
          'views/**/*.jade': jsFilesToInject
        }
      },

      prodJsJADE: {
        options: {
          startTag: '// SCRIPTS',
          endTag: '// SCRIPTS END',
          fileTmpl: 'script(type="text/javascript", src="%s")',
          appRoot: '.tmp/public'
        },
        files: {
          'views/**/*.jade': [productionJsPath]
        }
      },

      devStylesJADE: {
        options: {
          startTag: '// STYLES',
          endTag: '// STYLES END',
          fileTmpl: 'link(rel="stylesheet", href="%s")',
          appRoot: '.tmp/public'
        },
        files: {
          'views/**/*.jade': cssFilesToInject
        }
      },

      prodStylesJADE: {
        options: {
          startTag: '// STYLES',
          endTag: '// STYLES END',
          fileTmpl: 'link(rel="stylesheet", href="%s")',
          appRoot: '.tmp/public'
        },
        files: {
          'views/**/*.jade': [productionStylePath]
        }
      },

      // Bring in JST template object
      devTplJADE: {
        options: {
          startTag: '// TEMPLATES',
          endTag: '// TEMPLATES END',
          fileTmpl: 'script(type="text/javascript", src="%s")',
          appRoot: '.tmp/public'
        },
        files: {
          'views/**/*.jade': ['.tmp/public/jst.js']
        }
      }
      /************************************
       * Jade linker end
       ************************************/
    },

    watch: {
      api: {

        // API files to watch:
        files: ['api/**/*']
      },
      assets: {

        // Assets to watch:
        files: ['assets/**/*'],

        // When assets are changed:
        tasks: ['compileAssets', 'linkAssets']
      }
    }
  });

  // When Sails is lifted:
  grunt.registerTask('default', [
    'compileAssets',
    'linkAssets',
    'watch'
  ]);

  grunt.registerTask('compileAssets', [
    'clean:dev',
    'bower:install',
    'jst:dev',
    'less:dev',
    'copy:dev',    
    'coffee:dev'
  ]);

  grunt.registerTask('linkAssets', [

    // Update link/script/template references in `assets` index.html
    'sails-linker:devJs',
    'sails-linker:devStyles',
    'sails-linker:devTpl',
    'sails-linker:devJsJADE',
    'sails-linker:devStylesJADE',
    'sails-linker:devTplJADE'
  ]);


  // Build the assets into a web accessible folder.
  // (handy for phone gap apps, chrome extensions, etc.)
  grunt.registerTask('build', [
    'compileAssets',
    'linkAssets',
    'clean:build',
    'copy:build'
  ]);

  // When sails is lifted in production
  grunt.registerTask('prod', [
    'clean:dev',
    'jst:dev',
    'less:dev',
    'copy:dev',
    'coffee:dev',
    'concat',
    'uglify',
    'cssmin',
    'sails-linker:prodJs',
    'sails-linker:prodStyles',
    'sails-linker:devTpl',
    'sails-linker:prodJsJADE',
    'sails-linker:prodStylesJADE',
    'sails-linker:devTplJADE'
  ]);

  // When API files are changed:
  // grunt.event.on('watch', function(action, filepath) {
  //   grunt.log.writeln(filepath + ' has ' + action);

  //   // Send a request to a development-only endpoint on the server
  //   // which will reuptake the file that was changed.
  //   var baseurl = grunt.option('baseurl');
  //   var gruntSignalRoute = grunt.option('signalpath');
  //   var url = baseurl + gruntSignalRoute + '?action=' + action + '&filepath=' + filepath;

  //   require('http').get(url)
  //   .on('error', function(e) {
  //     console.error(filepath + ' has ' + action + ', but could not signal the Sails.js server: ' + e.message);
  //   });
  // });
};
