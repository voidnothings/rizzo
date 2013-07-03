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
      @$slider_controls = $('<div class="slider__controls"></div>')
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

      if _has3d()
        @slides_container.addClass('supports-3d')

      @_setupSlideClasses()

      @$next.on 'click', =>
        @_nextSlide()
        return false
      @$prev.on 'click', =>
        @_previousSlide()
        return false

      if @$legacy.length is 0
        require ['pointer','touchwipe'], =>
          # Swiping navigation.
          @$el.touchwipe
            wipeLeft: =>
              @_nextSlide()
            wipeRight: =>
              @_previousSlide()
            min_move_x: 100
            min_move_y: 100
            preventDefaultEvents: true

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

      @_updateCount()

    _updateCount: ->
      current = $('.slider__control--next').html()
      index = @$el.find(@slides).index(@$el.find(@slides+'.is-current')) + 1

      $('.slider__control--next, .slider__control--prev').html(current.replace(/(^[0-9]+)/, index))

    _setupSlideClasses: ->
      @$el.find(@slides+':first').addClass('is-current').next().addClass('is-next')
      @$el.find(@slides+':last').addClass('is-prev')

    _resetSlideClasses: ->
      @$el.find(@slides+'.is-current, '+@slides+'.is-next, '+@slides+'.is-prev').removeClass('is-current is-next is-prev')

    _has3d = ->
      el = document.createElement("p")
      has3d = undefined
      transforms =
        webkitTransform: "-webkit-transform"
        OTransform: "-o-transform"
        msTransform: "-ms-transform"
        MozTransform: "-moz-transform"
        transform: "transform"
      
      # Add it to the body to get the computed style.
      document.body.insertBefore el, null
      for t of transforms
        if el.style[t] isnt `undefined`
          el.style[t] = "translate3d(1px,1px,1px)"
          has3d = window.getComputedStyle(el).getPropertyValue(transforms[t])
      document.body.removeChild el
      has3d isnt `undefined` and has3d.length > 0 and has3d isnt "none"
