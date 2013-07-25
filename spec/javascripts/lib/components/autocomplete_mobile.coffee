require ['lib/components/autocomplete_mobile'], (AutoComplete) ->

  describe 'AutoComplete', ->

    SUCCESS =
      results: [
        {
          title: "London"
          uri: "/london"
          type: "place"
        }
        {
          title: "Paris"
          uri: "/paris"
          type: "hotel"
        }
      ]

    describe 'Object', ->
      it 'is defined', ->
        expect(AutoComplete).toBeDefined()

    describe 'whether the search threshold has been reached', ->
      beforeEach ->
        @myAutoComplete = new AutoComplete({selector: 'my_search'})
        spyOn @myAutoComplete, "_searchFor"

      it 'makes a request when enough characters have been entered', ->
        minimumSearch = 'abc'
        @myAutoComplete._change minimumSearch
        expect(@myAutoComplete._searchFor).toHaveBeenCalledWith(minimumSearch)

      it "doesn't make a request when not enough characters have been entered", ->
        @myAutoComplete._change 'ab'
        expect(@myAutoComplete._searchFor).not.toHaveBeenCalled()

    # TODO: test that the XHR calls _updateUI with the results

    describe 'updates the UI when search results are returned', ->
      beforeEach ->
        @myAutoComplete = new AutoComplete({selector: 'my_search'})
        spyOn @myAutoComplete, '_createListItem'

      it 'creates a list item for each result', ->
        @myAutoComplete._updateUI SUCCESS.results
        # expect(@myAutoComplete._createListItem).toHaveBeenCalledWith(SUCCESS.results)
        expect(@myAutoComplete._createListItem.callCount).toBe(2)

      it 'displays nothing when search results are not empty', -> 
        @myAutoComplete._updateUI []
        expect(@myAutoComplete._createListItem.callCount).toBe(0)