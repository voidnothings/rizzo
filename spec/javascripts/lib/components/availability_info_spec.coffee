require ['public/assets/javascripts/lib/components/availability_info.js'], (AvailabilityInfo) ->

  describe 'AvailabilityInfo', ->
  
    params =
      search:
        from: "21 May 2013"
        to: "23 May 2013"
        guests: 1 
        currency: "USD"

    describe 'Setup', ->
      it 'is defined', ->
        expect(AvailabilityInfo).toBeDefined()


    describe 'Initialisation', ->
      beforeEach ->
        window.avInfo = new AvailabilityInfo({ el: '.js-availability-info'})

      it 'has an event listener constant', ->
        expect(avInfo.config.LISTENER).toBeDefined()


    describe 'on page request', ->
      beforeEach ->
        loadFixtures('availability_info.html')
        window.avInfo = new AvailabilityInfo({ el: '.js-availability-info'})
        spyOn(avInfo, "_block")
        $(avInfo.config.LISTENER).trigger(':page/request')

      it 'disables the availability form', ->
        expect(avInfo._block).toHaveBeenCalled()


    describe 'on page received', ->
      beforeEach ->
        loadFixtures('availability_info.html')
        window.avInfo = new AvailabilityInfo({ el: '.js-availability-info'})
        spyOn(avInfo, "_show")
        spyOn(avInfo, "_update")
        spyOn(avInfo, "_unblock")


      describe 'when the user has not entered dates', ->
        beforeEach ->
          spyOn(avInfo, "hasSearched").andReturn(false)
          $(avInfo.config.LISTENER).trigger(':page/received', params)

        it 'does not show the info card', ->
          expect(avInfo._show).not.toHaveBeenCalled()
          expect(avInfo._update).not.toHaveBeenCalled()
          expect(avInfo._unblock).not.toHaveBeenCalled()

      describe 'when the user has entered dates', ->
        beforeEach ->
          spyOn(avInfo, "hasSearched").andReturn(true)
          $(avInfo.config.LISTENER).trigger(':page/received', params)

        it 'shows the info card', ->
          expect(avInfo._show).toHaveBeenCalled()

        it 'updates the info card', ->
          expect(avInfo._update).toHaveBeenCalled()

        it 'unblocks the info card', ->
          expect(avInfo._unblock).toHaveBeenCalled()


    describe 'on change', ->
      beforeEach ->
        loadFixtures('availability_info.html')
        window.avInfo = new AvailabilityInfo({ el: '.js-availability-info'})

      it 'triggers the info/change event', ->
        spyEvent = spyOnEvent(avInfo.$el, ':search/change');
        avInfo.$btn.trigger('click')
        expect(':search/change').toHaveBeenTriggeredOn(avInfo.$el)


    describe 'updating', ->

      describe 'for a single guest', ->
        beforeEach ->
          loadFixtures('availability_info.html')
          window.avInfo = new AvailabilityInfo({ el: '.js-availability-info'})
          avInfo._update(params.search)

        it 'updates the user details', ->
          expect($('.js-availability-from').text()).toBe(params.search.from)
          expect($('.js-availability-to').text()).toBe(params.search.to)
          expect($('.js-availability-guests').text()).toBe(params.search.guests + " guest")
          expect($('.js-availability-currency').hasClass('currency__icon--' + params.search.currency.toLowerCase())).toBe(true)
          expect($('.js-availability-currency').text()).toBe(params.search.currency)

      describe 'for multiple guests', ->
        beforeEach ->
          loadFixtures('availability_info.html')
          window.avInfo = new AvailabilityInfo({ el: '.js-availability-info'})
          params.search.guests++
          avInfo._update(params.search)

        it 'updates the user details', ->
          expect($('.js-availability-guests').text()).toBe(params.search.guests + " guests")
