define ['jquery'], ($) ->

  class SelectGroup

    constructor: (@parent = null, @callback = false) ->
      @selectParent = (if @parent != null then $(@parent) else $('.js-select-group'))
      @selectParent.find('.js-select').each (eltIndex) =>
        @setOverlay(@selectParent[eltIndex])
      @addHandlers()

    addHandlers: ->
      @selectParent.on 'focus', '.js-select', (e) =>
        @getOverlay(e.target).addClass 'dropdown__value--selected'

      @selectParent.on 'blur', '.js-select', (e) =>
        @getOverlay(e.target).removeClass 'dropdown__value--selected'

      @selectParent.on 'keyup', '.js-select', (e) =>
        $(e.target).trigger('change')

      @selectParent.on 'change', '.js-select', (e) =>
        target = e.target

        e.preventDefault()
        @setOverlay(target)
        if @callback then @callback(target)
        if $(target).data('redirect') then redirect(target)

    getOverlay: (target) ->
      $(target).closest(@parent).find('.js-select-overlay')

    setOverlay: (target) ->
      t = $(target).find("option:selected")
      @getOverlay(target).text(t.text())

    redirect: (target) ->
      window.location = $(target).options[$(target).selectedIndex].value
