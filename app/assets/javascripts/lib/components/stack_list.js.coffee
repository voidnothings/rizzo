define ['jquery', 'lib/base/events'], ($, EventEmitter ) ->

  class StackList

    $.extend(@prototype, EventEmitter)

    config :
      el: null
      list: null
      
    constructor: (args={}) ->
      $.extend @config, args
      @init()

    init: ->
      @$el = $(@config.el)
      @$list = @$el.find(@config.list)
      @listen()

    listen: ->  
      @$el.on('click',@config.list, (e) =>
        e.preventDefault()
        @select(e.currentTarget)
        false
      )

    select: (target) ->
      @$list.removeClass('nav__item--current--stack')
      $(target).addClass('nav__item--current--stack')
      @navigate($(target).attr('href'), target)

    selectByHref: (href) ->
      @select(@$eo.find("nav__item--stack[href=#{href}]"))

    navigate: (url, target) ->
      @trigger(':click', {url: url, target: target})

