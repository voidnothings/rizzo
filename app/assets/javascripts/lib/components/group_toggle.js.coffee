define ['jquery', 'lib/extends/events'], ($, EventEmitter) ->
  
  class GroupToggle extends EventEmitter

    config :
      el: '.js-group-toggle'
      handler: '.js-group-handler'
      content: '.js-group-content'
      
    constructor: (args={}) ->
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
      @_manageMaxHeight()
      @$el.toggleClass('is-closed is-open')

    _getHeight: ->
      Number(@$content.outerHeight())

    _manageMaxHeight: ->  
      @$content.on('transitionend webkitTransitionEnd oTransitionEnd otransitionend', =>
        height = @getHeight()
        if height is 0
          @$content.attr( { style: '' } )
        else  
          @$content.css( { maxHeight: "#{height}px" } )
      )
      if @getHeight() isnt 0
        @$content.attr( { style: '' } )

