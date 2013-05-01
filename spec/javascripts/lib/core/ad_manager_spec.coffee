require ['public/assets/javascripts/lib/core/ad_manager'], (adManager) ->

  describe 'adManager', ->
    
    it 'is defined', ->
      expect(adManager).toBeDefined()

    it 'has loaded the GPT js', ->
      expect(window.googletag).toBeDefined()

    describe 'initialize', ->

      beforeEach ->
        loadFixtures 'adBoxes.html'
        spyOn googletag, 'defineSlot'
        adManager.init
          adZone : 'home'
          adKeywords : ' '
          tile : ' '
          ord : Math.random()*10000000000000000
          segQS : ' '
          mtfIFPath : '/'
          unit: [728,90]
          sizes:
            trafficDriver: [192,185]
            sponsorTile: [276,32]
            oneByOne: [1,1]
            leaderboard: [728,90]
            pushdown: [970,66]
            mpu: [300,250]

      it 'has a `cmd` array', ->
        expect(googletag.cmd).toBeDefined()

      it 'knows which types of ads to show', ->
        expect(lp.ads.toDisplay).toBeDefined()

      it 'knows the network code', ->
        expect(lp.ads.networkCode).toBeDefined()

      it 'has at least 1 layer defined', ->
        expect(lp.ads.layer1).toBeDefined()

      it 'defines at least 1 ad slot', ->
        expect(window.googletag.defineSlot).toHaveBeenCalled()

      it 'loads the ads', ->
        waitsFor (->
          # The ads are loaded into iframes in the containers. NOTE: use `>=` because sometimes, GPT will add an 'hidden' one (who knows why)
          $("[id^=\"js-ad-\"]").length >= $("[id^=\"js-ad-\"] iframe").length
        ), "ads to be loaded into the expected divs"