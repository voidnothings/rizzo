module.exports = function(grunt) {
  'use strict';

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    grunticon: {
      myIcons: {
        options: {
          src: "./app/assets/images/src",
          dest: "./app/assets/stylesheets/_icons",
          cssprefix: "icon--",
          defaultWidth: "32px",
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
        command: "mv app/assets/stylesheets/_icons/png app/assets/images"
      }
    }
  });

  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-grunticon');
  grunt.loadNpmTasks('grunt-svgmin');

  // Tasks
  grunt.registerTask('default', ['svgmin', 'grunticon', 'shell:clean', 'shell:move']);

};