# Protect legacy apps that already define jquery downloading it again
if !!window.jQuery then define('jquery', [], -> window.jQuery )

require ['jquery/jquery-1.7.2.min', 'lib/core/base'], ($, Base) ->
  $ ->
    base = new Base()

