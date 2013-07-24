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
    }

  });

  grunt.loadNpmTasks('grunt-imageoptim');

  // Tasks
  grunt.registerTask('default', ['imageoptim']);

};