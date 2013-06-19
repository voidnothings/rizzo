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
      i = 0
      while i < @$list.length
        link = @$list[i].href.split('?')
        newLink = link + newParams 
        @$list[i].href = newLink
        i++
