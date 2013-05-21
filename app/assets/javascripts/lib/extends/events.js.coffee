define ['jquery'], ($) ->

  EventEmitter =

    _JQInit: ->
      @_JQ = $(this)

    trigger: (evt, data) ->
      # @_JQ or @_JQInit()
      @$el.trigger(evt, data)

    on: (evt, handler) ->
      @_JQ or @_JQInit()
      @_JQ.bind(evt, handler)

    off: (evt, handler) ->
      @_JQ or @_JQInit()
      @_JQ.unbind(evt, handler)