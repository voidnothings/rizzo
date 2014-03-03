define ["jquery", "lib/forms/input_validator"], ($, InputValidator) ->

  class FieldInput

    constructor: (input, label) ->
      @input = $(input)
      @label = @input.data('label') || label

      # Because the validators are all synchronous and expect an immediate true/false
      # response we need to handle this separately.
      @has_username_check = /username_check/.test(@input.data('rules'))

      @_initialize() if @input.length is 1

    isValid: (triggerErrors) ->
      @_clearValidation() if triggerErrors and !@has_username_check
      valid = true

      for validator in @validators
        unless validator.isValid()
          @_showError validator.getErrorMessage() if triggerErrors
          valid = false
          break

      valid

    _initialize: ->
      @inputParent = @input.closest('.js-input')
      @validators = []
      rules = if @input.data('rules') then @input.data('rules').split(' ') else []

      for validator in rules
        if @has_username_check
          @_usernameListen()
        else
          @validators.push(new InputValidator(@input, @label, validator))

      @_listen()

    _listen: ->
      @input.on 'blur', (e) =>
        @isValid()

      if @input.nodeName is 'SELECT'
        @input.on 'change', (e) =>
          @isValid()

    _usernameListen: ->
      validator = @input.data('rules').match(/(username_check\(.*?\))/)[1]
      inputValidator = new InputValidator(@input, @label, validator)
      timer = false
      validator_rules = inputValidator.get_validation_rules()

      @input.on "keyup", (e) =>
        clearTimeout(timer) if timer

        timer = setTimeout =>
          @_usernameCheck(validator_rules[2])
        , 250

    _clearValidation: (extra_classes) ->
      @inputParent.removeClass "field__input--error icon--cross--after #{extra_classes}"
      @inputParent.find('.js-error').remove()

    _showError: (message) ->
      @inputParent.addClass 'field__input--error icon--cross--after icon--custom--after'
      @inputParent.append $("<div class='field__error js-error'>#{message}</div>")

    _showValid: ->
      @inputParent.addClass 'field__input--valid icon--tick--after icon--custom--after'

    _usernameCheck: (url) ->
      if (@input.val().length > 3)
        $.ajax url + "/" + @input.val(),
          success: (data) =>
            @_indicateUsernameValidity(data)

    _indicateUsernameValidity: (data) ->
      @_clearValidation("field__input--valid icon--tick--after")
      if data.unique
        @_showValid()
      else
        @_showError("That username is taken.")
