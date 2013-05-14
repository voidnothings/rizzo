require ['jquery', 'lib/core/base', 'flamsteed'], ($, Base, _FS) ->
  $ ->
    $.jsLoaded = -> $('body').addClass('js-loaded')
    base = new Base()
    window.lp = window.lp || {}
    window.lp.fs = new _FS()
