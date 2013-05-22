require ['public/assets/javascripts/lib/components/load_more.js'], (LoadMore) ->

  describe 'Load More Button', ->
    
    describe 'Setup', ->
      it 'is defined', ->
        expect(LoadMore).toBeDefined()

      it 'has default options', ->
        expect(LoadMore::config).toBeDefined()


    describe 'Remove pagination', ->
      beforeEach ->
        loadFixtures('load_more.html')

      it 'has pagination without js', ->
        expect($('.js-pagination')).toExist()

      describe 'Append load more button', ->
        beforeEach ->
          window.lm = new LoadMore({el: '.js-pagination'})

        it 'removes the pagination', ->
          expect($('.js-pagination').children().length).toBe(1)

        it 'appends the load more button', ->
          expect($('#js-load-more')).toExist()


    describe 'on page request', ->
      beforeEach ->
        loadFixtures('load_more.html')
        window.lm = new LoadMore({el: '.js-pagination'})
        spyOn(lm, "_reset")
        spyOn(lm, "_block")
        $(lm.config.LISTENER).trigger(':page/request')

      it 'resets the pagination', ->
        expect(lm._reset).toHaveBeenCalled()

      it 'disables the pagination', ->
        expect(lm._block).toHaveBeenCalled()


    describe 'on page received', ->
      beforeEach ->
        loadFixtures('load_more.html')
        window.lm = new LoadMore({el: '.js-pagination'})
        spyOn(lm, "_unblock")
        $(lm.config.LISTENER).trigger(':page/received')

      it 'enables the pagination', ->
        expect(lm._unblock).toHaveBeenCalled()


    describe 'on page/append/received', ->
      beforeEach ->
        loadFixtures('load_more.html')
        window.lm = new LoadMore({el: '.js-pagination'})
        spyOn(lm, "_unblock")
        $(lm.config.LISTENER).trigger(':page/append/received')

      it 'enables the pagination', ->
        expect(lm._unblock).toHaveBeenCalled()


    describe 'on click', ->
      beforeEach ->
        loadFixtures('load_more.html')
        window.lm = new LoadMore({el: '.js-pagination'})
        spyEvent = spyOnEvent(lm.$el, ':page/append');
        spyOn(lm, "_block")
        lm.$btn.trigger('click')

      it 'triggers the page/append event', ->
        expect(':page/append').toHaveBeenTriggeredOn(lm.$el)

      it 'disables the pagination', ->
        expect(lm._block).toHaveBeenCalled()
