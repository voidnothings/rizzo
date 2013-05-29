require ['public/assets/javascripts/lib/components/availability_search.js'], (Availability) ->

  describe 'Availability', ->
    
    describe 'Setup', ->
      it 'is defined', ->
        expect(Availability).toBeDefined()


    describe 'Initialisation', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})

      it 'has an event listener constant', ->
        expect(av.config.LISTENER).toBeDefined()


    describe 'on page request', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})
        spyOn(av, "_block")
        $(av.config.LISTENER).trigger(':page/request')

      it 'disables the availability form', ->
        expect(av._block).toHaveBeenCalled()


    describe 'on page received', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})
        spyOn(av, "_unblock")
        spyOn(av, "_set")
        spyOn(av, "_hide")

      describe 'if the user has searched', ->
        beforeEach ->
          spyOn(av, "hasSearched").andReturn(true)
          $(av.config.LISTENER).trigger(':page/received', {page_offsets: 2})
      
        it 'hides the availability form', ->
          expect(av._hide).toHaveBeenCalled()

        it 'enables the availability form', ->
          expect(av._unblock).toHaveBeenCalled()

        it 'updates the page offset', ->
          expect(av._set).toHaveBeenCalled()

      describe 'if the user has not already searched', ->
        beforeEach ->
          spyOn(av, "hasSearched").andReturn(false)
          $(av.config.LISTENER).trigger(':page/received', {page_offsets: 2})

        it 'does not hide the availability form', ->
          expect(av._hide).not.toHaveBeenCalled()


    describe 'on search', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})
        spyOn(av, "_setDefaultDates").andReturn(true)

      it 'triggers the page request event', ->
        spyEvent = spyOnEvent(av.$el, ':page/request');
        av.$form.trigger('submit')
        expect(':page/request').toHaveBeenTriggeredOn(av.$el)


    describe 'when the user wants to change dates', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})
        spyOn(av, "_show")
        $(av.config.LISTENER).trigger(':search/change')

      it 'shows the availability form', ->
        expect(av._show).toHaveBeenCalled()

