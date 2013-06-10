define ['jquery', 'lib/extends/events'], ($, EventEmitter) ->
  
  class GroupToggle extends EventEmitter

    constructor: (args={}) ->
      @config =
        el: '.js-group-toggle'
        handler: '.js-group-handler'
        content: '.js-group-content'
      $.extend @config, args

      @$el = $(@config.el)
      @$handler = $("#{@config.el} #{@config.handler}")
      @$content = $("#{@config.el} #{@config.content}")
      @listen()     

    listen: ->
      @$handler.on('click' , =>
        @_toggle()
      )
      
    disable: ->
      @$content.hide()
      @$handler.hide()

    enable: -> 
      @$content.show()
      @$handler.show()
    
    _toggle: ->
      @$el.toggleClass('is-close is-open')

