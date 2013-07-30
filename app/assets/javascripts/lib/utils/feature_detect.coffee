# ------------------------------------------------------------------------------
# 
# Bucket Class for all our feature detection
# 
# To add a new feature, extend the features object.
# The key will become the class added to the <html>.
# The corresponding function should return true or false.
# 
# ------------------------------------------------------------------------------

(->
  features =
    '3d': ->
      el = document.createElement("p")
      has3d = undefined
      transforms =
        webkitTransform: "-webkit-transform"
        OTransform: "-o-transform"
        msTransform: "-ms-transform"
        MozTransform: "-moz-transform"
        transform: "transform"
      
      # Add it to the body to get the computed style.
      document.body.insertBefore el, null
      for t of transforms
        if el.style[t] isnt `undefined`
          el.style[t] = "translate3d(1px,1px,1px)"
          has3d = window.getComputedStyle(el).getPropertyValue(transforms[t])
      document.body.removeChild el
      has3d isnt `undefined` and has3d.length > 0 and has3d isnt "none"

  for feature of features
    if features[feature]()
      document.getElementsByTagName('html')[0].className += ' supports-'+feature
      window.lp = window.lp || {}
      window.lp.supports = window.lp.supports || {}
      lp.supports[feature] = true

  return
)()