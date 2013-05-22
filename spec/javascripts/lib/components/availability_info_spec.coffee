require ['public/assets/javascripts/lib/components/availability_info.js'], (AvailabilityInfo) ->

  describe 'AvailabilityInfo', ->
    
    describe 'Setup', ->
      it 'is defined', ->
        expect(AvailabilityInfo).toBeDefined()


    describe 'Initialisation', ->
      beforeEach ->
        window.avInfo = new AvailabilityInfo({ el: '.js-availability-info'})

      it 'has an event listener constant', ->
        expect(av.config.LISTENER).toBeDefined()


    describe 'on page request', ->
      beforeEach ->
        window.avInfo = new AvailabilityInfo({ el: '.js-availability-info'})
        spyOn(avInfo, "_block")
        $(avInfo.config.LISTENER).trigger(':page/request')

      it 'disables the availability form', ->
        expect(avInfo._block).toHaveBeenCalled()


    describe 'on page received', ->
      beforeEach ->
        window.avInfo = new AvailabilityInfo({ el: '.js-availability-info'})
        spyOn(avInfo, "_show")
        spyOn(avInfo, "_update")
        spyOn(avInfo, "_unblock")

      describe 'when the user has not entered dates', ->
        beforeEach ->
          spyOn(avInfo, "hasSearched").andReturn(false)

        it 'does not show the info card', ->
          expect(avInfo._show).not.toHaveBeenCalled()
          expect(avInfo._update).not.toHaveBeenCalled()
          expect(avInfo._unblock).not.toHaveBeenCalled()

      describe 'when the user has entered dates', ->
        beforeEach ->
          spyOn(avInfo, "hasSearched").andReturn(true)

        it 'shows the info card', ->
          expect(avInfo._show).toHaveBeenCalled()

        it 'updates the info card', ->
          expect(avInfo._update).toHaveBeenCalled()

        it 'unblocks the info card', ->
          expect(avInfo._unblock).toHaveBeenCalled()


    describe 'on change', ->
      beforeEach ->
        window.avInfo = new AvailabilityInfo({ el: '.js-availability-info'})

      it 'triggers the info/change event', ->
        spyEvent = spyOnEvent(avInfo.$el, ':info/change');
        avInfo.$btn.trigger('click')
        expect(':info/change').toHaveBeenTriggeredOn(avInfo.$el)


    describe 'updating', ->
      params =
        from: "21 May 2013"
        to: "23 May 2013"
        guests: 1 
        currency: "USD"

      describe 'for a single guest', ->
        beforeEach ->
          loadFixtures('availability_info.html')
          window.avInfo = new AvailabilityInfo({ el: '.js-availability-info'})
          avInfo._update(params)

        it 'updates the user details', ->
          expect($('.js-availability-from').text()).toBe(params.from)
          expect($('.js-availability-to').text()).toBe(params.to)
          expect($('.js-availability-guests').text()).toBe(params.guests + " guest")
          expect($('.js-availability-currency').hasClass('currency__icon--' + params.currency.toLowerCase())).toBe(true)
          expect($('.js-availability-currency').text()).toBe(params.currency)

      describe 'for multiple guests', ->
        beforeEach ->
          loadFixtures('availability_info.html')
          window.avInfo = new AvailabilityInfo({ el: '.js-availability-info'})
          params.guests++
          avInfo._update(params)

        it 'updates the user details', ->
          expect($('.js-availability-guests').text()).toBe(params.guests + " guestsc")
