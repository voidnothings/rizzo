require.config
  paths:
    # Include the GPT js via require so that we *know* it's loaded when it's meant to be used below.
    'gpt': "//www.googletagservices.com/tag/js/gpt"

  waitSeconds: 40

define ['gpt'], ->
  adManager =
    # sizes is all that's needed for the new implementation. The above can all be ditched when switching to the new manager.
    sizes:
      adSenseCard: [155,256]
      trafficDriver: [155,256]
      sponsorTile: [276,32]
      oneByOne: [1,1]
      leaderboard: [[970,66], [728,90]]
      mpu: [[300,250], [300, 600]]

    init : () ->
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
          adSize = adManager.sizes[type]
          newId = "js-ad-"+type+"-"+adCount

          # If the adEl doesn't exist on the page, return false so that JS execution doesn't fail.
          if adEl is null
            i++
            continue

          adCount++
          
          # Exploit the fact that getElementById only returns the FIRST element with that ID and make this one unique.
          adEl.id = newId

          unit = [lp.ads.networkCode] # Network Code - Found in the "Admin" tab of DFP
          j = 0
          while j < lp.ads.layers.length
            unit.push(lp.ads.layers[j])
            j++
          
          adUnit = googletag.defineSlot("/"+unit.join("/"), adSize, newId).addService(googletag.pubads())

          if type is 'mpu'
            adManager.checkMpu(adEl)
          else if /adsense/i.test(type) and lp.ads.channels
            adUnit.set("adsense_border_color", "FFFFFF")
              .set("adsense_background_color", "FFFFFF")
              .set("adsense_link_color", "0C77BF")
              .set("adsense_text_color", "677276")
              .set("adsense_url_color", "000000")
              .set("adsense_ad_types", "text")
              .set("adsense_channel_ids", lp.ads.channels)

          # TODO: remove type from the below - it's there for testing purposes. /spike
          if lp.ads.hideThenShow
            adManager.showLoaded(adEl, type)
          else if lp.ads.showThenHide
            adManager.hideEmpty(adEl, type)

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
        googletag.pubads().collapseEmptyDivs()
        googletag.enableServices()

        googletag.pubads().refresh()

    checkMpu : (adEl) ->
      adManager.afterLoaded adEl, (adEl, iframe) ->
        if iframe.height() > $(adEl).height()
          thisCard = $(adEl).closest('.card').addClass 'ad-doubleMpu'
          cardsPerRow = Math.floor $(adEl).closest('.grid-view').width() / (thisCard.width() / 2)
          cards = $('.results .card')
          thisCardIndex = cards.index(thisCard)
          
          # If this is the third last card (there will always be *at least* a trafficDriver and adsense card following),
          # then there's no need to carry on... just let the ad push the content down.
          if (cards.length - thisCardIndex <= 3)
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

    hideEmpty : (adEl, type) -> # TODO: remove type /spike
      adManager.afterLoaded adEl, (adEl, iframe) ->
        # TODO: Remove the following line - used for testing only. /spike
        adEl.style.display = 'none' if type is 'leaderboard' and lp.ads.fakeEmptyLeaderboard
        if adEl.style.display is 'none'
          $(adEl).closest('.row--leaderboard').addClass('is-closed')
          $(adEl).closest('.card').addClass('is-closed')

    showLoaded : (adEl, type) ->
      adManager.afterLoaded adEl, (adEl, iframe) ->
        # TODO: Remove the following line - used for testing only. /spike
        adEl.style.display = 'none' if type is 'leaderboard' and lp.ads.fakeEmptyLeaderboard
        if adEl.style.display isnt 'none' or (lp.ads.forceShow and not (type is 'leaderboard' and lp.ads.fakeEmptyLeaderboard))
          $(adEl).closest('.row--leaderboard').removeClass('is-closed')
          $(adEl).closest('.card').removeClass('is-closed')

    # Abstract this polling functionality out for use in both checkMpu and hideEmpty
    afterLoaded : (adEl, callback) ->
      # Ugly but necessary. DOM Mutation events are deprecated, and there's not enough support for MutationObserver yet so we have to poll.
      poll = window.setInterval ->
        iframe = $(adEl).children('iframe')

        # If something's been loaded into our ad element
        if $.trim adEl.innerHTML isnt '' and iframe.height() > 0
          window.clearInterval poll

          callback.apply(this, [adEl, iframe])
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