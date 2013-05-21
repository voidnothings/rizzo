require ['public/assets/javascripts/lib/components/availability_search.js'], (Availability) ->

  describe 'Availability', ->

    beforeEach ->
      window.av = new Availability('.js-availability')

    describe 'Setup', ->
      it 'is defined', ->
        expect(Availability).toBeDefined()


    describe 'Initialisation', ->

      beforeEach ->
        spyOn(av, "getFilterState").andReturn(true)
        av.constructor()

      it 'has a event listener constant', ->
        expect(av.config.LISTENER).toBeDefined()

      it 'has a state object', ->
        expect(av.config.state).toBeDefined()

      it 'understands that filters have been applied', ->
        expect(av.config.state.filters).toBe(true)


    describe 'on page request', ->
      beforeEach ->
        spyOn(av, "disable")
        $(av.LISTENER).trigger(':page/request')

      it 'disables the availability form', ->
        expect(av.disable).toHaveBeenCalled()


    describe 'on page received', ->
      beforeEach ->
        spyOn(av, "enable")
        spyOn(av, "updateOffest")
        $(av.LISTENER).trigger(':page/received', {offset: 2})

      it 'enables the availability form', ->
        expect(av.enable).toHaveBeenCalled()

      it 'updates the page offset', ->
        expect(av.updateOffset).toHaveBeenCalled()


    describe 'on search', ->
      beforeEach ->
        spyEvent = spyOnEvent('av.LISTENER', ':page/request');

      it 'triggers the page request event', ->
        $('.js-availability').find('#js-booking-submit').trigger('click')
        expect(spyEvent).toHaveBeenTriggered()