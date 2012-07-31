# @param formId: the ID of the form to be validated
# @param rules: The validation rules to be applied, defaults to true otherwise


# Usage - Note, data-val and name are both required
# <input type="text" data-val="required" name="first-name" />
# <input type="password" name="password" data-val="minLength" data-val-attr="8" />


define ['jquery'], ($) ->
  
  class Validate
    self = {}
    self.notificationsVisible = false
    self.errorCount = 0
  
  
    errorMessages = {
      required:       'Please enter your '
      email:          'Please enter a valid '
      minLength:      'Please enter at least %X characters for your '
      exactLength:    'Please enter exactly %X characters for your '
      numbersOnly:    'Please enter only numbers for your '
      textOnly:       'Please use only plain text for your' 
      errorHeading:   'Please correct the following errors:'
    }
  
  
    validationHelpers = {
      mapCorrectField : (fieldName) ->
        for field in self.validateFields when field.name == fieldName
          return field

      mapIndexToField : (fieldName) ->
        for field, i in self.validateFields when field.name == fieldName
          return i

      getFirstError : () ->
        for field in self.validateFields when field.validates == false
          return field

      getAllErrors : () ->
        errors = []
        for field in self.validateFields when field.validates == false
          errors.push field
        errors
    }

  
    restrictFormSubmit = ->
      restrict = (if (validationHelpers.getFirstError() is undefined) then false else true)


    addError = (index, type = 'input') ->
      self.validateFields[index].validates = false
    
      elem = $(self.validateFields[index].element)
      if (type == 'lp-select') then elem = elem.prev()
      if elem.hasClass('err') == false
        elem.removeClass('success').addClass('err')
        self.errorCount++
    

    removeError = (index, inputName, type = 'input') ->
      self.validateFields[index].validates = true
    
      elem = $(self.validateFields[index].element)
      if (type == 'lp-select') then elem = elem.prev()
      if elem.hasClass('err')
        elem.removeClass('err').addClass('success')
        self.errorCount--
        if (self.notificationsVisible == true)
          removeErrorNotification(inputName)
      else
      elem.addClass('success')


    removeErrorNotification = (inputName) ->
      self.errBox.find('.' + inputName).remove()
      if (self.errorCount == 0)
        self.errBox.remove()
        self.notificationsVisible = false


    highlightRemainingErrors = ->
      errors = validationHelpers.getAllErrors()
      for error, i in errors
        if error.elemType is 'SELECT'
          addError(validationHelpers.mapIndexToField(error.name), 'lp-select')
        else
          addError(validationHelpers.mapIndexToField(error.name))
        self.errorCount = i + 1


    createNotificationsArea = (myForm) ->
      if self.errBox is undefined
        errHeading = $('<h2/>').addClass('err-heading').text(errorMessages.errorHeading)
        self.errBox = $('<div/>').addClass('err-container').append(errHeading)
        self.errList = $('<ul/>').addClass('err-list')
      else
        self.errList.remove().html('')

      for error in validationHelpers.getAllErrors()
        msg = errorMessages[error.rules[0]] + error.name.split('-').join(' ')
        if error.elemType is 'SELECT' then msg = msg.replace('enter', 'select')
        item = $('<li/>').addClass(error.name).text(msg)
        self.errList.append(item)

      if (self.notificationsVisible == true)
        self.errBox.append(self.errList)
      else
        myForm.prepend(self.errBox.append(self.errList))

      self.notificationsVisible = true


    performTest = (val, fieldObj) ->
      if (self.rules isnt null)
        for rule in fieldObj.rules
          if (self.rules[rule](val, fieldObj.length))
            validates = true
          else 
            validates = false
            break;
        validates
      else
        true


    addFormListeners = (myForm) ->
      for field, i in self.validateFields
      
        if field.elemType == "INPUT"
          field.element.on 'blur', (e) =>
            if performTest(e.target.value, validationHelpers.mapCorrectField(e.target.name)) 
              removeError(validationHelpers.mapIndexToField(e.target.name), e.target.name)
            else
              addError(validationHelpers.mapIndexToField(e.target.name))
      
        else if field.elemType == "SELECT"
          field.element.on 'change', (e) =>
            if performTest(e.target.value, validationHelpers.mapCorrectField(e.target.name)) 
              removeError(validationHelpers.mapIndexToField(e.target.name), e.target.name, 'lp-select')
            else
              addError(validationHelpers.mapIndexToField(e.target.name), 'lp-select')


    testOnSubmit = (myForm) ->
      myForm.on 'submit', (e) =>
        if restrictFormSubmit()
          e.preventDefault()
          highlightRemainingErrors()
          createNotificationsArea(myForm)


    createFieldArray = (myForm) ->
      self.validateFields = []
      for field, i in myForm.find("[data-val]")
        fieldRules = $(field).attr('data-val').split(' ')
        helperLength = $(field).attr('data-val-num')
        validateLength = (if helperLength isnt undefined then parseInt(helperLength, 10) else null)
      
        myField = {
          name:      $(field).attr('name')
          element:   $(field)
          rules:     fieldRules
          length:    validateLength
          elemType:  field.tagName
          validates: false
        }
      
        self.validateFields.push myField

    constructor: (@formId, rules = null) ->
      self.rules = rules
      createFieldArray($("##{@formId}"))
      addFormListeners($("##{@formId}"))
      testOnSubmit($("##{@formId}"))
