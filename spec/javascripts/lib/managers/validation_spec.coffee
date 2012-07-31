$(document).ready ->

  describe 'Lp Form Validation', ->

    describe 'Validation object', ->
      it 'is defined', ->
        expect(Validate).toBeDefined()
      

    describe 'Validation Rules', ->
      it 'our rules are defined', ->
        expect(ValidationRules).toBeDefined()
      
      it 'accepts a required field with length greater than 0', ->
        success = ValidationRules.required('test')
        expect(success).toBe(true)
      it 'rejects a required field of length 0', ->
        success = ValidationRules.required('')
        expect(success).toBe(false)

      it 'accepts ian@lonelyplanet.com', ->
        success = ValidationRules.email('ian@lonelyplanet.com')
        expect(success).toBe(true)
      it 'rejects ianlonelyplanet.com', ->
        success = ValidationRules.email('ianlonelyplanet.com')
        expect(success).toBe(false)
      it 'rejects ian@lonelyplanet', ->
        success = ValidationRules.email('ian@lonelyplanet')
        expect(success).toBe(false)

      it 'accepts 12345678 for an 8 letter field', ->
        success = ValidationRules.exactLength('12345678', 8)
        expect(success).toBe(true)
      it 'rejects 1234567 for an 8 letter field', ->
        success = ValidationRules.exactLength('1234567', 8)
        expect(success).toBe(false)
      it 'accepts 123456789 for an 8 letter field', ->
        success = ValidationRules.exactLength('123456789', 8)
        expect(success).toBe(false)
      it 'but accepts 123456789 for a minlength 8 letter field', ->
        success = ValidationRules.minLength('123456789', 8)
        expect(success).toBe(true)
      
      it 'accepts "test" for a text only field', ->
        success = ValidationRules.textOnly('test')
        expect(success).toBe(true)
      it 'rejects "tes4t" for a text only field', ->
        success = ValidationRules.textOnly('tes4t')
        expect(success).toBe(false)

      it 'accepts 123456789 for a numbers only field', ->
        success = ValidationRules.number('123456789')
        expect(success).toBe(true)
      it 'rejects 12345f6789 for a numbers only field', ->
        success = ValidationRules.number('12345f6789')
        expect(success).toBe(false)
  

    describe 'Realtime error handling', ->

      x = readFixtures('validation.html')
      $('body').append(x)
      myValidate = new Validate('testForm', ValidationRules)
      form = $('#testForm')
      elem1 = $('#firstName')
      elem2 = $('#email')
      
      beforeEach ->
        elem1.val('').removeClass('err success')
        elem2.val('').removeClass('err success')

      it 'is defined', ->
        expect(myValidate).toBeDefined()

      it 'can add an error', ->
        elem1.focus().blur()
        expect(elem1).toHaveClass('err')

      it 'can add a success class', ->
        elem1.val('test').blur()
        expect(elem1).toHaveClass('success')

    describe 'On Submit error handling', ->
      form = $('#testForm')
      elem1 = $('#firstName')
      elem2 = $('#email')
      
      beforeEach ->
        elem1.val('').removeClass('err success')
        elem2.val('').removeClass('err success')
        elem1.blur()
        elem2.blur()
        form.submit()

      afterEach ->
        elem1.val('test').blur()
        elem2.val('test@test.com').blur()

      it 'will show a list of errors on submit', ->
        expect($('.err-container')).toExist()

      it 'will remove an error from the list on correction', ->
        elem1.val('test').blur()
        count = form.find('li').length
        expect(count).toEqual(1)
        
      it 'will add an error back into the list', ->
        elem1.val('test').blur()
        elem1.val('').blur()
        form.submit()
        count = form.find('li').length
        expect(count).toEqual(2)

      it 'will remove the error list container when the number of errors is 0', ->
        elem1.val('test').blur()
        elem2.val('test@test.com').blur()
        count = (if $('.err-container').length == 0 then true else false)
        expect(count).toBe(true)









