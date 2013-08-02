# ------------------------------------------------------------------------------
# 
# Creates a slider style gallery
# 
# ------------------------------------------------------------------------------

define ['jquery'], ($) ->

  class Slider

    LISTENER = '#js-slider'

    # Default config
    config =
      slides: ".slider__slide"
      slides_container: ".slider__container"

    # @params {}
    # $el: {string} selector for parent element
    # slides: {string} selector for the individual slide elements.
    # slides_container: {string} selector for the element containing the slides
    constructor: (args) ->
      $.extend config, args

      @current_slide = 1
      @$el = $(config.el)
      @slides = config.slides
      @slides_container = @$el.find(config.slides_container)
      @$slider_controls = $('<div class="slider__controls no-print"></div>')
      @$next = $('<a href="#" class="slider__control slider__control--next">1 of '+@$el.find(@slides).length+'</a>')
      @$prev = $('<a href="#" class="slider__control slider__control--prev">1 of '+@$el.find(@slides).length+'</a>')
      @$legacy = $('html.ie7, html.ie8, body.browserIE7, body.browserIE8')

      @init() unless @$el.length is 0

      # Polyfill for resizer in IE7/8
      @$legacy.find('.js-resizer').on 'click', ->
        $('input[name="'+$(this).attr('for')+'"]').toggleClass('is-checked')

    init: ->
      @$slider_controls.append(@$next).append(@$prev)
      @slides_container.append(@$slider_controls)

      @_setupSlideClasses()

      @$next.on 'click', =>
        @_nextSlide()
        return false
      @$prev.on 'click', =>
        @_previousSlide()
        return false

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

    _nextSlide: ->
      slides = @$el.find(@slides)
      current = @$el.find(@slides+'.is-current')
      index = slides.index(current) + 1 # +1 since .index is zero based.

      @_resetSlideClasses()

      # Wrap around if at the end
      if index is slides.length
        @_setupSlideClasses()
      else if index is slides.length - 1
        current.addClass('is-prev').next().addClass('is-current')
        @$el.find(@slides+':first').addClass('is-next')
      else
        current.addClass('is-prev').next().addClass('is-current').next().addClass('is-next')

      # This is to help with the slide stack order which is different depending on the direction of slide movement.
      $(@slides+'.is-next').addClass('js-bottom-layer')
      $(@slides+'.is-prev').addClass('js-middle-layer')

      @_updateCount()
      
    _previousSlide: ->
      slides = @$el.find(@slides)
      current = @$el.find(@slides+'.is-current')
      index = slides.index(current) + 1 # +1 since .index is zero based.

      @_resetSlideClasses()

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
      $(@slides+'.is-prev').addClass('js-bottom-layer')
      $(@slides+'.is-next').addClass('js-middle-layer')

      @_updateCount()

    _goToSlide: (index) ->
      slides = @$el.find(@slides)
      current = @$el.find(@slides+'.is-current')
      index = index-1 # zero base
      
      return false if current[0] is slides.eq(index)[0]

      # Remove the positioning for what's currently the previous slide. Recalced later.
      $(@slides+'.is-prev').removeClass('is-prev')

      # First, the slide we're trying to go to must become the Next slide in the order.
      $(@slides+'.is-next').removeClass('is-next')
      slides.eq(index).addClass('is-next')

      # Give the above change time to take effect since it needs to finish getting to the 'next' position before moving to 'current'.
      setTimeout =>
        @_resetSlideClasses()

        # Transition the slides now.
        current.addClass('is-prev js-middle-layer')
        slides.eq(index).addClass('is-current')

        # Wait for that transition to finish, then reset the prev and next ones *around the current slide*
        setTimeout =>
          current.removeClass('is-prev js-middle-layer')

          # Use modulus to wrap around to the beginning if at the end, but in all other cases, carry on as normal.
          slides.eq((index+1) % slides.length).addClass('is-next js-bottom-layer')
          if (index-1 < 0)
            slides.eq(slides.length-1).addClass('is-prev js-bottom-layer')
          else
            slides.eq(index-1).addClass('is-prev js-bottom-layer')

          @_updateCount()
        , 500
      , 500


    _updateCount: ->
      current = $('.slider__control--next').html()
      index = @$el.find(@slides).index(@$el.find(@slides+'.is-current')) + 1

      $('.slider__control--next, .slider__control--prev').html(current.replace(/(^[0-9]+)/, index))

    _setupSlideClasses: ->
      @$el.find(@slides+':first').addClass('is-current').next().addClass('is-next')
      @$el.find(@slides+':last').addClass('is-prev')

    _resetSlideClasses: ->
      classes = ['is-current', 'is-next', 'is-prev', 'js-bottom-layer', 'js-middle-layer']

      for name in classes
        @$el.find(@slides+'.'+name).removeClass(name)
