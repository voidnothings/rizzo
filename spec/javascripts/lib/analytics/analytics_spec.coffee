require ['public/assets/javascripts/lib/analytics/analytics.js'], (Analytics) ->

  describe 'Analytics', ->

    describe 'Setup', ->
      it 'is defined', ->
        expect(Analytics).toBeDefined()

    describe 'instance', ->
      beforeEach ->
        windowStub =
          s:
            t: ->
            tl: ->
          lp: {tracking: {}}
        @analytics = new Analytics(windowStub)
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

      describe 'track and restore', ->
        beforeEach ->
          @params = {hello: 'world'}
          @restore = true
          spyOn(@analytics, '_save')
          spyOn(@analytics, '_add')
          spyOn(@analytics, '_copy')
          spyOn(@analytics, '_restore')
          spyOn(@analytics._window.s, 't')
          @analytics.track(@params, @restore)

        it 'should _save config', ->
          expect(@analytics._save).toHaveBeenCalled()

        it 'should _add params', ->
          expect(@analytics._add).toHaveBeenCalled()

        it 'should _copy config', ->
          expect(@analytics._copy).toHaveBeenCalled()

        it 'should execute _window.s.t function', ->
          expect(@analytics._window.s.t).toHaveBeenCalled()

        it 'should restore equilibrium', ->
          expect(@analytics._restore).toHaveBeenCalled()

      describe 'trackLink and restore', ->
        beforeEach ->
          @params = {hello: 'world'}
          spyOn(@analytics, '_save')
          spyOn(@analytics, '_add')
          spyOn(@analytics, '_copy')
          spyOn(@analytics, '_restore')
          spyOn(@analytics._window.s, 'tl')
          @analytics.trackLink('name', @params)

        it 'should _save config', ->
          expect(@analytics._save).toHaveBeenCalled()

        it 'should _add params', ->
          expect(@analytics._add).toHaveBeenCalled()

        it 'should _copy config', ->
          expect(@analytics._copy).toHaveBeenCalled()

        it 'should execute _window.s.tl function', ->
          expect(@analytics._window.s.tl).toHaveBeenCalled()

        it 'should restore equilibrium', ->
          expect(@analytics._restore).toHaveBeenCalled()




