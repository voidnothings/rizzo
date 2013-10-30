require ['lib/forms/form_validator'], (FormValidator) ->

  describe 'LP Form Validation', ->

    describe 'Form Validator object', ->
      it 'is defined', ->
        expect(FormValidator).toBeDefined()

    describe 'attaching to a form that exists', ->

      beforeEach ->
        loadFixtures 'form_validation.html'

      it 'initialises the object', ->
        spyOn(FormValidator.prototype, '_initialize')
        form = new FormValidator('test-form')

        expect(FormValidator.prototype._initialize).toHaveBeenCalled()

    describe 'attaching to a form that does not exist', ->

      beforeEach ->
        loadFixtures 'form_validation.html'

      it 'does not initialise the object', ->
        spyOn(FormValidator.prototype, '_initialize')
        form = new FormValidator('untest-form')

        expect(FormValidator.prototype._initialize).not.toHaveBeenCalled()

    describe 'creating form field objects from the form', ->

      beforeEach ->
        loadFixtures 'form_validation.html'

      it 'has a field object for each field in the form', ->
        form = new FormValidator('test-form')

        expect(form.fields.length).toBe 2

    describe 'validating a form', ->

      beforeEach ->
        loadFixtures 'form_validation.html'

      it 'is not valid if the fields are invalid', ->
        form = new FormValidator('test-form')

        expect(form.isValid()).toBe false

      it 'is valid if the fields are valid', ->
        form = new FormValidator('test-form')

        $('#required').val('some text')
        $('#number').val(54321)

        expect(form.isValid()).toBe true
