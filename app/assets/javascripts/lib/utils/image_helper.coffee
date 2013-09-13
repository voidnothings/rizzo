# ImageHelper (lp.ImageHelper)
# Some utility functions for images
#

define ['jquery'], ($) ->
  
  class ImageHelper

    # There are cases where we'd want to detect orientation, work out the relative dimensions,
    # and center the images at once (such as a responsive image slider for example). This makes
    # it possible without having to call each function separately with the same config.
    processImages: (config) ->
      @applyOrientationClasses(config)
      @detectRelativeDimensions(config)
      @centerWithinContainer(config)

    # Determined based on being <= 800x600 (4:3) either vertically or horizontally
    # 800x600 being the lowest aspect ratio before not being landscape (or conversely: portrait)
    detectOrientation: ($img) ->
      img = @_imageMetrics($img)[0]

      if (img.ratio >= 1.33) # 800 / 600
        return 'landscape'
      else if (img.ratio <= 0.75) # 600 / 800
        return 'portrait'
      else
        # Not the best term, but most accurately describes neither portrait nor landscape.
        return 'squarish'

    applyOrientationClasses: (config) ->
      $(config.img).each (i, val) =>
        img = $(val)
        img.addClass("is-#{@detectOrientation(img)}")

    detectRelativeDimensions: (config) ->
      @_prepareImages config, (img, container) ->
        if img.ratio < container.ratio
          img.el.addClass('is-taller')
        else if img.ratio > container.ratio
          img.el.addClass('is-wider')

    # This works it out as a percentage so as to keep it centered responsively without
    # needing to hook into any funky resize events. This assumes that the image will
    # be either 100% width or 100% height (thus overflowing either horizontally or vertically)
    centerWithinContainer: (config) ->
      @_prepareImages config, (img, container) ->
        if img.el.height() > container.el.height()
          pxOffset = (container.el.height() - img.el.height()) / 2
          
          # NOTE: need to divide by container **width**. % margins are calculated based on width.
          img.el.css('marginTop', (pxOffset / container.el.width() * 100)+"%")
        if img.el.width() > container.el.width()
          pxOffset = (container.el.width() - img.el.width()) / 2

          img.el.css('marginLeft', (pxOffset / container.el.width() * 100)+"%")

    
    #====== Private(ish) ======#
    _prepareImages: (config, callback) ->
      $(config.img).each (i, val) =>
        img = $(val)
        container = img.closest(config.container)
        
        callback.apply @, @_imageMetrics(img, container)

    _imageMetrics: (img, container) ->
      metrics = [{ el: img, ratio: img.width() / img.height() }]

      if container
        metrics.push({ el: container, ratio: container.width() / container.height() })

      return metrics
