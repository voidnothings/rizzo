define ["jquery"], ($) ->

  class ToggleActive

    LISTENER = "#js-row--content"
    lastUpdate = false

    # @args = {}
    # context: {string} selector so that we can add a context/scope. Useful for loading content in dynamically (where ToggleActive wouldn"t be initialised) and not affecting existing ToggleActive instances.
    constructor: (args) ->
      this.context = args.context if args
      @listen()
      @_addInitialState()


    listen: ->
      if (this.context)
        $(this.context).on "click", ".js-toggle-active", this._handleToggle
      else
        $(".js-toggle-active").on "click", this._handleToggle

      $(LISTENER).on ":toggleActive/update", (e, target) =>
        @_updateClasses($(target))

    broadcast: ($el) ->
      $el.trigger(":toggleActive/click", { isActive: $($el.data("toggleTarget")).hasClass("is-active"), targets: @_getTargetEls($el) })


    # Private

    _handleToggle: (event) =>
      $el = $(event.target)
      @_updateClasses($el)

      # Prevent the click event bubbling so we can update this component
      # by click elsewhere on the document
      #
      # Replace it with the toggleActive/click event
      event.stopPropagation()
      @broadcast($el)

      if event.target.nodeName.toUpperCase() is "A"
        event.preventDefault()

    _addInitialState: ->
      toggles = if this.context then $(".js-toggle-active", this.context) else $(".js-toggle-active")

      toggles.each ->
        $el = $(@)
        $($el.data("toggleTarget")).addClass("is-not-active")
        $el.addClass("is-not-active") if $el.data("toggleMe")

    # Add a 250ms debounce
    _debounce: ->
      now = new Date().getTime()
      !lastUpdate || now - lastUpdate > 250

    _updateClasses: ($el) ->
      if (this._debounce())
        classList = "is-active is-not-active "
        classList += $el.data("toggleClass") if $el.data("toggleClass")

        $el.toggleClass(classList) if $el.data("toggleMe")
        @_getTargetEls($el).toggleClass(classList)

        lastUpdate = new Date().getTime()

    _getTargetEls: ($el) ->
      $($el.data("toggleTarget"))
