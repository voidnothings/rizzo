# ------------------------------------------------------------------------------
# 
# Creates a slider style gallery
# 
# ------------------------------------------------------------------------------

define ['jquery','lib/extends/events','touchwipe','pointer'], ($, touchwipe, pointer, EventEmitter) ->

  class Slider

    $.extend(@prototype, EventEmitter)

    LISTENER = '#js-slider'

    # @params {}
    # el: {string} selector for parent element
    # list: {string} delimited list of selectors for cards
    constructor: (args) ->
      $.extend @config, args
      @$el = $(args.el)
      @slides = args.slides
      @$slide_container = $(args.slide_container)
      @init() unless @$el.length is 0

    init: ->
      @$slide_container.after('<div class="js-slider-controls"><a href="#" class="js-slider-next">1 of '+$(@slides).length+'</a><a href="#" class="js-slider-prev">1 of '+$(@slides).length+'</a></div>')
      $(@slides+':first').addClass('is-current')
      $('.js-slider-next').on 'click', =>
        @_nextSlide()
      $('.js-slider-prev').on 'click', =>
        @_previousSlide()

    # Private

    _nextSlide: ->
      index = $(@slides).index($(@slides+'.is-current')) + 1 # +1 since .index is zero based.
      current = $(@slides+'.is-current').removeClass('is-current')

      # Wrap around if at the end
      if index is $(@slides).length
        $(@slides+':first').addClass('is-current')
      else
        current.next().addClass('is-current')

      @_updateCount()
      
    _previousSlide: ->
      index = $(@slides).index($(@slides+'.is-current')) + 1
      current = $(@slides+'.is-current').removeClass('is-current')

      # Wrap around if at the beginning
      if index is 1
        $(@slides+':last').addClass('is-current')
      else
        current.prev().addClass('is-current')

      @_updateCount()

    _updateCount: ->
      current = $('.js-slider-next').html()
      index = $(@slides).index($(@slides+'.is-current')) + 1

      $('.js-slider-next, .js-slider-prev').html(current.replace(/(^[0-9]+)/, index))
