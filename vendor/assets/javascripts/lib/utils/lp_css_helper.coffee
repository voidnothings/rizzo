# CssHelper (lp.CssHelper)
# Help extracting information from css
#
# Example:
#   CssHelper.stripPx("10px")
#   CssHelper.extractUrl("url(http://lp.com/sprite.png)")
#


define ['jquery'], ($) ->
  
  class CssHelper

    @propertiesFor: (css_class, propertyNames)->
      el = $('<span>').addClass(css_class)
      el.hide().appendTo('body')
      cssInfo = {}
      cssInfo[property] = el.css(property) for property in propertyNames
      el.remove()
      cssInfo

    @stripPx: (cssSizeWithPx)->
      cssSizeWithPx[0..cssSizeWithPx.indexOf('p')-1]

    @extractUrl: (cssUrl)->
      si = cssUrl.indexOf('(')+1
      ei = cssUrl.lastIndexOf(')')-1
      cssUrl[si..ei].replace(/\"/g, '')



