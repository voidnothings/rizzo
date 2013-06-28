require ['public/assets/javascripts/lib/components/slider.js'], (Slider) ->

  describe 'Slider', ->

    LISTENER = '#js-slider'

    config =
      el: "#js-slider"
      slides: ".js-slide"
      slide_container: ".js-slides-container"

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
        expect($('.js-slide:first').hasClass('is-current')).toBe(true)

      it 'marks off the next/previous slides', ->
        expect($('.js-slide:first').next().hasClass('is-next')).toBe(true)
        expect($('.js-slide:last').hasClass('is-prev')).toBe(true)

      it 'has the correct slides state', ->
        expect($('.js-slider-next').html()).toBe("1 of 5")

    describe 'functionality:', ->

      beforeEach ->
        loadFixtures('slider.html')
        window.slider = new Slider(config)

      it 'updates the slide counter after navigating', ->
        slider._nextSlide()
        expect($('.js-slider-next').html()).toBe('2 of 5')

      it 'goes to the next slide (first -> second)', ->
        slider._nextSlide()
        expect($('.js-slide').eq(0).is('.is-prev')).toBe(true)
        expect($('.js-slide').eq(1).is('.is-current')).toBe(true)
        expect($('.js-slide').eq(2).is('.is-next')).toBe(true)

      it 'goes to the previous slide (third -> second)', ->
        slider._nextSlide()
        slider._nextSlide()
        slider._previousSlide()
        expect($('.js-slide').eq(0).is('.is-prev')).toBe(true)
        expect($('.js-slide').eq(1).is('.is-current')).toBe(true)
        expect($('.js-slide').eq(2).is('.is-next')).toBe(true)

      it 'wraps "is-prev" to end (second -> first)', ->
        slider._nextSlide()
        slider._previousSlide()
        expect($('.js-slide').eq(4).is('.is-prev')).toBe(true)
        expect($('.js-slide').eq(0).is('.is-current')).toBe(true)
        expect($('.js-slide').eq(1).is('.is-next')).toBe(true)

      it 'wraps "is-next" to beginning (second last -> last)', ->
        slider._nextSlide() # 2
        slider._nextSlide() # 3
        slider._nextSlide() # 4
        slider._nextSlide() # 5
        expect($('.js-slide').eq(3).is('.is-prev')).toBe(true)
        expect($('.js-slide').eq(4).is('.is-current')).toBe(true)
        expect($('.js-slide').eq(0).is('.is-next')).toBe(true)

      it 'wraps "is-current" to end (first -> last)', ->
        slider._previousSlide()
        expect($('.js-slide').eq(3).is('.is-prev')).toBe(true)
        expect($('.js-slide').eq(4).is('.is-current')).toBe(true)
        expect($('.js-slide').eq(0).is('.is-next')).toBe(true)

      it 'wraps "is-current" from end to beginning (last -> first)', ->
        slider._previousSlide()
        slider._nextSlide()
        expect($('.js-slide').eq(4).is('.is-prev')).toBe(true)
        expect($('.js-slide').eq(0).is('.is-current')).toBe(true)
        expect($('.js-slide').eq(1).is('.is-next')).toBe(true)
  
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

  # TODO: account for resizing and resize handler.