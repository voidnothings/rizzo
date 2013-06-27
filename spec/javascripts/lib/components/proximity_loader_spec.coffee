require ['public/assets/javascripts/lib/components/proximity_loader.js'], (ProximityLoader) ->

  config =
    list: ".js-loader-one, .js-loader-two, .js-loader-three"

  config_scoped =
    el: '#js-scoped'
    list: ".js-loader-one, .js-loader-two, .js-loader-three"

  describe 'Proximity Loader', ->

    LISTENER = '#js-card-holder'

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


    describe 'Checking if we should load the script', ->
      beforeEach ->
        loadFixtures('proximity_loader.html')
        window.proximityLoader = new ProximityLoader(config)
        spyOn(proximityLoader, "_getViewportEdge").andReturn(150)
        spyOn(proximityLoader, "_loadScriptFor")
        proximityLoader._check()

      it 'loads scripts for two out of three elements', ->
        expect(proximityLoader._loadScriptFor).toHaveBeenCalledWith(proximityLoader.elems[0])
        expect(proximityLoader._loadScriptFor).toHaveBeenCalledWith(proximityLoader.elems[1])
        expect(proximityLoader._loadScriptFor).not.toHaveBeenCalledWith(proximityLoader.elems[2])


    describe 'Uncommenting the script', ->
      beforeEach ->
        window.proximityLoader = new ProximityLoader(config_scoped)
        spyOn(window.console, "log")
        # Load the fixtures after initialisation to avoid the first check for scripts
        loadFixtures('proximity_loader.html')
        proximityLoader._loadScriptFor({$el: $('#js-scoped').find('.js-loader-one')})

      it 'uncomments the first script', ->
        expect(window.console.log).toHaveBeenCalledWith("Hidden script")