define ["jquery", "lib/forms/field_input"], ($, FieldInput) ->

  class FormField

    inputsSelector = "input, textarea, select"

    constructor: (field) ->
      @field = $(field)
      @_initialize() if @field.length is 1

    isValid: ->
      valid = true

      for input in @inputs
        valid = false unless input.isValid()

      valid

    _initialize: ->
      @inputs = []
      @label = @field.find('.js-field-label').text()

      @field.find(inputsSelector).each (index, elt) =>
        @inputs.push(new FieldInput(elt, @label))
