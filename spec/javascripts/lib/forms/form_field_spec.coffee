require ['lib/forms/form_field'], (FormField) ->

  describe 'LP Form Field', ->

    describe 'Form Field object', ->

      it 'is defined', ->
        expect(FormField).toBeDefined()

    describe 'initialising a Form Field object', ->

      beforeEach ->
        loadFixtures 'form_validation.html'

      it 'initialises when the element exists', ->
        spyOn(FormField.prototype, '_initialize')

        fields = $('.js-field')
        formField = new FormField(fields[0])

        expect(FormField.prototype._initialize).toHaveBeenCalled()

      it 'does not when the element does not exist', ->
        spyOn(FormField.prototype, '_initialize')

        formField = new FormField()

        expect(FormField.prototype._initialize).not.toHaveBeenCalled()

    describe 'creating field input objects from the field', ->

      beforeEach ->
        loadFixtures 'form_validation.html'

      it 'has a field input object for each input in the field', ->
        fields = $('.js-field')

        formField_input = new FormField(fields[0])
        formField_multiSelect = new FormField(fields[2])

        expect(formField_input.inputs.length).toBe 1
        expect(formField_multiSelect.inputs.length).toBe 2

    describe 'validating a field', ->

      fields = null

      beforeEach ->
        loadFixtures 'form_validation.html'
        fields = $('.js-field')

      it 'is not valid if all inputs are invalid', ->
        formField_input = new FormField(fields[0])
        formField_multiSelect = new FormField(fields[2])

        expect(formField_input.isValid()).toBe false
        expect(formField_multiSelect.isValid()).toBe false

      it 'is not valid if some inputs are invalid', ->
        formField_multiSelect = new FormField(fields[2])

        $('#first-select').val(1);

        expect(formField_multiSelect.isValid()).toBe false

      it 'is valid if the fields are valid', ->
        formField_input = new FormField(fields[0])
        formField_multiSelect = new FormField(fields[2])

        $('#required').val('some text')
        $('#first-select').val(1);
        $('#second-select').val(1);

        expect(formField_input.isValid()).toBe true
        expect(formField_multiSelect.isValid()).toBe true
