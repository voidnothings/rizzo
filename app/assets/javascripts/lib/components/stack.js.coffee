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
        @_addLoader()

      $(@config.LISTENER).on ':page/received', (e, data) =>
        @_removeLoader()
        @_clear()
        @_add(data.content)

      $(@config.LISTENER).on ':page/append/received', (e, data) =>
        @_add(data.content)

      $(@config.LISTENER).on ':search/change', (e) =>
        @_block()


    # Publish
    broadcast: ->
      # Cancel search and show info card
      @$el.on 'click', '.card--disabled', (e) =>
        e.preventDefault()
        @_unblock()
        @trigger(':search/hide')
        false

      # Clear all filters when there are no results
      @$el.on 'click', '.js-clear-all-filters', (e) =>
        e.preventDefault()
        @trigger(':filter/reset')

      # Adjust dates when there are no results
      @$el.on 'click', '.js-adjust-dates', (e) =>
        e.preventDefault()
        @trigger(':search/change')


    # Private

    _addLoader: ->
      @$el.addClass('is-loading')

    _removeLoader: ->
      @$el.removeClass('is-loading')

    _block: ->
      @$el.find(@config.types).addClass('card--disabled')

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