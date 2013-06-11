define ['jquery', 'lib/extends/events'], ($, EventEmitter ) ->

  class StackList

    $.extend(@prototype, EventEmitter)

    config :
      el: null
      list: null
      LISTENER: '#js-card-holder'
      analytics:
        callback: "trackStack"
      
    constructor: (args={}) ->
      $.extend @config, args
      @init()

    init: ->
      @$el = $(@config.el)
      @$list = @$el.find(@config.list)
      @broadcast()

    
    # Publish
    broadcast: ->  
      @$el.on 'click' , @config.list, (e) =>
        e.preventDefault()
        $this = $(e.currentTarget)
        @_select($this)
        @config.analytics.url = $this.attr('href')
        @config.analytics.stack = $this.data("card-kind") or ""
        @trigger(':page/request', [{url: @config.analytics.url}, @config.analytics])

    
    # Private
    _select: (el) ->
      @$list.removeClass('nav__item--current--stack')
      el.addClass('nav__item--current--stack')
