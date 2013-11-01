define ['jquery'], ($) ->

  class SelectGroupManager

    constructor: () ->
      @selectContainers = $('.js-select-group-manager')
      @addHandlers()

    addHandlers: ->
      @selectContainers.on 'focus', '.js-select', (e) =>
        @getOverlay(e.target).addClass 'dropdown__value--selected'

      @selectContainers.on 'blur', '.js-select', (e) =>
        @getOverlay(e.target).removeClass 'dropdown__value--selected'

      @selectContainers.on 'keyup', '.js-select', (e) =>
        $(e.target).trigger('change')

      @selectContainers.on 'change', '.js-select', (e) =>
        target = e.target

        e.preventDefault()
        @setOverlay(target)
        if @callback then @callback(target)
        if $(target).data('form_submit') then submit(target)

    getOverlay: (target) ->
      $(target).closest('.js-select-group-manager').find('.js-select-overlay')

    setOverlay: (target) ->
      t = $(target).find("option:selected")
      @getOverlay(target).text(t.text())

    submit: (target) ->
      $(target).closest('form').submit()
