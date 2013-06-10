require ['public/assets/javascripts/lib/analytics/analytics.js'], (Analytics) ->

  describe 'Analytics', ->

    describe 'Setup', ->
      it 'is defined', ->
        expect(Analytics).toBeDefined()

    describe 'instance', ->
      beforeEach ->
        @windowStub =
          s:
            t: ->
            tl: ->
          lp: {tracking: {}}
        @analytics = new Analytics(@windowStub)
      it 'should initialize', ->
        expect(@analytics).toBeDefined()

      describe 'members', ->
        it '@_window', ->
          expect(@analytics._window).toBeDefined()

        it '@config', ->
          expect(@analytics.config).toBeDefined()

      describe 'trackView', ->
        beforeEach ->
          @pagePerfResult = {eVar71: '10:11:12'}
          spyOn(@analytics, '_pagePerf').andReturn(@pagePerfResult)
          spyOn(@analytics, 'track')
          @analytics.trackView()
        it 'gets page performance', ->
          expect(@analytics._pagePerf).toHaveBeenCalled()

        it 'tracks', ->
          expect(@analytics.track).toHaveBeenCalledWith(@pagePerfResult, true)

      describe 'track', ->
        beforeEach ->
          @params = {hello: 'something I need to track'}
          @restore = true
          spyOn(@analytics, '_save').andCallThrough()
          spyOn(@analytics, '_add').andCallThrough()
          spyOn(@analytics, '_copy').andCallThrough()
          spyOn(@analytics._window.s, 't')

        it 'should store event to window.s', ->
          spyOn(@analytics, '_restore')
          @analytics.track(@params, @restore)
          expect(@windowStub.s.hello).toEqual('something I need to track')

        it 'should execute _window.s.t function', ->
          spyOn(@analytics, '_restore')
          @analytics.track(@params, @restore)
          expect(@analytics._window.s.t).toHaveBeenCalled()

        describe 'and restore', ->
          it 'should restore equilibrium', ->
            spyOn(@analytics, '_restore').andCallThrough()
            @analytics.track(@params, @restore)
            expect(@windowStub.s.hello).toBeUndefined()

      describe 'trackLink', ->
        beforeEach ->
          @params = {hello: 'some link I need to track'}
          spyOn(@analytics, '_save').andCallThrough()
          spyOn(@analytics, '_add').andCallThrough()
          spyOn(@analytics, '_copy').andCallThrough()
          spyOn(@analytics._window.s, 'tl')

        it 'should store event to window.s', ->
          spyOn(@analytics, '_restore')
          @analytics.trackLink('name', @params)
          expect(@windowStub.s.hello).toEqual('some link I need to track')

        it 'should execute _window.s.tl function', ->
          spyOn(@analytics, '_restore')
          @analytics.trackLink('name', @params)
          expect(@analytics._window.s.tl).toHaveBeenCalled()

        describe 'and restore', ->
          it 'should restore equilibrium', ->
            spyOn(@analytics, '_restore').andCallThrough()
            @analytics.trackLink('name', @params)
            expect(@windowStub.s.hello).toBeUndefined()




