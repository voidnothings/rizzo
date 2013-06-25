module.exports = function(grunt) {
  'use strict';

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    coffee: {
      compile: {
        files: [
          {
            "expand": true,
            "cwd": "./app/assets/javascripts/lib",
            "src": ["**/*.coffee"],
            "dest": "./public/assets/javascripts/lib",
            "ext": ".js"
          },
          {
            "expand": true,
            "cwd": "./spec/javascripts/lib",
            "src": ["**/*.coffee"],
            "dest": "./public/assets/javascripts/spec",
            "ext": ".js"
          }
        ]
      }
    },
    connect: {
      server: {
        options: {
          port: 8888
        }
      }
    },
    jasmine: {
      avocado: {
        src: ['lib/analytics/analytics.js'],
        options: {
          helpers: './spec/javascripts/helpers/**/*.js',
          host: 'http://localhost:8888/',
          specs: 'public/assets/javascripts/spec/analytics/analytics_spec.js',
          template: require('grunt-template-jasmine-requirejs'),
          templateOptions: {
            requireConfig: {
              baseUrl: '.',
              paths: {
                jquery: "vendor/assets/javascripts/jquery/jquery-1.7.2.min",
                lib: 'public/assets/javascripts/lib',
                handlebars: 'vendor/assets/javascripts/handlebars',
                underscore: 'vendor/assets/javascripts/underscore',
                jplugs: "vendor/assets/javascripts/jquery/plugins",
                s_code: "vendor/assets/javascripts/omniture/s_code"
              }
            }
          }
        }
      }
    },
    watch: {
      scripts: {
        files: ['app/assets/javascripts/lib/**/*.coffee', 'spec/javascripts/lib/**/*.coffee'],
        tasks: ['coffee', 'jasmine'],
        options: {
          nospawn: true
        }
      }
    },
    plato: {
      avocado: {
        files: {
          '.plato/': ['public/assets/javascripts/**/*.js']
        }
      }
    },
    shell: {
      openPlato: {
        command: 'open .plato/index.html'
      }
    }
  });

  grunt.loadTasks('grunt-tasks');

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-plato');
  grunt.loadNpmTasks('grunt-shell');

  // Tasks
  grunt.registerTask('default', ['coffee', 'connect', 'jasmine']);
  grunt.registerTask('test', ['connect', 'jasmine']);
  grunt.registerTask('dev', ['coffee', 'connect', 'jasmine', 'echoJasmineUrl', 'watch']);
  grunt.registerTask('report', ['coffee', 'plato', 'shell:openPlato'])

};