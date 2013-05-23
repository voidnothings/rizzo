# ------------------------------------------------------------------------------
# 
# Object responsible for cards within the stack
# 
# ------------------------------------------------------------------------------

define ['jquery','lib/extends/events'], ($, EventEmitter) ->

  class Stack

    $.extend(@prototype, EventEmitter)

    config:
      el: '#js-results'
      LISTENER: '#js-card-holder'
      types: ".card--hotel, .js-nearby-accommodations, .js-stack-card-filter"

    constructor: (args = {}) ->
      $.extend @config, args
      @init()

    init: ->
      @$el = $(@config.el)
      @listen()


    # Subscribe
    listen: ->
      $(@config.LISTENER).on ':page/request', =>
        @_block()

      $(@config.LISTENER).on ':page/received', =>
        @_unblock()


    # Private

    _block: ->
      x = @$el.find(@config.types)
      x.addClass('card--disabled')

    _unblock: ->
      @$el.find(@config.types).removeClass('card--disabled')