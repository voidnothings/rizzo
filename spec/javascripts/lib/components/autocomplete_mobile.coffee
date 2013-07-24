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
          type: "place"
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

    describe 'when search results are returned', ->
      beforeEach ->
        @myAutoComplete = new AutoComplete({selector: 'my_search'})
        @myAutoComplete._updateUI SUCCESS.results

      it 'updates the UI with results when search results are not empty'

      it 'displays nothing when search results are not empty'
