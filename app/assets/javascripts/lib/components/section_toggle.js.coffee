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
#     style       : [string] 'inline' or 'block', the style of click handler to display
#
# Example:
#  args =
#    selector: 'div.partner-review-facilities'
#    text: ['more facilities', 'less facilities']
#    maxHeight: maxheight
#    delegate:
#      onupdate: (section, state) =>
#        console.log(state)
#  new lp.SectionToggle(args)
# 
# Dependencies:
#   jQuery
 
define ['jquery'], ($) ->
 
  class SectionToggle
  
    # TODO: turn on transition events again when they're actually reliable!!

    @version: '0.0.3'
    
    constructor: (@args={}) ->
      # @transitionEnabled = if 'transition' of document.body.style then true else false
      @target = $(@args.selector)
      @target.addClass('is-open')
      @wrapper = $(@target).find('.js-read-more-wrapper')
      @wrapper.addClass if @args.style is 'inline' then 'read-more-inline' else 'read-more-block'
      @totalHeight = @getFullHeight()
      @addHandler() if @totalHeight > @args.maxHeight
      @setHeight @args.maxHeight, @args.text[0], 'close'

    getFullHeight: ->
      height = 0
      nodes = @wrapper.children()
      i = 0

      while( i < nodes.length ) 
        height += $(nodes[i]).outerHeight(true)
        i++

      height

    addHandler: ->
      @handler = $("<div class='btn--read-more js-handler'>#{(@args.text)[0]}</div>")
      @wrapper.append(@handler)
      @handler.wrap("<div class='read-more__handler'/>") if @args.shadow
      @bindEvents()
    
    bindEvents: ->
      # @wrapper.on('transitionend', => 
      #   console.log 'transitionend'
      #   @toggleClasses()
      # )

      @handler.on 'click', (e) =>
        e.stopPropagation()
        if @state is 'close'
          @setHeight(@totalHeight, @args.text[1], 'open')
        else
          @setHeight(@args.maxHeight, @args.text[0], 'close')
        @onUpdate()

    setHeight: (height, text, state) ->
      if state is 'open'
        # Wait for the transition to finish before taking away the gradient mask
        setTimeout(=>
          @toggleClasses()
        , 500)
      else
        @toggleClasses()

      @wrapper.css({'max-height': height + 'px'})
      @setHandlerText(text)
      @state = state

    setHandlerText: (_text) ->
      @handler.text _text

    onUpdate: ->
      @args.delegate.onUpdate(@,@state, @args.selector) if @args.delegate && @args.delegate.onUpdate

    toggleClasses: ->
      @target.toggleClass('is-open is-closed')
