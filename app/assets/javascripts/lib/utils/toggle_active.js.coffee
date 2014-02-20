define ["jquery"], ($) ->

  class ToggleActive

    LISTENER = '.js-wrapper'

    constructor: ->
      @listen()
      @_addInitialState()

    listen: ->
      $('.js-toggle-active').on 'click', (event) =>
        $el = $(event.target)
        @_updateClasses($el)

        # Prevent the click event bubbling so we can update this component
        # by click elsewhere on the document
        # 
        # Replace it with the toggleActive/click event
        event.stopPropagation()
        @broadcast($el)

        if event.target.nodeName.toUpperCase() is 'A'
          event.preventDefault()

      $(LISTENER).on ':toggleActive/update', (e, target) =>
        @_updateClasses($(target))

    broadcast: ($el) ->
      $el.trigger(':toggleActive/click', {isActive: $el.hasClass('is-active')})


    # Private

    _addInitialState: ->
      $('.js-toggle-active').each ->
        $el = $(@)
        $($el.data('toggleTarget')).addClass('is-not-active')
        $el.addClass('is-not-active') if $el.data('toggleMe')

    _updateClasses: ($el) ->
      classList = 'is-active is-not-active '
      classList += $el.data('toggleClass') if $el.data('toggleClass')

      $el.toggleClass(classList) if $el.data('toggleMe')
      $($el.data('toggleTarget')).toggleClass(classList)
