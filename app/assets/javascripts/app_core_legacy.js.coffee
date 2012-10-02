require.config(
  paths:
    jplugs: "jquery/plugins"
)

require ['jquery', 'lib/core/base'], ($, Base) ->
  $ ->
    base = new Base()



