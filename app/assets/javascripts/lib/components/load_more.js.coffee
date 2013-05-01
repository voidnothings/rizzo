# ------------------------------------------------------------------------------
# @constructor
# Replace pagination with a load more button
# ------------------------------------------------------------------------------

define ['jquery','lib/extends/events'], ($, EventEmitter ) ->

  class LoadMore

    $.extend(@prototype, EventEmitter)

    config:
      el: '.lodgings-footer'
      title: 'Show more'
      idleTitle: 'Loading ...'
      visible: true

    constructor : (args = {}) ->
      $.extend @config, args
      @currentPage = 1
      @pageOffsets = '0'
      @init()

    init: ->  
      @$el = $(@config.el)
      if !@config.visible
        @$el.hide()
      @clean()
      @add()
      @listen()

    clean: ->
      @$el.empty()
      
    add: ->
      container = $('<div>').css('text-align', 'center')
      @$btn = $('<a>').attr('id', 'js-load-more').addClass('btn btn--load full-width').text(@config.title)
      @$el.append(container.append(@$btn))

    hide: ->
      @$el.addClass('is-hidden')
      @config.visible = false
    
    show: ->
      @$el.removeClass('is-hidden')
      @config.visible = true

    reset: ->
      @currentPage = 1

    block: ->
      @$btn.addClass('loading disabled').text(@config.idleTitle)

    unblock: ->
      @$btn.removeClass('loading disabled').text(@config.title)

    serialize: ->
      {page: @currentPage}

    currentParams: ->
      if @currentPage is 1
        {}
      else
        @serialize()

    listen: () ->
      @$el.on 'click', '#js-load-more', (e) =>
        e.preventDefault()
        @currentPage += 1
        @trigger(':click', @serialize())


