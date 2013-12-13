# ------------------------------------------------------------------------------------------
# A replacement for the so called "checkbox hack" (http://css-tricks.com/the-checkbox-hack/)
# which we can't use because of issues in iOS, Android, and old IE.
# 
# An example of how to use it is:
# 
#   <a href="#" class="js-toggle-active" data-target=".foo">toggle it</a>
# 
# ... or to specify the class (which defaults to 'is-active'):
# 
#   <a href="#" class="js-toggle-active" data-toggle-target=".foo" data-toggle-class="custom-class">toggle it</a>
# 
# ------------------------------------------------------------------------------------------

define ["jquery"], ($) ->

  class ToggleActive

    constructor: () ->

      $('.js-toggle-active').on 'click', ->
        $el = $(@)
        $($el.data('toggleTarget')).toggleClass($el.data('toggleClass') || 'is-active')