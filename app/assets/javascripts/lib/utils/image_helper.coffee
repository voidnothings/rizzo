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
      img = $(config.img)
      ratio = img.height() / img.width()

      if (ratio >= 1.33) # 800 / 600
        img.addClass('is-portrait')
      else if (ratio <= 0.75) # 600 / 800
        img.addClass('is-landscape')

    detectRelativeDimensions: (config) ->
      container = $(config.container)
      img = $(config.img)

      detectOrientation(config) if img.hasClass('is-landscape').length is 0

      img = img.filter('.is-landscape')

      # We only want this on landscape images since proper portrait images will just be vertically centered.
      return if img.length is 0

      if (img.width() / img.height() < container.width() / container.height())
        img.addClass('is-taller')
      else if (img.height() / img.width() < container.height() / container.width())
        img.addClass('is-wider')

