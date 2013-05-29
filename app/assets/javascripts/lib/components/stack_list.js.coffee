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
      @listen()

    listen: ->  
      @$el.on 'click' , @config.list, (e) =>
        e.preventDefault()
        @select(e.currentTarget)
        @trigger(':page/request', {url: $(e.currentTarget).attr('href')})

    select: (target) ->
      @$list.removeClass('nav__item--current--stack')
      $(target).addClass('nav__item--current--stack')
