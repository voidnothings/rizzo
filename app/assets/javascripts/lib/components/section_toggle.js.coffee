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
  
    @version: '0.0.2'
    
    constructor: (@args={}) ->
      @target = $(@args.selector)
      @target.toggleClass('is-open')
      @wrapper = $(@target).find('.js-read-more-wrapper')
      @wrapper.css({'overflow': 'hidden'})
      @includeHandler = @checkHeight(@args.maxHeight)
      @addHandler() if @includeHandler

    checkHeight: (maxHeight) ->
      nodes = @wrapper.children()
      height = 0
      i = 0

      while ( i < nodes.length )
        height += $(nodes[i]).height()
        if height >= maxHeight
          return true
        i++

      return height >= maxHeight

    addHandler: ->
      @template = "<div class='btn--read-more js-handler'>#{(@args.text)[0]}</div>"
      if @args.shadow
        @template = "<div class='read-more__handler'>" + @template + "</div>"
      @wrapper.append(@template)
      @handler = @target.find 'div.js-handler'
      @bindEvent()
      @close()
    
    bindEvent: ->
      @handler.on 'click', (e) =>
        e.preventDefault()
        if @state is 'close' then @open() else @close()
        @onUpdate()

    open: ->
      @wrapper.css({'max-height': '5000px'})
      # Wait for the transition to finish before taking away the gradient mask
      # TODO: check for transitionend and use that instead if it's available
      setTimeout(=>
        @toggleClasses()
      , 500)
      @setHandlerText(@args.text[1])
      @state = 'open'

    close: ->
      @wrapper.css({'max-height': @args.maxHeight + 'px'})
      @toggleClasses()
      @setHandlerText(@args.text[0])
      @state = 'close'

    setHandlerText: (_text) ->
      @handler.text _text

    onUpdate: ->
      @args.delegate.onUpdate(@,@state, @args.selector) if @args.delegate && @args.delegate.onUpdate

    toggleClasses: ->
      @target.toggleClass('is-open is-closed')
