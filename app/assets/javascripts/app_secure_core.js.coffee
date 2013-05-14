require ['jquery', 'lib/core/base', 'flamsteed'], ($, Base) ->
  $ ->
    config = 
      secure: true
    base = new Base(config)
