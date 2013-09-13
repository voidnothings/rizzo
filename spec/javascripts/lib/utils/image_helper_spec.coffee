require ['jquery', 'public/assets/javascripts/lib/utils/image_helper.js'], ($, ImageHelper) ->

  describe 'ImageHelper', ->
    beforeEach ->
      loadFixtures('image_helper.html');
      window.image_helper = new ImageHelper()

      image_helper.processImages
        container: '.img-container',
        img: '.img'

    describe 'Object', ->
      it 'is defined', ->
        expect(image_helper).toBeDefined()

    describe 'Orientation:', ->
      # Detection
      it 'detects landscape', ->
        expect(image_helper.detectOrientation($('#landscape .img'))).toBe('landscape')
      it 'detects portrait', ->
        expect(image_helper.detectOrientation($('#portrait .img'))).toBe('portrait')
      it 'detects squarish (i.e.: neither quite portrait nor landscape)', ->
        expect(image_helper.detectOrientation($('#squarish .img'))).toBe('squarish')

      # Class names
      it 'adds `is-landscape` class', ->
        expect($('#landscape .img').hasClass('is-landscape')).toBe(true)
      it 'adds `is-portrait` class', ->
        expect($('#portrait .img').hasClass('is-portrait')).toBe(true)

    describe 'Height/width relative to container:', ->
      it 'detects when the image is taller', ->
        expect($('#taller .img').hasClass('is-taller')).toBe(true)
      it 'detects when the image is wider', ->
        expect($('#wider .img').hasClass('is-wider')).toBe(true)

    describe 'Offset center positioning:', ->
      it 'centers vertically', ->
        expect($('#centerV .img')[0].style.marginLeft).toBe("-12.5%")
      it 'centers horizontally', ->
        expect($('#centerH .img')[0].style.marginTop).toBe("-50%")
