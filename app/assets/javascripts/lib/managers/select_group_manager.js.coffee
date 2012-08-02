define ['jquery'], ($) ->

  class SelectGroup

    constructor: (@parent = null) ->
      @selectParent = (if @parent != null then $(@parent) else $('.js-select-group'))
      @addHandlers()

    addHandlers: ->
      @selectParent.on 'change', '.js-select', (e) ->
        e.preventDefault()
        t = $(this).find("option:selected")
        val = t.text()
        t.closest('.js-select-group').find('.js-select-overlay').text(val)

