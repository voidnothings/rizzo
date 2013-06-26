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
      @$slide_container.after('<div class="js-slider-controls"><a href="#" class="js-slider-next">1 of '+@$slides.length+'</a><a href="#" class="js-slider-prev">1 of '+@$slides.length+'</a></div>')
      $(@slides+':first').addClass('is-current')
      $('.js-slider-next').on('click', @_nextSlide)
      $('.js-slider-prev').on('click', @_prevSlide)
      # @listen()
      # @broadcast()

  #   # Subscribe
  #   listen: ->
  #     $(LISTENER).on ':cards/request', =>
  #       @_block()
  #       @_addLoader()

  #     $(LISTENER).on ':cards/received', (e, data) =>
  #       @_removeLoader()
  #       @_clear()
  #       @_add(data.content)

  #     $(LISTENER).on ':cards/append/received', (e, data) =>
  #       @_add(data.content)

  #     $(LISTENER).on ':page/request', =>
  #       @_block()
  #       @_addLoader()

  #     $(LISTENER).on ':page/received', (e, data) =>
  #       @_removeLoader()
  #       @_clear()
  #       @_add(data.content)

  #     $(LISTENER).on ':search/change', (e) =>
  #       @_block()


  #   # Publish
  #   broadcast: ->
  #     # Cancel search and show info card
  #     @$el.on 'click', '.card--disabled', (e) =>
  #       e.preventDefault()
  #       @_unblock()
  #       @trigger(':search/hide')

  #     # Clear all filters when there are no results
  #     @$el.on 'click', '.js-clear-all-filters', (e) =>
  #       e.preventDefault()
  #       @trigger(':filter/reset')

  #     # Adjust dates when there are no results
  #     @$el.on 'click', '.js-adjust-dates', (e) =>
  #       e.preventDefault()
  #       @trigger(':search/change')

    # Private

    _nextSlide: ->
      $(@slides+'.is-current')
        .removeClass('is-current')
        .next().addClass('is-current')
      
    _prevSlide: ->
      $(@slides+'.is-current')
        .removeClass('is-current')
        .prev().addClass('is-current')
