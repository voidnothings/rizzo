module.exports = function(grunt) {
  'use strict';

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    imageoptim: {
      files: [
        'app/assets/images'
      ],
      options: {
        // also run images through ImageAlpha.app before ImageOptim.app
        imageAlpha: true,
        // also run images through JPEGmini.app after ImageOptim.app
        jpegMini: false,
        // quit all apps after optimisation
        quitAfter: true
      }
    },
    grunticon: {
      myIcons: {
        options: {
          src: "./app/assets/images/src",
          dest: "./app/assets/stylesheets/icons",
          cssprefix: "icon--",
          defaultWidth: "32px",
          pseudoElems: true,
          customSelectors: {
            "sprite-11": ".icon--sprite-11--before:before"
          }
        }
      }
    },
    svgmin: {
      options: {
        plugins: [
          {
            removeViewBox: false
          }
        ]
      },
      dist: {
        files: [
          {
            "expand": true,
            "cwd": "./app/assets/images/src",
            "src": ["*.svg"],
            "dest": "./app/assets/images/src",
            "ext": ".svg"
          }
        ]
      }
    },
    shell: {
      clean: {
        command: "rm -rf app/assets/images/png"
      },
      move: {
        command: "mv app/assets/stylesheets/icons/png app/assets/images"
      }
    }
  });

  grunt.loadNpmTasks('grunt-imageoptim');
  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-grunticon');
  grunt.loadNpmTasks('grunt-svgmin');

  // Tasks
  grunt.registerTask('default', ['svgmin', 'grunticon', 'shell:clean', 'shell:move']);
  grunt.registerTask('imageoptim', ['imageoptim']);

};