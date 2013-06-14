require ['public/assets/javascripts/lib/components/place_list.js'], (PlaceList) ->

  describe 'PlacesList', ->

    config = 
      el: '#js-stack-list-aside', 
      list: '.js-descendant-item, .js-nearby-place-item'

    describe 'Object', ->
      it 'is defined', ->
        expect(PlaceList).toBeDefined()

      it 'has default options', ->
        expect(PlaceList::config).toBeDefined()


    describe 'Initialising', ->
      beforeEach ->
        loadFixtures('places_list.html')
        window.placesList = new PlaceList({ el: '.foo'})
        spyOn(placesList, "init")

      it 'When the parent element does not exist it does not initialise', ->
        expect(placesList.init).not.toHaveBeenCalled()


    describe 'Updating', ->
      beforeEach ->
        loadFixtures('places_list.html')
        window.placesList = new PlaceList(config)
        spyOn(placesList, "getParams").andReturn("?foo=bar")
        placesList._update()

      it 'updates the descendant item hrefs', ->
        expect(placesList.$el.find('.js-descendant-item').attr('href')).toContain('/country?foo=bar')

      it 'updates the nearby place item hrefs', ->
        expect(placesList.$el.find('.js-nearby-place-item').attr('href')).toContain('/nearby-place?foo=bar')


    describe 'on cards received', ->
      beforeEach ->
        loadFixtures('places_list.html')
        window.placesList = new PlaceList(config)

      describe 'it calls', ->
        beforeEach ->
          spyOn(placesList, '_update')
          $(placesList.config.LISTENER).trigger(':cards/received')

        it 'calls placesList._update', ->
          expect(placesList._update).toHaveBeenCalled()
