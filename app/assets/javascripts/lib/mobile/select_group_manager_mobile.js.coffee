define ['jsmin'], ($) ->

  class SelectGroup

    constructor: (@parent = null, @callback = false) ->
      @selectParent = (if @parent != null then $(@parent) else $('.js-select-group'))
      @addHandlers()

    addHandlers: ->
      @selectParent.on 'change', (e) =>
        e.preventDefault()
        result = e.target.find("option:selected").innerHTML
        label = e.target.parentNode.find('.js-select-overlay').innerHTML = result
        if @callback then @callback(e.target)