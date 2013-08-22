# ------------------------------------------------------------------------------
# 
# Creates a slider style gallery
# 
# ------------------------------------------------------------------------------

define ['jquery', 'lib/extends/events'], ($, EventEmitter) ->

  class Slider

    for key, value of EventEmitter
      @prototype[key] = value

    LISTENER = '#js-slider'

    # Default config
    config =
      animateDelay: 500
      slides: ".slider__slide"
      slides_container: ".slider__container"
      deferLoading: false

    # @params {}
    # $el: {string} selector for parent element
    # slides: {string} selector for the individual slide elements.
    # slides_container: {string} selector for the element containing the slides
    constructor: (args) ->
      $.extend config, args

      @current_slide = 1
      @$el = $(config.el)
      @slides = config.slides

      if $(@slides).length < 2
        $(@slides).addClass('is-current')
        return false

      @slides_container = @$el.find(config.slides_container)
      @$slider_controls = $('<div class="slider__controls no-print"></div>')
      @$slider_pagination = $('<div class="slider__pagination no-print"></div>')
      @$next = $('<a href="#" class="slider__control slider__control--next icon--chevron-right--white--before">1 of '+@$el.find(@slides).length+'</a>')
      @$prev = $('<a href="#" class="slider__control slider__control--prev icon--chevron-left--white--after">1 of '+@$el.find(@slides).length+'</a>')
      @$legacy = $('html.ie7, html.ie8, body.browserIE7, body.browserIE8')

      @$slider_controls_container = $('.slider__controls-container')
      if @$slider_controls_container.length is 0
        @$slider_controls_container = @slides_container.addClass('slider__controls-container')
      @$slider_controls_container.addClass('at-beginning')

      @init() unless @$el.length is 0

      # Polyfill for resizer in IE7/8
      @$legacy.find('.js-resizer').on 'click', ->
        $('input[name="'+$(this).attr('for')+'"]').toggleClass('is-checked')

    init: ->
      @$slider_controls.append(@$next).append(@$prev)
      @$slider_controls_container.append(@$slider_controls)

      $(@slides).each (i, val) =>
        $slideLink = $('<a href="#" class="slider__pagination--link">'+(i+1)+'</a>')

        if i is 0
          $slideLink.addClass('is-active')

        @$slider_pagination.append($slideLink)

      @$slider_controls_container.append(@$slider_pagination)

      @_setupSlideClasses()

      slideLinks = @$slider_pagination.find('.slider__pagination--link')
      slideLinks.on 'click', (e) =>
        i = parseInt(e.target.innerHTML, 10)

        @$el.find(@slides).removeClass('is-potentially-next is-potentially-prev')
        slideLinks.removeClass('is-active').eq(i-1).addClass('is-active')

        @_goToSlide(i)
        return false
      slideLinks.on
        'mouseenter': (e) => # in
          slides = @$el.find(@slides)
          currentIndex = slides.index(slides.filter('.is-current')) + 1
          index = parseInt(e.target.innerHTML, 10)

          @$el.removeClass('is-animating')
          slides.removeClass('is-potentially-next is-potentially-prev')

          if index > currentIndex
            slides.eq(parseInt($(e.target).html(), 10) - 1).not('.is-current').addClass('is-potentially-next')
          else
            slides.eq(parseInt($(e.target).html(), 10) - 1).not('.is-current').addClass('is-potentially-prev')
          
          @_loadHiddenContent(slides) if config.deferLoading


        'mouseleave': (e) => # out
          @$el.find(@slides).removeClass('is-potentially-next is-potentially-prev')

      @$next.on 'click', =>
        @_nextSlide()
        return false

      @$prev.on 'click', =>
        @_previousSlide()
        return false

      @$next.on 'mouseenter click', =>
        @_loadHiddenContent(@$el.find(@slides)) if config.deferLoading

      @$next.on 'mouseenter click', =>
        @_loadHiddenContent(@$el.find(@slides)) if config.deferLoading


      # if @$legacy.length is 0 && !!window.addEventListener
      #   require ['pointer','touchwipe'], =>
      #     # Swiping navigation.
      #     @$el.touchwipe
      #       wipeLeft: =>
      #         @_nextSlide()
      #       wipeRight: =>
      #         @_previousSlide()
      #       min_move_x: 100
      #       min_move_y: 100
      #       preventDefaultEvents: true

    # Private

    _loadHiddenContent: (slides) ->
      @trigger(':asset/uncomment', [slides.slice(1), '[data-uncomment]'])
      config.deferLoading = false

    _nextSlide: ->
      slides = @$el.find(@slides)
      current = @$el.find(@slides+'.is-current')
      index = slides.index(current) + 1 # +1 since .index is zero based.

      @_resetSlideClasses()

      @$el.addClass('is-animating')

      # Wrap around if at the end
      if index is slides.length
        @_setupSlideClasses()
      else if index is slides.length - 1
        current.addClass('is-prev').next().addClass('is-current')
        @$el.find(@slides+':first').addClass('is-next')
      else
        current.addClass('is-prev').next().addClass('is-current').next().addClass('is-next')

      # This is to help with the slide stack order which is different depending on the direction of slide movement.
      $(@slides+'.is-next').addClass('is-bottom-layer')
      $(@slides+'.is-prev').addClass('is-middle-layer')

      @_updateCount()
      
    _previousSlide: ->
      slides = @$el.find(@slides)
      current = @$el.find(@slides+'.is-current')
      index = slides.index(current) + 1 # +1 since .index is zero based.

      @_resetSlideClasses()

      @$el.addClass('is-animating')

      # Wrap around if at the beginning
      if index is 1
        @$el.find(@slides+':last').addClass('is-current').prev().addClass('is-prev')
        @$el.find(@slides+':first').addClass('is-next')
      else if index is 2
        current.addClass('is-next').prev().addClass('is-current')
        @$el.find(@slides+':last').addClass('is-prev')
      else
        current.addClass('is-next').prev().addClass('is-current').prev().addClass('is-prev')

      # This is to help with the slide stack order which is different depending on the direction of slide movement.
      $(@slides+'.is-prev').addClass('is-bottom-layer')
      $(@slides+'.is-next').addClass('is-middle-layer')

      @_updateCount()

    _goToSlide: (index) ->
      slides = @$el.find(@slides)
      current = slides.filter('.is-current')
      currentIndex = slides.index(current) + 1
      index = index-1 # zero base
      movingForward = index > currentIndex
      movingTo = slides.eq(index)
      
      return false if current[0] is slides.eq(index)[0]

      @$el.removeClass('is-animating')

      # First, the slide we're trying to go to must become the Next/Previous slide in the order (depending on direction).
      # Remove the positioning for what's currently the previous slide. Recalced later.
      slides.removeClass('is-prev is-next is-middle-layer is-bottom-layer')
      if movingForward
        movingTo.addClass('is-next')
      else
        movingTo.addClass('is-prev')

      @$el.addClass('is-animating')

      # Transition the slides now.
      setTimeout => # Use a 0 timeout to allow for is-animate to get added in a separate cycle to the transition classes.
        if movingForward
          current.removeClass('is-current').addClass('is-prev is-middle-layer')
        else
          current.removeClass('is-current').addClass('is-next is-middle-layer')
        movingTo.removeClass('is-next is-prev').addClass('is-current')

        # Wait for that transition to finish, then reset the prev and next ones *around the current slide*
        setTimeout =>
          slides.removeClass('is-prev is-next is-middle-layer')

          # Use modulus to wrap around to the beginning if at the end, but in all other cases, carry on as normal.
          slides.eq((index+1) % slides.length).addClass('is-next is-bottom-layer')
          if (index-1 < 0)
            slides.eq(slides.length-1).addClass('is-prev is-bottom-layer')
          else
            slides.eq(index-1).addClass('is-prev is-bottom-layer')

          @_updateCount()
        , config.animateDelay
      , 0

    _updateCount: ->
      current = $('.slider__control--next').html()
      slides = @$el.find(@slides)
      index = slides.index(@$el.find(@slides+'.is-current')) + 1
      nextIndex = index + 1
      prevIndex = index - 1

      # Wrap around numbers
      if (nextIndex > slides.length)
        nextIndex = 1
      if (prevIndex < 1)
        prevIndex = slides.length
      
      @$slider_controls_container.removeClass('at-beginning at-end')
      if index is 1
        @$slider_controls_container.addClass('at-beginning')
      else if index is slides.length
        @$slider_controls_container.addClass('at-end')
      
      $('.slider__control--next').html(current.replace(/(^[0-9]+)/, nextIndex))
      $('.slider__control--prev').html(current.replace(/(^[0-9]+)/, prevIndex))

      $('.slider__pagination--link.is-active').removeClass('is-active')
      $('.slider__pagination--link').eq(index-1).addClass('is-active')

    _setupSlideClasses: ->
      @$el.find(@slides+':first').addClass('is-current').next().addClass('is-next')
      @$el.find(@slides+':last').addClass('is-prev')

      # Give the user a visual cue that there are controls before fading them out.
      setTimeout =>
        @$slider_controls.addClass('is-faded-out')
      , 1000

    _resetSlideClasses: ->
      classes = ['is-current', 'is-next', 'is-prev', 'is-bottom-layer', 'is-middle-layer']

      for name in classes
        @$el.find(@slides+'.'+name).removeClass(name)
