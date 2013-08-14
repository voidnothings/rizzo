define ->

  uncommenter: (element) ->
    scriptPlaceholder = element.find('.js-hidden-script')
    unless scriptPlaceholder.length is 0
      commentedScript = scriptPlaceholder.html()
      # Remove the comments and execute the script
      script = commentedScript.replace('<!--', '').replace('-->', '')
      scriptPlaceholder.html(script)

  bgImageLoader: (element) ->
    if element.hasClass('rwd-image-blocker')
      element.removeClass('rwd-image-blocker')
    else
      element.find('.rwd-image-blocker').removeClass('rwd-image-blocker')