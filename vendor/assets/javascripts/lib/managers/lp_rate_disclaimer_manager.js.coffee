
define ['jquery'], ($) ->

  class RateDisclaimerManager

    @init: ->
      $('.room-disclaimer-toggle').each ->
        toggle = $(@)
        target = $('.room-disclaimer[data-id=' + toggle.data('target') + ']')
        
        toggle.on 'click', (event) ->
          target.slideToggle()
