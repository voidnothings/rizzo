require ['public/assets/javascripts/lib/components/proximity_loader.js'], (ProximityLoader) ->

  config =
    list: ".js-loader-one, .js-loader-two, .js-loader-three"

  describe 'Proximity Loader', ->

    LISTENER = '#js-card-holder'

    describe 'Object', ->
      it 'is defined', ->
        expect(ProximityLoader).toBeDefined()


    describe 'Setup', ->
      beforeEach ->
        loadFixtures('proximity_loader.html')
        window.proximityLoader = new ProximityLoader(config)

      it 'creates an array of watchable objects', ->




        