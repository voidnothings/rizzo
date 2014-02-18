define ["jquery", "lib/forms/form_input"], ($, FormInput) ->

  class FormValidator

    inputsSelector = "input, textarea, select"

    constructor: (target) ->
      @form = $(target)
      @_initialize() if @form.length is 1

    _initialize: ->
      @inputs = []
      @form.find(inputsSelector).not('[type="hidden"], [type="submit"], [type="reset"]').each (index, elem) =>
        label = $(elem).closest('.js-field').find('.js-field-label').text()
        @inputs.push(new FormInput(elem, label))
      @_listen()

    _listen: ->
      $submit = @form.find('[type="submit"]')
      @form.on "submit", (e) =>

        if @isValid()
          $submit.removeProp('disabled')
        else
          $submit.prop('disabled', 'disabled')
          e.preventDefault()

      for input in @inputs
        input.input.on "blur", input , (e) =>
          e.data.isValid(true)

          if @isValid(false, e.data)
            $submit.removeProp('disabled')
          else
            $submit.prop('disabled', 'disabled')

      $submit.prop('disabled', 'disabled') unless @isValid(false)

    isValid: (triggerErrors, byPassEl) ->
      valid = true
      triggerErrors = (triggerErrors == undefined) || triggerErrors

      for input in @inputs
        valid = false unless input is byPassEl or input.isValid(triggerErrors)

      valid
