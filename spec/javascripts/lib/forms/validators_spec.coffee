require ['lib/forms/validators'], (Validators) ->

  inputText = null

  describe 'Form Validators', ->

    describe 'required validator', ->

      beforeEach ->
        inputText = $('<input type="text" />')

      it 'passes if not empty', ->
        inputText.val('abc')

        expect(Validators.required(inputText)).toBe true

      it 'fails if empty', ->
        expect(Validators.required(inputText)).toBe false

    describe 'email validator', ->

      beforeEach ->
        inputText = $('<input type="text" />')

      it 'passes if valid email address', ->
        inputText.val('test@testing.com')

        expect(Validators.email(inputText)).toBe true

      it 'fails if invalid email address', ->
        inputText.val('testing.com')

        expect(Validators.email(inputText)).toBe false

      it 'fails if empty', ->
        expect(Validators.email(inputText)).toBe false

    describe 'number validator', ->

      beforeEach ->
        inputText = $('<input type="text" />')

      it 'passes if number entered', ->
        inputText.val('123')

        expect(Validators.number(inputText)).toBe true

      it 'fails if not a number entered', ->
        inputText.val('abcd')

        expect(Validators.number(inputText)).toBe false

    describe 'minimum validator', ->

      beforeEach ->
        inputText = $('<input type="text" />')

      it 'passes if minimum length entered', ->
        inputText.val('123')

        expect(Validators.min(inputText, 3)).toBe true

      it 'fails if less than minimum length entered', ->
        inputText.val('ab')

        expect(Validators.min(inputText, 3)).toBe false

    describe 'exact validator', ->

      beforeEach ->
        inputText = $('<input type="text" />')

      it 'passes if exact length entered', ->
        inputText.val('123')

        expect(Validators.exact(inputText, 3)).toBe true

      it 'fails if less than exact length entered', ->
        inputText.val('ab')

        expect(Validators.exact(inputText, 3)).toBe false

      it 'fails if more than exact length entered', ->
        inputText.val('abcd')

        expect(Validators.exact(inputText, 3)).toBe false

    describe 'match validator', ->

      reference = null

      beforeEach ->
        inputText = $('<input type="text" />')
        reference = $('<input type="text" value="abcd" />')

      it 'passes if entered value matches referenced value', ->
        inputText.val('abcd')

        expect(Validators.match(inputText, reference)).toBe true

      it 'fails if entered value does not match referenced value', ->
        inputText.val('ab')

        expect(Validators.match(inputText, reference)).toBe false

    describe 'checked validator', ->

      it 'passes if input is checked', ->
        inputText = $('<input type="checkbox" checked="checked" />')

        expect(Validators.checked(inputText)).toBe true

      it 'fails if input is not checked', ->
        inputText = $('<input type="checkbox" />')

        expect(Validators.checked(inputText)).toBe false

    describe 'number validator', ->

      beforeEach ->
        inputText = $('<input type="text" />')

      it 'passes if text only entered', ->
        inputText.val('abcd')

        expect(Validators.text(inputText)).toBe true

      it 'fails if not text entered', ->
        inputText.val('abcd123')

        expect(Validators.text(inputText)).toBe false
