require ['public/assets/javascripts/lib/components/load_more.js'], (LoadMore) ->



  describe 'Load More Button', ->
    
    fixture = readFixtures('load_more.html')
    fixture = $(fixture)
    
    describe 'Setup', ->
      it 'is defined', ->
        expect(LoadMore).toBeDefined()

      it 'has default options', ->
        expect(LoadMore::config).toBeDefined()


    describe 'Remove pagination and append load more button', ->


      $('body').append(fixture)

      it 'has pagination without js', ->
        expect($('.test-footer')).toExist()

      it 'extends the object', ->
        loadMore = new LoadMore({pagination: '.test-footer', targetContainer: '.test-area'})
        expect(LoadMore::config.pagination) == '.test-footer'

      it 'removes the pagination', ->
        expect($('.test-footer')) == []

      it 'appends the load more button', ->
        expect($('#js-load-more')).toExist()


    describe 'Loading more hotels', ->

      it 'has text of loading...', ->
        $('#js-load-more').trigger('click')
        expect($('#js-load-more')).toHaveText('Loading...')

      xit 'appends the sample hotels data', ->
        fixture.remove()
        $('body').append(fixture)
        
        $('body').on 'receivedHotels/success', ->
          expect($('.test-area')).toHaveHtml('<span>Returned hotels data</span>')
        $('#js-load-more').trigger('click')
      
      it 'gets the correct next page url', ->
        expect(LoadMore::config.nextUrl) == 'page3'

      it 'shows a message when the ajax call fails', ->
        $('body').trigger('receivedHotels/error')
        expect($('.error--system')).toExist()
        $('.test-area').remove()
    
