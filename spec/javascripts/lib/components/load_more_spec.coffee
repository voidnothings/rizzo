require ['public/assets/javascripts/lib/components/load_more.js'], (LoadMore) ->

  describe 'Load More Button', ->
    
    describe 'Setup', ->
      it 'is defined', ->
        expect(LoadMore).toBeDefined()
