require.config
  paths:
    # Include the GPT js via require so that we *know* it's loaded when it's meant to be used below.
    'gpt': (if "https:" is document.location.protocol then "https:" else "http:") + "//www.googletagservices.com/tag/js/gpt"

  waitSeconds: 40

define ['gpt'], ->
  
  adManager =
    init : (_config) ->
      # GPT Boilerplate code
      window.googletag = window.googletag || {}
      googletag.cmd = googletag.cmd || []
        # Truncated from original Boilerplate code due to using requireJS
      # END GPT Boilerplate code

      googletag.cmd.push ->
        adCount = 0
        toDisplay = lp.ads.toDisplay
        
        i = 0
        while i < toDisplay.length
          type = toDisplay[i]
          adEl = document.getElementById("js-ad-"+type)
          adSize = _config.sizes[type]
          newId = "js-ad-"+type+"-"+adCount

          # If the adEl doesn't exist on the page, return false so that JS execution doesn't fail.
          if adEl is null
            i++
            continue

          adCount++
          
          # Exploit the fact that getElementById only returns the FIRST element with that ID and make this one unique.
          adEl.id = newId
          # Force the width and height while the ad's loading.
          # adEl.style.width = adSize[0]+'px'
          # adEl.style.height = adSize[1]+'px'

          unit = [lp.ads.networkCode] # Network Code - Found in the "Admin" tab of DFP
          unit.push(lp.ads.layer1) if lp.ads.layer1
          unit.push(lp.ads.layer2) if lp.ads.layer2
          unit.push(lp.ads.layer3) if lp.ads.layer3
          unit.push(lp.ads.layer4) if lp.ads.layer4
          unit.push(lp.ads.layer5) if lp.ads.layer5
          
          googletag.defineSlot("/"+unit.join("/"), _config.sizes[type], newId).addService(googletag.pubads())

          if type is 'mpu'
            adManager.checkMpu(adEl)

          # Make sure we get all instances of this type of ad.
          i++ if document.getElementById("js-ad-"+type) is null

        # This is just a JSON formatted object to make it easy to add as many key:value pairs as desired.
        for key of lp.ads.keyValues
          googletag.pubads().setTargeting(key, lp.ads.keyValues[key])

        # Deprecated key:value pairs
        googletag.pubads().setTargeting("adZone", lp.ads.adZone)
        googletag.pubads().setTargeting("ctt", lp.ads.continent) if lp.ads.continent
        googletag.pubads().setTargeting("cnty", lp.ads.country) if lp.ads.country
        googletag.pubads().setTargeting("dest", lp.ads.destination) if lp.ads.destination
        googletag.pubads().setTargeting("tnm", lp.ads.adTnm) if lp.ads.adTnm

        googletag.pubads().enableSingleRequest()
        googletag.enableServices()

        googletag.pubads().refresh()

    checkMpu : (adEl) ->
      # Ugly but necessary. DOM Mutation events are deprecated, and there's not enough support for MutationObserver yet.
      poll = window.setInterval ->
        iframe = $(adEl).find('iframe')

        # If something's been loaded into our ad element
        if $.trim adEl.innerHTML isnt '' and iframe.height() > 0
          window.clearInterval poll

          if iframe.height() > $(adEl).height()
            thisCard = $(adEl).closest('.card').addClass 'ad-doubleMpu'
            cardsPerRow = Math.floor $(adEl).closest('.grid-view').width() / (thisCard.width() / 2)
            cards = $('.results .card')
            thisCardIndex = cards.index(thisCard)

            # If this is the last card, there's no need to carry on... just let the ad push the content down.
            if (cards.length is thisCardIndex+1)
              return false

            # Eliminate all cards preceding our ad element so we can place a dummy el at the nth position *after* the current one using .eq()
            cards = $(cards.splice(thisCardIndex))
            dummyEl = '<div class="card card--ad card--double card--list card--dummy" />'

            thisCard.css(
              left: thisCard.position().left
              position: 'absolute'
              top: thisCard.position().top
            )

            # cardsPerRow - 2 because the mpu takes the width of 2 cards.
            cards.eq(cardsPerRow - 2).after(dummyEl)
            thisCard.before(dummyEl)
      , 250

    # The old init used in the site wide leaderboard.
    initOld : (_config,_target) ->
      _config.service?= 'http://ad.doubleclick.net/adi/2009.lonelyplanet'
      iframe = document.createElement('iframe')
      iframe.src = "#{_config.service}/#{_config.adZone};#{_config.adKeywords};#{_config.segQS};tile=#{_config.tile};sz=#{_config.unit[0]}x#{_config.unit[1]};ord=#{_config.ord}?"
      iframe.title = "ad-leaderboard--frame"
      iframe.marginHeight = "0"
      iframe.marginWidth = "0"
      iframe.frameBorder = "0"
      iframe.scrolling = 'no'
      iframe.style.width = "#{_config.unit[0]}px"
      iframe.style.height = "#{_config.unit[1]}px"
      s = document.getElementById(_target)
      s.appendChild(iframe)