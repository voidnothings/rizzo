require.config(
  paths:
    jquery: "//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min"
    jplugs: "jquery/plugins"
)

require ['jquery', 'lib/melbourne/melbourne_base'], ($, MelbourneBase) ->
  $ ->
    base = new MelbourneBase()
