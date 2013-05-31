require ['public/assets/javascripts/lib/extends/controller.js'], (Controller) ->

  describe 'Controller', ->

    serialized = 
      url: "http://www.lonelyplanet.com/france/paris/hotels"
      urlWithSearchAndFilters: "http://www.lonelyplanet.com/england/london/hotels?utf8=✓&search%5Bpage_offsets%5D=0%2C58&search%5Bfrom%5D=29+May+2013&search%5Bto%5D=30+May+2013&search%5Bguests%5D=2&search%5Bcurrency%5D=USD&filters%5Bproperty_type%5D%5B3star%5D=true&filters%5Blp_reviewed%5D=true"
      urlParams: "utf8=✓&search%5Bpage_offsets%5D=0%2C58&search%5Bfrom%5D=29+May+2013&search%5Bto%5D=30+May+2013&search%5Bguests%5D=2&search%5Bcurrency%5D=USD&filters%5Bproperty_type%5D%5B3star%5D=true&filters%5Blp_reviewed%5D=true"
      newUrlWithSearchAndFilters: "/?filters%5Bproperty_type%5D%5B4star%5D=true"
    
    deserialized =
      utf8: "✓"
      search:
        page_offsets: "0,58"
        from: "29 May 2013"
        to: "30 May 2013"
        guests: "2"
        currency: "USD"
      filters:
        property_type:
          "3star": "true"
        lp_reviewed: "true"

    newParams = 
      filters:
        property_type:
          "4star": true

    describe 'Setup', ->

      it 'is defined', ->
        expect(Controller).toBeDefined()

      it 'has default options', ->
        expect(Controller::config).toBeDefined()

      it 'has a listener', ->
        expect(Controller::config.LISTENER).toBeDefined()

      it 'has a state object', ->
        expect(Controller::state).toBeDefined()


    describe 'initialisation', ->
      beforeEach ->
        window.controller = new Controller()
        spyOn(controller, "_generateState")
        controller.init()

      it 'calls generateState with the current url', ->
        expect(controller._generateState).toHaveBeenCalled()


    describe 'generating state', ->
      beforeEach ->
        window.controller = new Controller()
        spyOn(controller, "getParams").andReturn(serialized.urlParams)

      it 'updates the state object with the search parameters', ->
        # Using JSON stringify to compare contents rather than instances
        controller._generateState(serialized.urlWithSearchAndFilters)
        expect(JSON.stringify(controller.state.params, null, 2) is JSON.stringify(deserialized, null, 2)).toBe(true)
        


    describe 'updating state', ->
      beforeEach ->
        window.controller = new Controller()
        controller._generateState(serialized.urlWithSearch)

      it 'creates a new state', ->
        controller._updateState(newParams)
        expect(Controller::state.filters["property_type"]["4star"]).toBe(true)


    describe 'creating the url from state', ->
      beforeEach ->
        window.controller = new Controller()
        spyOn(controller, "getUrl").andReturn("http://www.lonelyplanet.com/england/london/hotels?utf8=✓&search%5Bpage_offsets%5D=0%2C58&search%5Bfrom%5D=29+May+2013&search%5Bto%5D=30+May+2013&search%5Bguests%5D=2&search%5Bcurrency%5D=USD&filters%5Bproperty_type%5D%5B3star%5D=true&filters%5Blp_reviewed%5D=true")
        controller._generateState(serialized.urlWithSearch)

      it 'serializes the state', ->
        newUrl = controller._createUrl()
        expect(newUrl).toBe(serialized.newUrlWithSearchAndFilters)


    describe 'updating push state', ->
      beforeEach ->
        spyOn(history, 'pushState');
        window.controller = new Controller()
        controller._navigate("/test")

      it 'updates', ->
        expect(history.pushState).toHaveBeenCalledWith({}, null, "/test")

    describe 'calling the server', ->
      callback = -> true
      beforeEach ->
        window.controller = new Controller()
        spyOn($, "ajax")
        spyOn(controller, "_createUrl").andReturn("http://www.lonelyplanet.com?foo=bar")
        controller._callServer(callback)

      it 'creates a new url', ->
        expect(controller._createUrl).toHaveBeenCalled()

      it 'enters the ajax function', ->
        expect($.ajax).toHaveBeenCalledWith({url: "http://www.lonelyplanet.com?foo=bar", dataType : 'json', success : callback })


    describe 'on page request', ->
      beforeEach ->
        loadFixtures('controller.html')
        window.controller = new Controller()
        spyOn(controller, "_updateState")
        spyOn(controller, "_callServer")
        $(controller.config.LISTENER).trigger(':page/request', newParams)

      it 'updates the internal state', ->
        expect(controller._updateState).toHaveBeenCalledWith(newParams)

      it 'requests data from the server', ->
        expect(controller._callServer).toHaveBeenCalled()



    describe 'when the server returns data', ->
      beforeEach ->
        loadFixtures('controller.html')
        window.controller = new Controller()
        spyEvent = spyOnEvent(controller.$el, ':page/received');
        spyOn(controller, "_createUrl").andReturn('foo')
        spyOn(controller, "_navigate")
        controller.replace(newParams)

      it 'updates the push state', ->
        expect(controller._navigate).toHaveBeenCalledWith('foo')

      it 'triggers the page/received event', ->
        expect(':page/received').toHaveBeenTriggeredOnAndWith(controller.$el, newParams)



    describe 'when the server returns data and there is no support for pushState', ->
      beforeEach ->
        loadFixtures('controller.html')
        window.controller = new Controller()
        spyEvent = spyOnEvent(controller.$el, ':page/received');
        spyOn(controller, "_supportsHistory").andReturn(false)
        spyOn(controller, "_supportsHash").andReturn(true)
        spyOn(controller, "_createUrl").andReturn('foo')
        spyOn(controller, "_navigate")
        controller.replace(newParams)

      it 'updates the push state', ->
        expect(controller._navigate).toHaveBeenCalledWith('foo')

      it 'trigger the page/received event', ->
        expect(':page/received').toHaveBeenTriggeredOnAndWith(controller.$el, newParams)
