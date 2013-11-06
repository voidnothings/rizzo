define ["jquery", "lib/forms/form_field"], ($, FormField) ->

  class FormValidator

    constructor: (target) ->
      @form = $(target)
      @_initialize() if @form.length is 1

    _initialize: ->
      @fields = []
      $(".js-field").each (index, elt) =>
        @fields.push(new FormField(elt))
      @_listen()

    _listen: ->
      @form.on "submit", (e) =>
        unless @isValid() then e.preventDefault()

    isValid: ->
      valid = true

      for field in @fields
        valid = false unless field.isValid()

      valid
