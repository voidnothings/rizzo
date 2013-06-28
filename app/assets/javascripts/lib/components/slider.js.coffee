# ------------------------------------------------------------------------------
# 
# Creates a slider style gallery
# 
# ------------------------------------------------------------------------------

define ['jquery','pointer','touchwipe'], ($, pointer, touchwipe) ->

  class Slider

    LISTENER = '#js-slider'

    # Default config
    config =
      el: "#js-slider"
      slides: ".js-slide"
      slide_container: ".js-slides-container"

    # @params {}
    # $el: {string} selector for parent element
    # slides: {string} selector for the individual slide elements.
    constructor: (args) ->
      $.extend config, args
      @$el = $(config.el)
      @slides = config.slides
      @slides_container = @$el.find('.js-slides-container')
      @init() unless @$el.length is 0

    init: ->
      @slides_container.append('<div class="js-slider-controls"></div>')
      @$el.find('.js-slider-controls')
        .append('<a href="#" class="js-slider-next">1 of '+$(@slides).length+'</a>')
        .append('<a href="#" class="js-slider-prev">1 of '+$(@slides).length+'</a>')
      if _has3d()
        @slides_container.addClass('supports-transform')

      @_setupSlideClasses()

      $('.js-slider-next').on 'click', =>
        @_nextSlide()
      $('.js-slider-prev').on 'click', =>
        @_previousSlide()

      # Swiping navigation.
      @$el.touchwipe =>
        wipeLeft: =>
          @_nextSlide()
        wipeRight: =>
          @_previousSlide()
        min_move_x: 20
        min_move_y: 20
        preventDefaultEvents: true

    # Private

    _nextSlide: ->
      slides = $(@slides)
      current = $(@slides+'.is-current')
      index = slides.index(current) + 1 # +1 since .index is zero based.

      @_resetSlideClasses()

      # Wrap around if at the end
      if index is slides.length
        @_setupSlideClasses()
      else if index is slides.length - 1
        current.addClass('is-prev').next().addClass('is-current')
        $(@slides+':first').addClass('is-next')
      else
        current.addClass('is-prev').next().addClass('is-current').next().addClass('is-next')

      @_updateCount()
      
    _previousSlide: ->
      slides = $(@slides)
      current = $(@slides+'.is-current')
      index = slides.index(current) + 1 # +1 since .index is zero based.

      @_resetSlideClasses()

      # Wrap around if at the beginning
      if index is 1
        $(@slides+':last').addClass('is-current').prev().addClass('is-prev')
        $(@slides+':first').addClass('is-next')
      else if index is 2
        current.addClass('is-next').prev().addClass('is-current')
        $(@slides+':last').addClass('is-prev')
      else
        current.addClass('is-next').prev().addClass('is-current').prev().addClass('is-prev')

      @_updateCount()

    _updateCount: ->
      current = $('.js-slider-next').html()
      index = $(@slides).index($(@slides+'.is-current')) + 1

      $('.js-slider-next, .js-slider-prev').html(current.replace(/(^[0-9]+)/, index))

    _setupSlideClasses: ->
      $(@slides+':first').addClass('is-current').next().addClass('is-next')
      $(@slides+':last').addClass('is-prev')

    _resetSlideClasses: ->
      $(@slides+'.is-current, '+@slides+'.is-next, '+@slides+'.is-prev').removeClass('is-current is-next is-prev')

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
