define ["jquery", "lib/forms/input_validator"], ($, InputValidator) ->

  class FieldInput

    constructor: (input, label) ->
      @input = $(input)
      @label = @input.data('label') || label
      @inputParent = @input.closest('.js-input')
      @validators = []
      @_initialize()
      @_listen()

    isValid: ->
      @_clearError()
      valid = true

      for validator in @validators
        unless validator.isValid()
          @_showError validator.getErrorMessage()
          valid = false
          break

      valid

    _initialize: ->
      validators = if @input.data('rules') then @input.data('rules').split(' ') else []

      for validator in validators
        @validators.push(new InputValidator(@input, @label, validator))

    _listen: ->
      @input.on 'blur', (e) =>
        @isValid()

      if @input.nodeName is 'SELECT'
        @input.on 'change', (e) =>
          @isValid()

    _clearError: ->
      @inputParent.removeClass 'field__input--error'
      @inputParent.find('.js-error').remove()

    _showError: (message) ->
      @inputParent.addClass 'field__input--error'
      @inputParent.append $("<div class='field__error js-error'>#{message}</div>")
