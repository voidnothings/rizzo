require ['public/assets/javascripts/lib/maps/map_manager', 'gpt'], (MapManager) ->

  describe 'MapManager', ->

    window.lp = {
      lodging:
        map: {}
    }

    describe 'object', ->
      it 'is defined', ->
        expect(MapManager).toBeDefined()

    describe '@_sanitizeData', ->
      beforeEach ->
        window.mapManager = MapManager

      describe 'activities', ->

        describe 'has corresponding uri', ->
          beforeEach ->
            @data = {"activities":[{"properties":{"id":"403456","title":"Relax House","uri":"/vietnam/ho-chi-minh-city/activities/day-spa/relax-house"}}]}

          it 'returns activities', ->
            expect(mapManager._sanitizeData(@data)).toEqual(@data)
            expect(mapManager._sanitizeData(@data).activities.length).toEqual(1)

        describe 'has no uri', ->
          beforeEach ->
            @data = {"activities":[{"properties":{"id":"403456","title":"Relax House","uri":""}}]}

          it 'filters activities', ->
            expect(mapManager._sanitizeData(@data).activities.length).toEqual(0)

      describe 'sights', ->

        describe 'has corresponding uri', ->
          beforeEach ->
            @data = {"sights":[{"properties":{"id":"403456","title":"Galerie Quynh","uri":"/vietnam/ho-chi-minh-city/sights/gallery/galerie-quynh"}}]}

          it 'returns sights', ->
            expect(mapManager._sanitizeData(@data)).toEqual(@data)
            expect(mapManager._sanitizeData(@data).sights.length).toEqual(1)

        describe 'has no uri', ->
          beforeEach ->
            @data = {"sights":[{"properties":{"id":"403456","title":"Galerie Quynh","uri":""}}]}

          it 'filters sights', ->
            expect(mapManager._sanitizeData(@data).sights.length).toEqual(0)

      describe 'entertainment-nightlife', ->

        describe 'has corresponding uri', ->
          beforeEach ->
            @data = {"entertainment-nightlife":[{"properties":{"id":"403456","title":"Galerie Quynh","uri":"/vietnam/ho-chi-minh-city/entertainment-nightlife/galerie-quynh"}}]}

          it 'returns entertainment-nightlife', ->
            expect(mapManager._sanitizeData(@data)).toEqual(@data)
            expect(mapManager._sanitizeData(@data)['entertainment-nightlife'].length).toEqual(1)

        describe 'has no uri', ->
          beforeEach ->
            @data = {"entertainment-nightlife":[{"properties":{"id":"403456","title":"Galerie Quynh","uri":""}}]}

          it 'filters entertainment-nightlife', ->
            expect(mapManager._sanitizeData(@data)['entertainment-nightlife'].length).toEqual(0)

      describe 'restaurants', ->

        describe 'has corresponding uri', ->
          beforeEach ->
            @data = {"restaurants":[{"properties":{"id":"403456","title":"Galerie Quynh","uri":"/vietnam/ho-chi-minh-city/restaurants/gallery/galerie-quynh"}}]}

          it 'returns restaurants', ->
            expect(mapManager._sanitizeData(@data)).toEqual(@data)
            expect(mapManager._sanitizeData(@data).restaurants.length).toEqual(1)

        describe 'has no uri', ->
          beforeEach ->
            @data = {"restaurants":[{"properties":{"id":"403456","title":"Galerie Quynh","uri":""}}]}

          it 'filters restaurants', ->
            expect(mapManager._sanitizeData(@data).restaurants.length).toEqual(0)

    describe 'on page load:', ->
      beforeEach ->
        loadFixtures('map_manager.html')
        window.mapManager = new MapManager
          centerTrigger: '.js-map-center-trigger'
          centerDelay: 500
          minimalUI: true

      it 'Loads successfully', ->
        waitsFor ->
          return !$('#js-map-canvas').hasClass('is-loading')
        , '`is-loading` class to be removed', 2000

    describe 'event based load:', ->
      beforeEach ->
        loadFixtures('map_manager.html')
        spyOn(MapManager, 'loadLib')
        window.mapEventConfig =
          centerTrigger: '.js-map-center-trigger'
          centerDelay: 500
          loadSelector:'.js-map-trigger'
          loadEventType: 'click'
          minimalUI: true

      it 'Doesn\'t load before the specified event.', ->
        window.mapManager = new MapManager(mapEventConfig)
        expect(MapManager.loadLib).not.toHaveBeenCalled()

      it 'Loads successfully after the specified event.', ->
        window.mapManager = new MapManager(mapEventConfig)
        $('.js-map-trigger').trigger('click')
        expect(MapManager.loadLib).toHaveBeenCalled()
