require ['public/assets/javascripts/lib/utils/asset_reveal.js'], (AssetReveal) ->

  describe 'AssetReveal', ->

    describe 'Object', ->
      it 'is defined', ->
        expect(AssetReveal).toBeDefined()

    describe 'Initialisation', ->
      beforeEach ->
        window.assetReveal = new AssetReveal()
        spyOn(window.assetReveal, "listen")

      it 'does not initialise when the element does not exist', ->
        expect(window.assetReveal.listen).not.toHaveBeenCalled()


    describe 'Uncommenting', ->
      beforeEach ->
        loadFixtures('hidden_assets.html')
        window.assetReveal = new AssetReveal()
        $("#js-row--content").trigger(":asset/uncomment", [".foo", "[data-uncomment]"])

      it 'uncomments the image', ->
        expect(window.assetReveal.$listener.find('.bar').length).toBe(1)


    describe 'Uncommenting a script', ->
      beforeEach ->
        loadFixtures('hidden_assets.html')
        window.assetReveal = new AssetReveal()
        spyOn(console, "log")
        $("#js-row--content").trigger(":asset/uncommentScript", [".foo2", "[data-uncomment]"])

      it 'uncomments the image', ->
        expect(console.log).toHaveBeenCalledWith("This test passes")


    describe 'Unblocking a background image', ->
      beforeEach ->
        loadFixtures('hidden_assets.html')
        window.assetReveal = new AssetReveal()
        $("#js-row--content").trigger(":asset/loadBgImage", [".foo3"])

      it 'removes the image blocking class', ->
        expect(window.assetReveal.$listener.find('.image')).not.toHaveClass('rwd-image-blocker')
