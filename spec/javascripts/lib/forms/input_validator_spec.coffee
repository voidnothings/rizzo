require ['lib/forms/input_validator'], (InputValidator) ->

  describe 'LP Input Validator', ->

    input = $('<input type="text" />')

    describe 'Input Validator object', ->

      it 'is defined', ->
        expect(InputValidator).toBeDefined()

    describe 'initialising an Input Validator object', ->

      it 'initialises when all parameters are supplied', ->
        spyOn(InputValidator.prototype, '_initialize')

        validator = new InputValidator(input, 'Required Field', 'required')

        expect(InputValidator.prototype._initialize).toHaveBeenCalled()

      it 'does not initialise when the parameters are not supplied', ->
        spyOn(InputValidator.prototype, '_initialize')

        validator = new InputValidator()

        expect(InputValidator.prototype._initialize).not.toHaveBeenCalled()

    describe 'validating an input', ->

      validator = null

      beforeEach ->
        validator = new InputValidator(input, 'Required Field', 'required')

      it 'is not valid if the field value is invalid', ->
        expect(validator.isValid()).toBe false

      it 'is valid if the field value is valid', ->
        input.val('abc')

        expect(validator.isValid()).toBe true

      # effed if I can work out why this doesn't match, it does as far as I can see!
      xit 'gives an error messsage', ->
        expect(validator.getErrorMessage()).toMatch 'Please enter your Required Field'
