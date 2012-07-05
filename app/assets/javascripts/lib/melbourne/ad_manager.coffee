define ->
  adManager =
    init : (_config,_target) ->
      _config.service?= 'http://ad.doubleclick.net/adi/2009.lonelyplanet'
      iframe = document.createElement('iframe')
      ord = Math.random()*10000000000000000
      iframe.src = "#{_config.service}/#{_config.adZone};#{_config.adKeywords};#{_config.segQS};tile=#{_config.tile};mtfIFPath=#{_config.mtfIFPath};sz=#{_config.unit[0]}x#{_config.unit[1]};ord=#{_config.ord}?"
      iframe.marginHeight = "0"
      iframe.marginWidth = "0"
      iframe.frameBorder = "0"
      iframe.scrolling = 'no'
      iframe.style.width = "#{_config.unit[0]}px"
      iframe.style.height = "#{_config.unit[1]}px"
      s = document.getElementById(_target)
      s.appendChild(iframe)
