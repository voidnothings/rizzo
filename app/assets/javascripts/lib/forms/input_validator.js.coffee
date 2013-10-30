define ["jquery", "lib/forms/validators", "lib/forms/error_messages"], ($, Validators, ErrorMessages) ->

  class InputValidator

    constructor: (input, label, validator) ->
      @input = input
      @label = label
      @_initialize(validator)

    isValid: ->
      Validators[@name](@input, @args)

    getErrorMessage: ->
      "#{@_replace(ErrorMessages[@name], @args)} #{@label}" 

    _initialize: (validator) ->
      if match = validator.match(/(.+)\((.+)\)/)
        @name = match[1]
        @args = match[2]
      else
        @name = validator

    _replace: (text, variables) ->
      text.replace /{(\d+)}/g, (match, number) ->
        if typeof variables[number] != 'undefined' then variables[number] else match
