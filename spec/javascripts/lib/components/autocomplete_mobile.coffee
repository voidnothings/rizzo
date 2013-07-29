require ['lib/components/autocomplete_mobile'], (AutoComplete) ->

  describe 'AutoComplete', ->

    SEARCH_RESULTS = [
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

    EMPTY_RESULTS = []

    SEARCH_TERM = 'London'

    describe 'Object', ->
      it 'is defined', ->
        expect(AutoComplete).toBeDefined()

    describe 'Initialisation', ->
      it 'should initialise if the input element exists', ->
        spyOn AutoComplete.prototype, "init"
        loadFixtures('autocomplete_mobile.html')

        @myAutoComplete = new AutoComplete({id: 'my_search'})
        expect(AutoComplete.prototype.init).toHaveBeenCalled()
        expect(@myAutoComplete.el).not.toBeNull()

      it 'should not initialise if the input element does not to exist', ->
        spyOn AutoComplete.prototype, "init"
        loadFixtures('autocomplete_mobile.html')

        @myAutoComplete = new AutoComplete({id: 'not_my_search'})
        expect(AutoComplete.prototype.init).not.toHaveBeenCalled()
        expect(@myAutoComplete.el).toBeNull()

    describe 'whether the search threshold has been reached', ->
      beforeEach ->
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        spyOn @myAutoComplete, "_doRequest"

      it 'makes a request when enough characters have been entered', ->
        minimumSearch = 'abc'
        @myAutoComplete._searchFor minimumSearch
        expect(@myAutoComplete._doRequest).toHaveBeenCalledWith(minimumSearch)

      it "doesn't make a request when not enough characters have been entered", ->
        @myAutoComplete._searchFor 'ab'
        expect(@myAutoComplete._doRequest).not.toHaveBeenCalled()

    describe 'updating the UI when search results are returned', ->
      it 'should add a list of highlighted search results to the page', ->
        loadFixtures('autocomplete_mobile.html')
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        @myAutoComplete.searchTerm = SEARCH_TERM

        @myAutoComplete._updateUI SEARCH_RESULTS

        expect($('#search_results ul').length).toBe(1)
        expect($('#search_results ul li').length).toBe(2)

      it 'should replace the existing search results when called a second time', ->
        loadFixtures('autocomplete_mobile.html')
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        @myAutoComplete.searchTerm = SEARCH_TERM

        @myAutoComplete._updateUI SEARCH_RESULTS
        @myAutoComplete._updateUI EMPTY_RESULTS

        expect($('#search_results ul').length).toBe(1)
        expect($('#search_results ul li').length).toBe(0)

      describe 'creating a list of items to be added to the UI', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({id: 'my_search'})
          @myAutoComplete.searchTerm = SEARCH_TERM
        
        it 'should create an unordered list with an item for each result', ->
          list = @myAutoComplete._createList SEARCH_RESULTS

          expect(list.tagName).toBe('UL')
          expect(list.getAttribute('id')).toBe('autocomplete__results')
          expect(list.childNodes.length).toBe(2)

        it 'should create an unordered list no items when the results list is empty', -> 
          list = @myAutoComplete._createList []
          expect(list.childNodes.length).toBe(0)

      describe 'creating a list item', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({id: 'my_search'})
          @myAutoComplete.searchTerm = SEARCH_TERM

        it 'should create a list item with an anchor as its only child', ->
          listItem = @myAutoComplete._createListItem SEARCH_RESULTS[0]

          expect(listItem.tagName).toBe('LI')
          expect(listItem.childNodes.length).toBe(1)
          expect(listItem.childNodes[0].tagName).toBe('A')

      describe 'creating an anchor item', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({id: 'my_search'})
          @myAutoComplete.searchTerm = SEARCH_TERM

        it 'should create an anchor item with the item details', ->
          listItem = @myAutoComplete._createAnchor SEARCH_RESULTS[0]

          expect(listItem.tagName).toBe('A')
          expect(listItem.getAttribute('href')).toEqual(SEARCH_RESULTS[0].uri)
          expect(listItem.getAttribute('class')).toBe("autocomplete__result--#{SEARCH_RESULTS[0].type}")
          expect(listItem.childNodes.length).toBe(1)
          expect(listItem.textContent).toBe(SEARCH_RESULTS[0].title)

      describe 'highlighting the search term', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({id: 'my_search'})

        it 'should highlight the search text at the start of a title', ->
          testSearchTerm = 'Lond'

          @myAutoComplete.searchTerm = testSearchTerm
          anchor = @myAutoComplete._createAnchor SEARCH_RESULTS[0]
          anchorTerm = anchor.childNodes[0]
          anchorRemainder = anchor.childNodes[1]

          expect(anchorTerm.tagName).toBe('SPAN')
          expect(anchorTerm.getAttribute('class')).toBe('autocomplete__result--highlight')
          expect(anchorTerm.textContent).toBe(testSearchTerm)

          expect(anchorRemainder.nodeType).toBe(3)
          expect(anchorRemainder.textContent).toBe('on')

        it 'should highlight the search text at the end of a title', ->
          testSearchTerm = 'don'

          @myAutoComplete.searchTerm = testSearchTerm
          anchor = @myAutoComplete._createAnchor SEARCH_RESULTS[0]
          anchorRemainder = anchor.childNodes[0]
          anchorTerm = anchor.childNodes[1]

          expect(anchorRemainder.nodeType).toBe(3)
          expect(anchorRemainder.textContent).toBe('Lon')

          expect(anchorTerm.tagName).toBe('SPAN')
          expect(anchorTerm.getAttribute('class')).toBe('autocomplete__result--highlight')
          expect(anchorTerm.textContent).toBe(testSearchTerm)


        it 'should highlight the search text in the middle of a title', ->
          testSearchTerm = 'ond'

          @myAutoComplete.searchTerm = testSearchTerm
          anchor = @myAutoComplete._createAnchor SEARCH_RESULTS[0]
          anchorRemainderStart = anchor.childNodes[0]
          anchorTerm = anchor.childNodes[1]
          anchorRemainderEnd = anchor.childNodes[2]

          expect(anchorRemainderStart.nodeType).toBe(3)
          expect(anchorRemainderStart.textContent).toBe('L')

          expect(anchorTerm.tagName).toBe('SPAN')
          expect(anchorTerm.getAttribute('class')).toBe('autocomplete__result--highlight')
          expect(anchorTerm.textContent).toBe(testSearchTerm)

          expect(anchorRemainderEnd.nodeType).toBe(3)
          expect(anchorRemainderEnd.textContent).toBe('on')

        it 'should highlight the search text if it exactly matches a title', ->
          @myAutoComplete.searchTerm = SEARCH_TERM
          anchor = @myAutoComplete._createAnchor SEARCH_RESULTS[0]
          anchorTerm = anchor.childNodes[0]

          expect(anchorTerm.tagName).toBe('SPAN')
          expect(anchorTerm.getAttribute('class')).toBe('autocomplete__result--highlight')
          expect(anchorTerm.textContent).toBe(SEARCH_TERM)

        it 'should not highlight anything if the search text is not found', ->
          @myAutoComplete.searchTerm = SEARCH_TERM
          anchor = @myAutoComplete._createAnchor SEARCH_RESULTS[1]
          anchorText = anchor.childNodes[0]

          expect(anchorText.nodeType).toBe(3)
          expect(anchorText.textContent).toBe('Paris')
