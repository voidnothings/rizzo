# ------------------------------------------------------------------------------
# @constructor
# Replace pagination with a load more button
# ------------------------------------------------------------------------------

define ['jquery','lib/extends/events'], ($, EventEmitter ) ->

  class LoadMore

    $.extend(@prototype, EventEmitter)

    config:
      el: '.pagination-footer'
      title: 'Show more'
      idleTitle: 'Loading ...'
      visible: true
      LISTENER: '#js-card-holder'

    constructor : (args = {}) ->
      $.extend @config, args
      @currentPage = 1
      @pageOffsets = '0'
      @init()

    init: ->  
      @$el = $(@config.el)
      @_hide() if !@config.visible
      @_clean()
      @_add()
      @listen()
      @broadcast()

    # Publish
    broadcast: ->
      @$el.on 'click', '#js-load-more', (e) =>
        e.preventDefault()
        @currentPage += 1
        @_block()
        @trigger(':page/append', @_serialize())

    # Subscribe
    listen: ->
      $(@config.LISTENER).on ':page/request', =>
        @_block()
        @_reset()

      $(@config.LISTENER).on ':page/received', =>
        @_unblock()

      $(@config.LISTENER).on ':page/append/received', =>
        @_unblock()


    # Private

    _clean: ->
      @$el.empty()
      
    _add: ->
      container = $('<div>').css('text-align', 'center')
      @$btn = $('<a>').attr('id', 'js-load-more').addClass('btn btn--load full-width').text(@config.title)
      @$el.append(container.append(@$btn))

    _hide: ->
      @$el.addClass('is-hidden')
      @config.visible = false

    _reset: ->
      @currentPage = 1

    _block: ->
      @$btn.addClass('loading disabled').text(@config.idleTitle)

    _unblock: ->
      @$btn.removeClass('loading disabled').text(@config.title)

    _serialize: ->
      {page: @currentPage}

