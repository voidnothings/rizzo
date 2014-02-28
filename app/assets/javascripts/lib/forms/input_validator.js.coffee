define ["jquery", "lib/forms/validators", "lib/forms/error_messages"], ($, Validators, ErrorMessages) ->

  class InputValidator

    constructor: (input, label, validator, field_input) ->
      @input = input
      @label = label
      @field_input = field_input
      @validator = validator
      @_initialize() if @input and @label and @validator

    isValid: ->
      Validators[@name](@input, @args)

    getErrorMessage: ->
      "#{@_replace(ErrorMessages[@name], @args)} #{@label}"

    _initialize: ->
      # check for validation rules that have parameters and split them up, e.g. min(3)
      if match = @validator.match(/(.+?)\((.+)\)/)
        @name = match[1]
        @args = match[2]
      else
        @name = @validator

      # Because the validators are all synchronous and expect an immediate true/false
      # response we need to handle this separately.
      if @name is "username_check"
        timer = false

        @input.on "keyup", (e) =>
          clearTimeout(timer) if timer

          timer = setTimeout =>
            @_username_check(@args)
          , 250

    _username_check: (url) ->
      if (@input.val().length > 3)
        $.ajax url + "/" + @input.val(),
          success: (data) =>
            @field_input._clearInput()
            if data.unique
              @field_input._showValid()
            else
              @field_input._showError("That username is taken.")

    _replace: (text, variables) ->
      text.replace /{(\d+)}/g, (match, number) ->
        if typeof variables[number] != 'undefined' then variables[number] else match
