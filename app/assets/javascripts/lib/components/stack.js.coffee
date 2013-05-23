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
      @broadcast()


    # Subscribe
    listen: ->
      $(@config.LISTENER).on ':page/request', =>
        @_block()

      $(@config.LISTENER).on ':page/received', (e, params) =>
        @_clear()
        @_add(params.list)

      $(@config.LISTENER).on ':page/append', (e, params) =>
        @_add(params.list)

    # Publish
    broadcast: ->
      @$el.on 'click', '.card--disabled a', (e) =>
        e.preventDefault()
        @_unblock()
        @trigger(':info/show')


    # Private

    _block: ->
      x = @$el.find(@config.types)
      x.addClass('card--disabled')

    _unblock: ->
      @$el.find(@config.types).removeClass('card--disabled')

    _clear: ->
      @$el.find(@config.types).remove()
      @$el.find('.js-error').remove()

    _add: (list)->
      $cards = $(list).addClass('card--invisible')
      @$el.append($cards)
      @_show($cards)

    _show: (cards) ->
      i = 0
      insertCards = setInterval( ->
        if i isnt cards.length
          $(cards[i]).removeClass('card--invisible')
          i++
        else
          clearInterval insertCards
      , 20)