require.config
  paths:
    # Include the GPT js via require so that we *know* it's loaded when it's meant to be used below.
    'gpt': "//www.googletagservices.com/tag/js/gpt"

  waitSeconds: 40

require ['gpt'], ->
  adManager =
    # sizes is all that's needed for the new implementation.
    sizes:
      adSense: [155,256]
      trafficDriver: [192,380]
      sponsorTile: [276,32]
      oneByOne: [1,1]
      leaderboard: [[970,66], [728,90]]
      mpu: [[300,250], [300, 600]]

    init : () ->
      # NOTE: The following line is temporary until we switch to the new DFP server.
      $('body').removeClass('ad-manager-tmp').addClass('new-ad-manager')

      # GPT Boilerplate code
      window.googletag = window.googletag || {}
      googletag.cmd = googletag.cmd || []
        # Truncated from original Boilerplate code due to using requireJS
      # END GPT Boilerplate code

      googletag.cmd.push ->
        adCount = 0
        toDisplay = lp.ads.toDisplay

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

          adCount++

          # Make sure we get all instances of this type of ad.
          i++ if document.getElementById("js-ad-"+type) is null or adEl is null

          # If the adEl doesn't exist on the page, continue to the next iteration so that JS execution doesn't fail.
          if adEl is null
            continue

          # Exploit the fact that getElementById only returns the FIRST element with that ID and make this one unique.
          adEl.id = newId

          if /adsense/i.test(type)
            # Note: we're using the old, non DFP way of calling adsense ads. Ideally once we figure out how to serve these through DFP, this can be ditched in favour of the below commented out code.
            continue

          adUnit = googletag.defineSlot("/"+unit.join("/"), adSize, newId).addService(googletag.pubads())

          if type is 'mpu'
            adManager.checkMpu(adEl)
          # DFP code... we can't use this atm.
          # else if /adsense/i.test(type) and lp.ads.channels
            # adUnit.set("adsense_border_color", "FFFFFF")
            #   .set("adsense_background_color", "FFFFFF")
            #   .set("adsense_link_color", "0C77BF")
            #   .set("adsense_text_color", "677276")
            #   .set("adsense_url_color", "000000")
            #   .set("adsense_ad_types", "text")
            #   .set("adsense_channel_ids", lp.ads.channels.replace(/\s/g, '+'))

          adManager.showLoaded(adEl, type)

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
        googletag.pubads().collapseEmptyDivs()
        googletag.enableServices()

        googletag.pubads().refresh()

    checkMpu : (adEl) ->
      adManager.afterLoaded adEl, (adEl, iframe) ->
        if iframe.height() > $(adEl).height()
          # We need a timeout here because the leaderboard might be animating down which messes with our 'top' calc.
          setTimeout ->
            thisCard = $(adEl).closest('.card').addClass 'ad-doubleMpu'
            grid = $(adEl).closest('.grid-view')
            cardsPerRow = Math.floor grid.width() / (grid.find('.card--single').width())
            cards = $('.results .card')
            thisCardIndex = cards.index(thisCard)

            # If this is the third last card (there will always be *at least* a trafficDriver and adsense card following),
            # then there's no need to carry on... just let the ad push the content down.
            if (cards.length - thisCardIndex < 3)
              return false

            # Eliminate all cards preceding our ad element so we can place a dummy el at the nth position *after* the current one using .eq()
            cards = $(cards.splice(thisCardIndex))
            dummyCard = '<div class="card card--ad card--double card--list card--placeholder" />'

            thisCard.css(
              left: thisCard.position().left
              position: 'absolute'
              top: thisCard.position().top
            )

            # cardsPerRow - 2 because the mpu takes the width of 2 cards.
            cards.eq(cardsPerRow - 2).after(dummyCard)
            thisCard.before(dummyCard)
          , 500

    showLoaded : (adEl, type) ->
      adManager.afterLoaded adEl, (adEl, iframe) ->
        if adEl.style.display isnt 'none'
          $(adEl).closest('.row--leaderboard').removeClass('is-closed')
          $(adEl).closest('.card').removeClass('is-closed')

    # Abstract this polling functionality out for use in both checkMpu and hideEmpty
    afterLoaded : (adEl, callback) ->
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

        iframe = $(adEl).children('iframe')

        # If something's been loaded into our ad element, we're good to go
        if $.trim adEl.innerHTML isnt '' and iframe.height() > 0
          window.clearInterval poll

          callback.apply(this, [adEl, iframe])
      , timeout

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