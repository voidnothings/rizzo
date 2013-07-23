module.exports = function(grunt) {
  'use strict';

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    grunticon: {
      myIcons: {
        options: {
          src: "app/assets/images/",
          dest: "app/assets/stylesheets/_icons",
          cssprefix: "icon--",
          defaultWidth: "32px"
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
            "cwd": "./app/assets/images",
            "src": ["*.svg"],
            "dest": "./app/assets/images",
            "ext": ".svg"
          }
        ]
      }
    }
  });

  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-grunticon');
  grunt.loadNpmTasks('grunt-svgmin');

  // Tasks
  grunt.registerTask('default', ['svgmin', 'grunticon']);

};