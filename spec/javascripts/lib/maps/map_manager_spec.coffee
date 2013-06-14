require ['public/assets/javascripts/lib/maps/map_manager', 'gpt'], (MapManager) ->

  describe 'MapManager', ->

    window.lp = {
      lodging:
        map: {}
    }

    describe 'object', ->
      it 'is defined', ->
        expect(MapManager).toBeDefined()

    describe 'initialized', ->
      beforeEach ->
        window.mapManager = new MapManager()
      it 'is defined', ->
        expect(mapManager).toBeDefined()

    describe '_sanitizeData', ->
      beforeEach ->
        window.mapManager = new MapManager()

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
