_dep = [
  'jquery'
]

define _dep, ($) ->

  class NightlyRatesManager

    @init: ->
      $('.lp-slider').each ->
        slider = $(this)
        container = slider.find('.lp-slider-container')
        list = slider.find('.lp-slider-list')
        left = slider.find('.lp-slider-controls-left')
        right = slider.find('.lp-slider-controls-right')

        offset = slider.data('offset')
        limit = slider.data('limit')
        count = slider.data('count')
        
        width = list.find('.lp-slider-item').outerWidth(true)

        move = (displacement) ->
          offset = offset + displacement
        
          if offset <= 0
            offset = 0
            left.addClass('disabled')
          else
            left.removeClass('disabled')

          if offset >= count - limit
            offset = count - limit
            right.addClass('disabled')
          else
            right.removeClass('disabled')

          list.animate(left: offset * -width + "px")

        left.click (event) ->
          event.preventDefault()
          event.stopPropagation()
          move -limit

        right.click (event) ->
          event.preventDefault()
          event.stopPropagation()
          move +limit

