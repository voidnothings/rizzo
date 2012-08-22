# SectionToggle (lp.SectionToggle)
# Add an handler button to control the h-visible-size of an element
#
# Obs:
# On a early stage and still very opinionated, which means that it needs abstractions.
#
# Arguments: 
#   _args (An hash containing)
#     selector    : [string] The target element
#     text        : [array]  An array of strings with the text title for each state
#     maxHeight   : [number] The default visible height size for the target selector
#     delegate    : [object] A wrapper object for callback object [onUpdate]
#     shadow      : [boolean] Determines whether or not the text is cut off by a shadow
#
# Example:
#  args =
#    selector: 'div.partner-review-facilities'
#    text: ['more facilities', 'less facilities']
#    maxheight: maxheight
#    delegate:
#      onupdate: (section, state) =>
#        console.log(state)
#  new lp.SectionToggle(args)
# 
# Dependencies:
#   jQuery

 
define ['jquery'], ($) ->
 
  class SectionToggle
  
    @version: '0.0.1'
    
    constructor: (@args={}) ->
      @target = $(@args.selector)
      @baseHeight = $(@target).height()
      @addHandler()
    
    addHandler: ->
      if @target.height() > @args.maxHeight
        @template = "<div class='std btn-soft js-handler'>#{(@args.text)[0]}</div>"
        if @args.shadow
          @template = "<div class='section-handler'>" + @template + "</div>"
        @target.append(@template)
        @bindEvent()
        @close()
    
    bindEvent: ->
      $(@target).find('div.js-handler').on('click', (e) =>
        e.preventDefault()
        if @state is 'close' then @open() else @close()
        @onUpdate()
      )

    open: ->
      $(@target).children(":first").height(@baseHeight)
      $(@target).addClass('is-open').removeClass('is-close')
      @setHandlerText(@args.text[1])
      @state = 'open'

    close: ->
      $(@target).children(":first").css({'overflow': 'hidden', 'margin-bottom': '10px'}).height(@args.maxHeight-(@args.maxHeight%18)-2)
      $(@target).addClass('is-close').removeClass('is-open')
      @setHandlerText(@args.text[0])
      @state = 'close'

    setHandlerText: (_text) ->
      $(@target).find('div.js-handler').text(_text)

    onUpdate: ->
      @args.delegate.onUpdate(@,@state) if @args.delegate && @args.delegate.onUpdate


