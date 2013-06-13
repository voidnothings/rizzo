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
      @$el = $(@config.el)
      @init() unless @$el.length is 0

    init: ->  
      @_hide() if !@config.visible
      @_clean()
      @_add()
      @listen()
      @broadcast()



    # Subscribe
    listen: ->
      $(@config.LISTENER).on ':cards/request', =>
        @_block()
        @_reset()

      $(@config.LISTENER).on ':cards/received', (e, data) =>
        @_unblock()
        if data.pagination.total is 0 or data.pagination.current is data.pagination.total then @_hide() else @_show()

      $(@config.LISTENER).on ':cards/append/received', (e, data) =>
        @_unblock()
        if data.pagination.total is 0 or data.pagination.current is data.pagination.total then @_hide() else @_show()

    # Publish
    broadcast: ->
      @$el.on 'click', '#js-load-more', (e) =>
        e.preventDefault()
        @currentPage += 1
        @_block()
        @trigger(':cards/append', [@_serialize(), {callback: "trackPagination"}])

    # Private

    _clean: ->
      @$el.empty()
      
    _add: ->
      container = $('<div>').css('text-align', 'center')
      @$btn = $('<a>').attr('id', 'js-load-more').addClass('btn btn--load full-width').text(@config.title)
      @$el.append(container.append(@$btn))

    _show: ->
      @$el.removeClass('is-hidden')
      @config.visible = true

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

