# ImageHelper (lp.ImageHelper)
# Some utility functions for images
#
# Example:
#   ImageHelper.
#

define ['jquery'], ($) ->
  
  class ImageHelper

    # Determined based on being <= 800x600 (4:3) either vertically or horizontally
    detectOrientation: (config) ->
      @_imageMetrics config, (img) ->
        if (img.ratio >= 1.33) # 800 / 600
          img.el.addClass('is-portrait')
        else if (img.ratio <= 0.75) # 600 / 800
          img.el.addClass('is-landscape')

    detectRelativeDimensions: (config) ->
      @_imageMetrics config, (img, container) ->
        if img.ratio > container.ratio
          img.el.addClass('is-taller')
        else if img.ratio < container.ratio
          img.el.addClass('is-wider')

    centerWithinContainer: (config) ->
      @_imageMetrics config, (img, container) ->
        if img.el.height() > container.el.height()
          pxOffset = (container.el.height() - img.el.height()) / 2
          
          # NOTE: need to divide by container **width**. % margins are calculated based on width.
          img.el.css('marginTop', (pxOffset / container.el.width() * 100)+"%")
        if img.el.width() > container.el.width()
          pxOffset = (container.el.width() - img.el.width()) / 2

          img.el.css('marginLeft', (pxOffset / container.el.width() * 100)+"%")

    
    #====== Private(ish) ======#
    _imageMetrics: (config, callback) ->
      $(config.img).each ->
        img = $(@)
        imgRatio = img.height() / img.width()
        container = img.closest(config.container)
        containerRatio = container.height() / container.width()

        callback.apply this, [ { el:img, ratio:imgRatio }, { el:container, ratio:containerRatio }]
