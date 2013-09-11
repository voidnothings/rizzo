require ['jquery', 'public/assets/javascripts/lib/utils/image_helper.js'], ($, ImageHelper) ->

  describe 'ImageHelper', ->
    beforeEach ->
      loadFixtures('image_helper.html');
      window.image_helper = new ImageHelper()
      window.config = 
        container: '.img-container',
        img: '.img'

      image_helper.detectOrientation config
      image_helper.detectRelativeDimensions config
      image_helper.centerWithinContainer config

    describe 'Object', ->
      it 'is defined', ->
        expect(image_helper).toBeDefined()

    describe 'Orientation:', ->
      it 'detects landscape', ->
        expect($('#landscape .img').hasClass('is-landscape')).toBe(true)
      it 'detects portrait', ->
        expect($('#portrait .img').hasClass('is-portrait')).toBe(true)

    describe 'Height/width relative to container:', ->
      it 'detects when the image is taller', ->
        expect($('#taller .img').hasClass('is-taller')).toBe(true)
      it 'detects when the image is wider', ->
        expect($('#wider .img').hasClass('is-wider')).toBe(true)

    describe 'Offset center positioning:', ->
      it 'centers vertically', ->
        expect($('#centerV .img').css('marginLeft')).toBe("-100px")
      it 'centers horizontally', ->
        expect($('#centerH .img').css('marginTop')).toBe("-200px")
