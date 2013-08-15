require ['public/assets/javascripts/lib/components/proximity_loader.js'], (ProximityLoader) ->

  config =
    list: ".js-loader-one, .js-loader-two, .js-loader-three"
    callback: (elem)->
      console.log(elem)

  config_scoped =
    el: '#js-scoped'
    list: ".js-loader-one, .js-loader-two, .js-loader-three"
    callback: (elem)->
      console.log(elem)

  describe 'Proximity Loader', ->

    describe 'Object', ->
      it 'is defined', ->
        expect(ProximityLoader).toBeDefined()


    describe 'Initialisation', ->
      beforeEach ->
        loadFixtures('proximity_loader.html')
        window.proximityLoader = new ProximityLoader(config)
        spyOn(proximityLoader, "_check")
        spyOn(proximityLoader, "_getViewportEdge").andReturn(0)
        proximityLoader.constructor(config)

      it 'creates an object of positions and thresholds for each element', ->
        expect(window.proximityLoader.elems[0].top).toEqual(100)
        expect(window.proximityLoader.elems[0].threshold).toEqual(50)

        expect(window.proximityLoader.elems[1].top).toEqual(200)
        expect(window.proximityLoader.elems[1].threshold).toEqual(50)
        
        expect(window.proximityLoader.elems[2].top).toEqual(300)
        expect(window.proximityLoader.elems[2].threshold).toEqual(50)

      it 'checks to see if we have any elements that require scripts loading', ->
        expect(proximityLoader._check).toHaveBeenCalled()


    describe 'Scrolling', ->
      beforeEach ->
        loadFixtures('proximity_loader.html')
        window.proximityLoader = new ProximityLoader(config)
        spyOn(proximityLoader, "_check")
        $(window).trigger('scroll')
        waits(200)

      it 'calls _check', ->
        expect(proximityLoader._check).toHaveBeenCalled()


    describe 'Firing the callback when required', ->
      beforeEach ->
        loadFixtures('proximity_loader.html')
        window.proximityLoader = new ProximityLoader(config)
        spyOn(proximityLoader, "_getViewportEdge").andReturn(150)
        spyOn(console, "log")
        proximityLoader._check()

      it 'returns positive for two out of three elements', ->
        expect(console.log).toHaveBeenCalledWith(proximityLoader.elems[0].$el)
        expect(console.log).toHaveBeenCalledWith(proximityLoader.elems[1].$el)
        expect(console.log).not.toHaveBeenCalledWith(proximityLoader.elems[2].$el)
