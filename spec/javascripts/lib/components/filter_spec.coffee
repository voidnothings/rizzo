require ['public/assets/javascripts/lib/components/filter.js'], (Filter) ->

  describe 'Filter', ->

    data =
      disable_price_filters: true
      external_filter: '5star,4star,3star,2star'

    data_alt =
      disable_price_filters: false

    describe 'Setup', ->
      it 'is defined', ->
        expect(Filter).toBeDefined()

    describe 'Initialisation', ->
      window.test = Filter
      beforeEach ->
        window.filter = new Filter({el: '#js-filters'})

      it 'has an event listener constant', ->
        expect(filter.config.LISTENER).toBeDefined()


    describe 'on page received', ->

      describe 'when passed a flag to disable price filters', ->

        beforeEach ->
          loadFixtures('filter.html')
          window.filter = new Filter({el: '#js-filters'})

        describe 'it calls', ->
          beforeEach ->
            spyOn(filter, "_hideGroup")
            $(filter.config.LISTENER).trigger(':page/received', data)

          it 'the hideGroup function', ->
            expect(filter._hideGroup).toHaveBeenCalledWith("price")

        describe 'side effects', ->
          beforeEach ->
            $(filter.config.LISTENER).trigger(':page/received', data)

          it 'it hides the price filters', ->
            expect(filter.$el.find(".js-price-filter").hasClass('is-hidden')).toBe(true)


      describe 'when there is no flag to disable price filters', ->

        beforeEach ->
          loadFixtures('filter.html')
          window.filter = new Filter({el: '#js-filters-disabled'})

        describe 'it calls', ->
          beforeEach ->
            spyOn(filter, "_showGroup")
            $(filter.config.LISTENER).trigger(':page/received', data_alt)

          it 'the showGroup function', ->
            expect(filter._showGroup).toHaveBeenCalledWith("price")

        describe 'side effects', ->
          beforeEach ->
            $(filter.config.LISTENER).trigger(':page/received', data_alt)

          it 'it shows the price filters', ->
            expect(filter.$el.find(".js-price-filter").hasClass('is-hidden')).toBe(false)

          it 'enables the price filters', ->
            expect(filter.$el.find(".js-#{name}-filter").find('input[type=checkbox][disabled]').length).toBe(0)


      describe 'when the filter has been triggered by an external filter', ->

        beforeEach ->
          loadFixtures('filter.html')
          window.filter = new Filter({el: '#js-filters-external'})

        describe 'it calls', ->
          beforeEach ->
            spyOn(filter, "_set")
            $(filter.config.LISTENER).trigger(':page/received', data)

          it 'the set function with the filter names', ->
            expect(filter._set).toHaveBeenCalledWith(data.external_filter, true)

        describe 'side-effects', ->
          beforeEach ->
            $(filter.config.LISTENER).trigger(':page/received', data)

          it 'checks the correct price filters', ->
            external_filters = data.external_filter.split(",")
            expect(filter.$el.find("input[name*='#{external_filters[0]}']").is(':checked')).toBe(true)
            expect(filter.$el.find("input[name*='#{external_filters[1]}']").is(':checked')).toBe(true)
            expect(filter.$el.find("input[name*='#{external_filters[2]}']").is(':checked')).toBe(true)
            expect(filter.$el.find("input[name*='#{external_filters[3]}']").is(':checked')).toBe(true)


    describe 'on filter reset', ->

      beforeEach ->
        loadFixtures('filter.html')
        window.filter = new Filter({el: '#js-filters-reset'})

      describe 'it calls', ->
        beforeEach ->
          spyOn(filter, "_reset")
          $(filter.config.LISTENER).trigger(':filter/reset', data)

        it 'the reset function', ->
          expect(filter._reset).toHaveBeenCalled()

      describe 'side effects', ->
        beforeEach ->
          $(filter.config.LISTENER).trigger(':filter/reset', data)

        it 'resets the price filters', ->
          expect(filter.$el.find("input").is(':checked')).toBe(false)


    describe 'on filter input change', ->

      beforeEach ->
        loadFixtures('filter.html')
        window.filter = new Filter({el: '#js-filters-change'})

      describe 'calls', ->
        beforeEach ->
          spyOn(filter, "_toggleActiveClass")
          spyOn(filter, "_serialize")
          spyEvent = spyOnEvent(filter.$el, ':page/request');
          element = filter.$el.find('input[type=checkbox]')
          element.trigger('change')
        
        it '_toggleActiveClass', ->
          expect(filter._toggleActiveClass).toHaveBeenCalled()

        it '_serialize', ->
          expect(filter._serialize).toHaveBeenCalled()

        it 'triggers the page request event', ->
          expect(':page/request').toHaveBeenTriggeredOn(filter.$el)

      
      describe 'side effects', ->
        beforeEach ->
          $(filter.$el).find('input[type=checkbox]').trigger('change')

        it 'assigns the sibling lable an active class', ->
          expect(filter.$el.find('input[type=checkbox]').siblings().hasClass('active')).toBe(true)


    describe 'when the user clicks a filter card', ->
      beforeEach ->
        loadFixtures('filter.html')
        window.filter = new Filter({el: '#js-filters'})
        spyOn(filter, "_set")
        spyEvent = spyOnEvent(filter.$el, ':page/request');
        
        

      it 'calls _set with the new filters', ->
        filterCard = $(filter.config.LISTENER).find('.js-stack-card-filter')
        filters = filterCard.find('[data-filter]').data('filter')
        filterCard.trigger('click')
        expect(filter._set).toHaveBeenCalledWith(filters)

      it 'triggers the :page/request event with the correct params', ->
        filterCard = $(filter.config.LISTENER).find('.js-stack-card-filter')
        filterCard.trigger('click')
        expect(':page/request').toHaveBeenTriggeredOn(filter.$el)







