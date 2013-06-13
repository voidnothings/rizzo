require ['public/assets/javascripts/lib/components/availability_search.js'], (Availability) ->

  describe 'Availability', ->
    
    describe 'Object', ->
      it 'is defined', ->
        expect(Availability).toBeDefined()


    describe 'Initialisation', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})

      it 'has an event listener constant', ->
        expect(av.config.LISTENER).toBe("#js-card-holder")



    # --------------------------------------------------------------------------
    # Private Methods
    # --------------------------------------------------------------------------

    describe 'get search data', ->
      beforeEach ->
        loadFixtures('availability.html')

      describe 'with values', ->
        beforeEach ->
          window.av = new Availability({el: '.js-availability-card-with-values'})

        it 'serializes the search data', ->
          values = av._getSearchData()
          expectedResult =
            search:
              from: "06 Jun 2013"
              to: "07 Jun 2013"
              guests: "1"
              currency: "USD"
          expect(values).toEqual(expectedResult)

      describe 'without values', ->
        beforeEach ->
          window.av = new Availability({el: '.js-availability-card'})
          spyOn(av, "_setDefaultDates")
          av._getSearchData()

        it 'sets the default dates', ->
          expect(av._setDefaultDates).toHaveBeenCalled()

    
    describe 'setting values', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card-with-values'})
        av._set("from", "test")

      it 'sets the start date', ->
        expect(av.$form.find('input[name*=from]').val()).toBe("test")


    describe 'showing', ->

      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({ el: '.js-availability-card-hidden'})
        av._show()

      it 'removes the is-hidden class', ->
        expect(av.$el).not.toHaveClass('is-hidden')


    describe 'hiding', ->

      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({ el: '.js-availability-card'})
        av._hide()

      it 'adds the is-hidden class', ->
        expect(av.$el).toHaveClass('is-hidden')


    describe 'blocking', ->

      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({ el: '.js-availability-card'})
        av._block()

      it 'adds the disabled class', ->
        expect(av.$submit).toHaveClass('disabled')

      it 'adds the disabled attribute', ->
        expect(av.$submit.attr('disabled')).toBe("disabled")


    describe 'unblocking', ->

      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({ el: '.js-availability-card-blocked'})
        av._unblock()

      it 'removes the disabled class', ->
        expect(av.$submit).not.toHaveClass('disabled')

      it 'adds the disabled attribute', ->
        expect(av.$submit.attr('disabled')).toBe(undefined)



    # --------------------------------------------------------------------------
    # Events API
    # --------------------------------------------------------------------------

    describe 'on cards request', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})
        spyOn(av, "_block")
        $(av.config.LISTENER).trigger(':cards/request')

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
          $(av.config.LISTENER).trigger(':cards/received', {pagination: {page_offsets: 2}})
      
        it 'hides the availability form', ->
          expect(av._hide).toHaveBeenCalled()

        it 'enables the availability form search button', ->
          expect(av._unblock).toHaveBeenCalled()

        it 'updates the page offset', ->
          expect(av._set).toHaveBeenCalledWith("page_offsets", 2)

      describe 'if the user has not already searched', ->
        beforeEach ->
          spyOn(av, "hasSearched").andReturn(false)
          $(av.config.LISTENER).trigger(':cards/received', {pagination: {page_offsets: 2}})

        it 'does not hide the availability form', ->
          expect(av._hide).not.toHaveBeenCalled()

        it 'enables the availability form search button', ->
          expect(av._unblock).toHaveBeenCalled()

        it 'updates the page offset', ->
          expect(av._set).toHaveBeenCalledWith("page_offsets", 2)


    describe 'on search', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})
        spyOn(av, "_setDefaultDates").andReturn(true)
        spyOn(av, "_getSearchData").andReturn("foo")

      it 'triggers the page request event with the search data', ->
        spyEvent = spyOnEvent(av.$el, ':cards/request');
        av.$form.trigger('submit')
        expect(':cards/request').toHaveBeenTriggeredOnAndWith(av.$el, "foo")


    describe 'when the user wants to change dates', ->
      beforeEach ->
        loadFixtures('availability.html')
        window.av = new Availability({el: '.js-availability-card'})
        spyOn(av, "_show")
        $(av.config.LISTENER).trigger(':search/change')

      it 'shows the availability form', ->
        expect(av._show).toHaveBeenCalled()

