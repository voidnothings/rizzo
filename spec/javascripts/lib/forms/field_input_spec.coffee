require ['lib/forms/field_input'], (FieldInput) ->

  describe 'LP Field Input', ->

    inputNone = $('<input type="text" data-label="None" />')
    inputRequired = $('<input type="text" data-rules="required" data-label="Required" />')
    inputRequiredAndNumber = $('<input type="text" data-rules="required number" data-label="Required and Number" />')

    fieldInputNone = null
    fieldInputRequired = null
    fieldInputRequiredAndNumber = null

    describe 'Field Input object', ->

      it 'is defined', ->
        expect(FieldInput).toBeDefined()

    describe 'initialising a Field Input object', ->

      it 'initialises when the element exists', ->
        spyOn(FieldInput.prototype, '_initialize')

        fieldInput = new FieldInput(inputRequired)

        expect(FieldInput.prototype._initialize).toHaveBeenCalled()

      it 'does not when the element does not exist', ->
        spyOn(FieldInput.prototype, '_initialize')

        fieldInput = new FieldInput()

        expect(FieldInput.prototype._initialize).not.toHaveBeenCalled()

    describe 'creating input validator objects from the input rules', ->

      it 'has an input validator object for each rule in the input', ->
        fieldInputNone = new FieldInput(inputNone)
        fieldInputRequired = new FieldInput(inputRequired)
        fieldInputRequiredAndNumber = new FieldInput(inputRequiredAndNumber)

        expect(fieldInputNone.validators.length).toBe 0
        expect(fieldInputRequired.validators.length).toBe 1
        expect(fieldInputRequiredAndNumber.validators.length).toBe 2

    describe 'validating an input', ->

      beforeEach ->
        fieldInputNone = new FieldInput(inputNone)
        fieldInputRequired = new FieldInput(inputRequired)
        fieldInputRequiredAndNumber = new FieldInput(inputRequiredAndNumber)

      it 'is not valid if all validators are invalid', ->
        expect(fieldInputNone.isValid()).toBe true
        expect(fieldInputRequired.isValid()).toBe false
        expect(fieldInputRequiredAndNumber.isValid()).toBe false

      it 'is not valid if some validators are invalid', ->
        inputRequiredAndNumber.val('abcd')

        expect(fieldInputRequiredAndNumber.isValid()).toBe false

      it 'is valid if all the inputs are valid', ->
        inputRequired.val('abc')
        inputRequiredAndNumber.val('123')

        expect(fieldInputNone.isValid()).toBe true
        expect(fieldInputRequired.isValid()).toBe true
        expect(fieldInputRequiredAndNumber.isValid()).toBe true
