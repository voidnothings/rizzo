require ['jquery', 'public/assets/javascripts/lib/utils/image_helper.js'], ($, ImageHelper) ->

  describe 'ImageHelper', ->
    beforeEach ->
      loadFixtures('image_helper.html');
      window.ImageHelper = new ImageHelper()
      window.config = 
        container: '.img-container',
        img: '.img'

    describe 'Object', ->
      it 'is defined', ->
        expect(ImageHelper).toBeDefined()

    describe 'Orientation:', ->
      beforeEach ->
        ImageHelper.detectOrientation config

      it 'detects landscape', ->
        expect($('#landscape .img').hasClass('is-landscape')).toBe(true)
      it 'detects portrait', ->
        expect($('#portrait .img').hasClass('is-portrait')).toBe(true)

    describe 'Landscape height/width relative to container:', ->
      beforeEach ->
        ImageHelper.detectRelativeDimensions config

      it 'detects when the image is taller', ->
        expect($('#taller .img').hasClass('is-taller')).toBe(true)
      it 'detects when the image is wider', ->
        expect($('#wider .img').hasClass('is-wider')).toBe(true)

    describe 'Landscape offset center positioning:', ->
      beforeEach ->
        ImageHelper.centerWithinContainer config

      it 'centers vertically', ->
        expect($('#taller .img').css('marginTop')).toBe("50px")
      it 'centers horizontally', ->
        expect($('#wider .img').css('marginLeft')).toBe("50px")
