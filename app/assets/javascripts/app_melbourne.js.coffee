# Protect legacy apps that already define jquery downloading it again
if !!window.jQuery then define('jquery', [], -> window.jQuery )

require ['jquery', 'lib/melbourne/melbourne_base'], ($, MelbourneBase) ->
  $ ->
    base = new MelbourneBase()
