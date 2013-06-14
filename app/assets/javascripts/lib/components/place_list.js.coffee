define ['jquery', 'lib/extends/events', 'lib/utils/page_state'], ($, EventEmitter, PageState) ->

  class PlacesList extends PageState

    $.extend(@prototype, EventEmitter)

    config :
      el: null
      list: null
      LISTENER: '#js-card-holder'


    constructor: (args={}) ->
      $.extend @config, args
      @$el = $(@config.el)
      @init() unless @$el.length is 0

    init: ->
      @$list = @$el.find(@config.list)
      @listen()


    # Subscribe
    listen: ->  
      $(@config.LISTENER).on ':cards/received', =>
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
