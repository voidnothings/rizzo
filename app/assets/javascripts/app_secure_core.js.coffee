require ['jquery', 'lib/core/base', 'flamsteed'], ($, Base, _FS) ->
  $ ->
    config = 
      secure: true
    base = new Base(config)
    window.lp = window.lp || {}
    window.lp.fs = new _FS({events: window.fs.buffer})
