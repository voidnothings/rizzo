require ['public/assets/javascripts/lib/components/slider.js'], (Slider) ->

  describe 'Slider', ->

    LISTENER = '#js-slider'

    config =
      el: "#js-slider"
      slides: ".slide"
      slide_container: ".slide-container"

    params =
      size: 
        small:
          height: 290
          width: 427
        large:
          height: 580
          width: 854

    describe 'object', ->
      it 'is defined', ->
        expect(Slider).toBeDefined()

    describe 'initialising', ->
      beforeEach ->
        window.slider = new Slider(config)
        spyOn(slider, "init")

      it 'does not initialise when the parent element does not exist', ->
        expect(slider.init).not.toHaveBeenCalled()

    describe 'set up', ->
      beforeEach ->
        loadFixtures('slider.html')
        window.slider = new Slider(config)

      it 'adds the next/prev links', ->
        expect($('.js-slider-next').length).toBeGreaterThan(0)
        expect($('.js-slider-prev').length).toBeGreaterThan(0)

      it 'adds the `is-current` class to the first slide', ->
        expect($('.slide:first').hasClass('is-current')).toBe(true)

      it 'has the correct slides state', ->
        expect($('.js-slider-next').html()).toBe("1 of 3")

    describe 'functionality:', ->

      beforeEach ->
        loadFixtures('slider.html')
        window.slider = new Slider(config)

      it 'moves to the next slide', ->
        slider._nextSlide()
        expect($('.slide').eq(1).is('.is-current')).toBe(true)

      it 'updates the slide counter', ->
        slider._nextSlide()
        expect($('.js-slider-next').html()).toBe('2 of 3')

      it 'moves to the previous slide', ->
        slider._nextSlide()
        slider._previousSlide()
        expect($('.slide').eq(0).is('.is-current')).toBe(true)

      it 'wraps to the last slide when on the first slide', ->
        slider._previousSlide()
        expect($('.slide').eq(2).is('.is-current')).toBe(true)

      it 'wraps to the first slide when on the last slide', ->
        slider._previousSlide()
        slider._nextSlide()
        expect($('.slide').eq(0).is('.is-current')).toBe(true)
  
    describe 'events:', ->

      beforeEach ->
        loadFixtures('slider.html')
        window.slider = new Slider(config)
        spyOn(slider, '_nextSlide');
        spyOn(slider, '_previousSlide');

      it 'next link triggers _nextSlide', ->
        $('.js-slider-next').trigger('click')
        expect(slider._nextSlide).toHaveBeenCalled()
        
      it 'prev link triggers _previousSlide', ->
        $('.js-slider-prev').trigger('click')
        expect(slider._previousSlide).toHaveBeenCalled()
      
      # TODO: Tests for Touch events (particularly swiping).
      # it 'swiping left triggers _nextSlide', ->
        
      # it 'swiping right triggers _previousSlide', ->

