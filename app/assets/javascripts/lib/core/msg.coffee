define ['jquery'], ($)->

  class Msg

    @version = '0.0.1'

    constructor: (@args = {}) ->
      @options =
        target: 'body'
        delay: 1000
      @add(@build(@args.content))

    build: () ->
      @msg = "<div class='row #{@args.style}'><div class='row__inner'><div class='row__inner__msg'>#{@closeElement(@args.btnText)}#{@args.content}</div></div></div>"
      
    closeElement: (text = 'Close Message')->
      "<a class='btn--regular btn--gray js-close-msg'>#{text}</a>"

    add: (el) ->
      $(@options.target).prepend(el)
      $('a.js-close-msg').on('click', (e)=> @removeMsg(e))
      if @args.delegate and @args.delegate.onAdd()
        @args.delegate.onAdd()

    removeMsg: (e)->
      $("div.#{@args.style}").remove()
      if @args.delegate and @args.delegate.onRemove()
        @args.delegate.onRemove()


