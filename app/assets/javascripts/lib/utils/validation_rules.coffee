define ->

  class ValidationRules  

    @required : (val) ->
      if val.length > 0 then true else false

    @email : (val) ->
      rule = /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,6}$/i
      rule.test(val)

    @minLength : (val, length) ->
      if val.length >= length then true else false

    @exactLength : (val, length) ->
      if val.length == length then true else false

    @number : (val) ->
      rule = /^[0-9]+$/
      rule.test(val)

    @textOnly : (val) ->
      rule = /^[a-z]+$/i
      rule.test(val)
