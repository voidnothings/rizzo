require ['jquery', 'lib/core/base'], ($, Base) ->
  $ ->
    $.jsLoaded = -> $('body').addClass('js-loaded')
    base = new Base()


