define ['gpt'], ->
  adManager =
    # sizes is all that's needed for the new implementation.
    sizes:
      adSense: [155,256]
      leaderboard: [[970,66], [728,90]]
      mpu: [[300,250], [300, 600]]
      sponsorTile: [276,32]
      trafficDriver: [192,380]

    adUnits: {}
    firstLoaded: false

    init : () ->

      # GPT Boilerplate code
      window.googletag = window.googletag || {}
      googletag.cmd = googletag.cmd || []
        # Truncated from original Boilerplate code due to using requireJS
      # END GPT Boilerplate code

      googletag.cmd.push ->
        adCount = 0
        ord = Math.random()
        toDisplay = lp.ads.toDisplay
        toPoll = {}

        unit = [lp.ads.networkCode] # Network Code - Found in the "Admin" tab of DFP
        i = 0
        while i < lp.ads.layers.length
          unit.push(lp.ads.layers[i])
          i++

        i = 0
        while i < toDisplay.length
          type = toDisplay[i]
          adEl = document.getElementById("js-ad-"+type)
          adSize = adManager.sizes[type]
          newId = "js-ad-"+type+"-"+adCount
          pubAds = googletag.pubads()

          adCount++

          # Make sure we get all instances of this type of ad.
          i++ if document.getElementById("js-ad-"+type) is null or adEl is null

          # If the adEl doesn't exist on the page, continue to the next iteration so that JS execution doesn't fail.
          if adEl is null
            continue

          # Exploit the fact that getElementById only returns the FIRST element with that ID and make this one unique.
          adEl.id = newId

          if /mpu/i.test(type)
            toPoll[newId] = ->
              adManager.showAd.apply this, arguments

          adUnit = googletag.defineSlot("/"+unit.join("/"), adSize, newId).addService(pubAds)

          # These are also deprecated and can be removed at some point in the future.
          adUnit.setTargeting('ord', ord)
          adUnit.setTargeting('tile', adCount)
          # End deprecated.

          adManager.adUnits[newId] = adUnit

        # This is just a JSON formatted object to make it easy to add as many key:value pairs as desired.
        for key of lp.ads.keyValues
          if lp.ads.keyValues.hasOwnProperty(key)
            pubAds.setTargeting(key, lp.ads.keyValues[key])

        # Deprecated key:value pairs
        pubAds.setTargeting("ctt", lp.ads.continent) if lp.ads.continent
        pubAds.setTargeting("cnty", lp.ads.country) if lp.ads.country
        pubAds.setTargeting("dest", lp.ads.destination) if lp.ads.destination
        pubAds.setTargeting("tnm", lp.ads.adTnm) if lp.ads.adTnm
        pubAds.setTargeting("thm", lp.ads.adThm) if lp.ads.adThm
        # End deprecated.

        pubAds.enableSingleRequest()
        pubAds.collapseEmptyDivs()
        googletag.enableServices()

        # Call the display method for all ads we've defined.
        for ad of adManager.adUnits
          if adManager.adUnits.hasOwnProperty(ad)
            googletag.display(ad)

        # Kick off polling where needed.
        for elId of toPoll
          if toPoll.hasOwnProperty(elId)
            adManager.poll document.getElementById(elId), toPoll[elId]

    showAd : (adEl, iframe) ->
      if adEl.style.display isnt 'none'
        if iframe.width > 310
          adEl.parentNode.classList.add('ad-house')
        adEl.parentNode.classList.remove('is-closed')
        adEl.classList.remove('is-faded-out')


    # Abstract this polling functionality out for use in both checkMpu and hideEmpty
    poll : (adEl, callback) ->
      count = 0
      maxPoll = 15000 # The maximum amount of milliseconds to poll for
      timeout = 250

      # Ugly but necessary. DOM Mutation events are deprecated, and there's not enough support for MutationObserver yet so we have to poll.
      poll = window.setInterval ->
        count++

        # Make sure we're not running this thing indefinitely
        if (count >= maxPoll/timeout)
          window.clearInterval poll
          return

        iframe = adEl.querySelector('iframe')
        # If something's been loaded into our ad element, we're good to go
        if adEl.style.display isnt 'none' and iframe
          
          # Sometimes ads just load scripts which don't themselves produce content
          # This is to catch that
          hasContent = (iframe) ->
            children = iframe.contentDocument.body.children
            count = 0
            while count < children.length
              if children[count].nodeName isnt "SCRIPT" && children[count].nodeName isnt "NOSCRIPT"
                return true
              count++
            false

          if hasContent(iframe)
            callback.apply(this, [adEl, iframe])

            window.clearInterval poll

            if not adManager.firstLoaded and window.lp and lp.fs and lp.fs.time
              window.lp.fs.time(
                'e':'/destination/ad/first'
              )
              adManager.firstLoaded = true
      , timeout