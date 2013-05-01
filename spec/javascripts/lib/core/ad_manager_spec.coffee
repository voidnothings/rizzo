require ['jquery', 'public/assets/javascripts/lib/core/ad_manager'], ($, adManager) ->

  # Utility function to help setting up each test.
  adSetUp = (ad_types) ->
    loadFixtures 'adBoxes.html'
    # Possible ad types are: adSense, trafficDriver, sponsorTile, oneByOne, leaderboard, mpu
    window.lp.ads.toDisplay = ad_types
    $.each ad_types, ->
      $('.ad-container').append('<div id="js-ad-'+this+'" />')

  adsLoaded = ->
    # The ads are loaded into iframes in the containers. NOTE: use `>=` because sometimes, GPT will add a 'hidden' one (who knows why)
    $(".ad-container > div iframe").length >= $(".ad-container > div").length

  describe 'adManager', ->

    it 'is defined', ->
      expect(adManager).toBeDefined()

    it 'has loaded the GPT js', ->
      expect(window.googletag).toBeDefined()

    describe 'initializing', ->

      beforeEach ->
        adSetUp ["leaderboard", "mpu", "trafficDriver"]
        spyOn googletag, 'defineSlot'
        adManager.init()

      it 'creates a `cmd` array', ->
        expect(googletag.cmd).toBeDefined()

      it 'knows which types of ads to show', ->
        expect(lp.ads.toDisplay).toBeDefined()

      it 'knows the network code', ->
        expect(lp.ads.networkCode).toBeDefined()

      it 'has at least 1 layer defined', ->
        expect(lp.ads.layers.length > 0).toBe(true)

      it 'defines at least 1 ad slot', ->
        expect(window.googletag.defineSlot).toHaveBeenCalled()

    describe 'loading', ->

      beforeEach ->
        adSetUp ["leaderboard", "mpu", "trafficDriver"]
        adManager.init()

      it 'loads the ads', ->
        waitsFor (adsLoaded), "ads to be loaded into the expected divs"

    describe 'creates unique ids', ->

      beforeEach ->
        adSetUp ["leaderboard", "leaderboard", "mpu", "mpu", "trafficDriver", "trafficDriver"]
        adManager.init()

      it 'creates a unique id for each of the elements', ->
        allUnique = true

        $("[id^=\"js-ad-\"]").each ->
          # If it doesn't end with `-` and a number or there is more than one with this id.
          if !/\-[0-9+]$/.test(this.id) or $('[id="'+this.id+'"]').length > 1
            allUnique = false
            return

        expect(allUnique).toBe(true)

    describe 'ad sense ads', ->
      
      beforeEach ->
        adSetUp ["adSense"]
        adManager.init()

      it 'loads the ads', ->
        waitsFor (adsLoaded), "ad to be loaded into the expected div"
