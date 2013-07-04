define ['jquery', 'lib/extends/events', 'lib/utils/page_state'], ($, EventEmitter, PageState) ->

  class PlacesList extends PageState

    $.extend(@prototype, EventEmitter)

    LISTENER = '#js-card-holder'

    # @params {}
    # el: {string} selector for parent element
    # list: {string} delimited list of child selectors
    constructor: (args) ->
      @$el = $(args.el)
      @$list = $(args.list)
      @init() unless @$el.length is 0

    init: ->
      @$list = @$el.find(@$list)
      @listen()

    # Subscribe
    listen: ->  
      $(LISTENER).on ':cards/received', =>
        @_update()

    # Private
    _update: () ->
      newParams = @getParams()
      for item in @$list
        link = item.href.split('?')[0]
        item.href = (link + '?' + newParams)

