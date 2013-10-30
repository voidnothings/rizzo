define ["jquery", "lib/forms/field_input"], ($, FieldInput) ->

  class FormField

    constructor: (field) ->
      @field = $(field)
      @label = @field.find('.js-field-label').text()
      @inputs = []
      @inputsSelector = "input, textarea, select"
      @_initialize()

    isValid: ->
      valid = true

      for input in @inputs
        valid = false unless input.isValid()

      valid

    _initialize: ->
      @field.find(@inputsSelector).each (index, elt) =>
        @inputs.push(new FieldInput(elt, @label))
