define ["jquery", "lib/forms/form_input"], ($, FormInput) ->

  class FormValidator

    inputsSelector = "input, textarea, select"

    constructor: (target) ->
      @form = $(target)
      @_initialize() if @form.length is 1

    _initialize: ->
      @inputs = []
      @form.find(inputsSelector).not('[type="hidden"]').each (index, elem) =>
        label = $(elem).closest('.js-field').find('.js-field-label').text()
        @inputs.push(new FormInput(elem, label))
      @_listen()

    _listen: ->
      @form.on "submit", (e) =>
        unless @isValid() then e.preventDefault()

    isValid: ->
      valid = true

      for input in @inputs
        valid = false unless input.isValid()

      valid
