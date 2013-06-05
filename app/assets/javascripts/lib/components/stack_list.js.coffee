define ['jquery', 'lib/extends/events'], ($, EventEmitter ) ->

  class StackList

    $.extend(@prototype, EventEmitter)

    config :
      el: null
      list: null
      LISTENER: '#js-card-holder'
      
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
        @_select(e.currentTarget)
        @trigger(':page/request', {url: $(e.currentTarget).attr('href')})

    
    # Private
    _select: (target) ->
      @$list.removeClass('nav__item--current--stack')
      $(target).addClass('nav__item--current--stack')
