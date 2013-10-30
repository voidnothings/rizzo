define ['jquery'], ($) ->

  required: (field) ->
    val = field.val()
    (if (val isnt undefined and val isnt "" and val.length > 0) then true else false)

  email: (field) ->
    val = field.val()
    rule = /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,6}$/i
    rule.test val

  number: (field) ->
    val = field.val()
    rule = /^[0-9]+$/
    rule.test val

  min: (field, length) ->
    val = field.val()
    (if (val isnt undefined and val.length >= length) then true else false)

  exact: (field, length) ->
    val = field.val()
    (if (val.length is length) then true else false)

  match: (field, ref) ->
    val = field.val()
    matchVal = $(ref).val()
    (if (val is matchVal) then true else false)

  checked: (field) ->
    field.is(':checked')

  text: (field) ->
    val = field.val()
    rule = /^[a-zA-Z\s]+$/i
    rule.test val
