require ['lib/components/autocomplete_mobile'], (AutoComplete) ->

  describe 'AutoComplete', ->

    SEARCH_RESULTS =
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

    EMPTY_RESULTS =
      results: []

    SEARCH_TERM = 'London'

    describe 'Object', ->
      it 'is defined', ->
        expect(AutoComplete).toBeDefined()

    describe 'Initialisation', ->
      it 'the input element exists', ->
        spyOn AutoComplete.prototype, "init"
        loadFixtures('autocomplete_mobile.html')

        @myAutoComplete = new AutoComplete({id: 'my_search'})
        expect(AutoComplete.prototype.init).toHaveBeenCalled()
        expect(@myAutoComplete.el).not.toBeNull()

    describe 'whether the search threshold has been reached', ->
      beforeEach ->
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        spyOn @myAutoComplete, "_searchFor"

      it 'makes a request when enough characters have been entered', ->
        minimumSearch = 'abc'
        @myAutoComplete._change minimumSearch
        expect(@myAutoComplete._searchFor).toHaveBeenCalledWith(minimumSearch)

      it "doesn't make a request when not enough characters have been entered", ->
        @myAutoComplete._change 'ab'
        expect(@myAutoComplete._searchFor).not.toHaveBeenCalled()

    describe 'updating the UI when search results are returned', ->

      it 'should add a list of highlighted search results to the page', ->
        loadFixtures('autocomplete_mobile.html')
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        @myAutoComplete.searchString = SEARCH_TERM

        @myAutoComplete._updateUI SEARCH_RESULTS

        expect($('#search_results ul').length).toBe(1)
        expect($('#search_results ul li').length).toBe(2)

      it 'should replace the existing search results when called a second time', ->
        loadFixtures('autocomplete_mobile.html')
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        @myAutoComplete.searchString = SEARCH_TERM

        @myAutoComplete._updateUI SEARCH_RESULTS
        @myAutoComplete._updateUI EMPTY_RESULTS

        expect($('#search_results ul').length).toBe(1)
        expect($('#search_results ul li').length).toBe(0)

      describe 'creating a list of items to be added to the UI', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({id: 'my_search'})
          @myAutoComplete.searchString = SEARCH_TERM
        
        it 'should create an unordered list with an item for each result', ->
          list = @myAutoComplete._createList SEARCH_RESULTS.results

          expect(list.tagName).toBe('UL')
          expect(list.getAttribute('id')).toBe('autocomplete__results')
          expect(list.childNodes.length).toBe(2)

        it 'should create an unordered list no items when the results list is empty', -> 
          list = @myAutoComplete._createList []
          expect(list.childNodes.length).toBe(0)

      describe 'creating a list item', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({id: 'my_search'})
          @myAutoComplete.searchString = SEARCH_TERM

        it 'should create a list item with an anchor as its only child', ->
          listItem = @myAutoComplete._createListItem SEARCH_RESULTS.results[0]

          expect(listItem.tagName).toBe('LI')
          expect(listItem.childNodes.length).toBe(1)
          expect(listItem.childNodes[0].tagName).toBe('A')

      describe 'creating an anchor item', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({id: 'my_search'})
          @myAutoComplete.searchString = SEARCH_TERM

        it 'should create an anchor item with the item details', ->
          listItem = @myAutoComplete._createAnchor SEARCH_RESULTS.results[0]

          expect(listItem.tagName).toBe('A')
          expect(listItem.getAttribute('href')).toEqual(SEARCH_RESULTS.results[0].uri)
          expect(listItem.getAttribute('class')).toBe("autocomplete__result--#{SEARCH_RESULTS.results[0].type}")
          expect(listItem.childNodes.length).toBe(1)
          expect(listItem.textContent).toBe(SEARCH_RESULTS.results[0].title)

      describe 'highlighting the search term', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({id: 'my_search'})

        it 'should wrap a span around the search term with the specified class name', ->
          title = @myAutoComplete._createAnchorText SEARCH_TERM, SEARCH_TERM
          titleSpan = title.childNodes[0]

          expect(titleSpan).toBe('SPAN')
          expect(titleSpan.getAttribute('class')).toBe('autocomplete__result--highlight')
          expect(title.firstChild.textContent).toBe(SEARCH_TERM)

        it 'should highlight the search text at the start of a title', ->
          title = @myAutoComplete._createAnchorText SEARCH_TERM, 'London Central'

          expect(title.childNodes.length).toBe(2)
          expect(title.firstChild.tagName).toBe('SPAN')
          expect(title.firstChild.textContent).toBe(SEARCH_TERM)
          expect(title.lastChild.nodeType).toBe(3)
          expect(title.lastChild.textContent).toBe(' Central')

        it 'should highlight the search text at the end of a title', ->
          title = @myAutoComplete._createAnchorText SEARCH_TERM, 'Central London'

          expect(title.childNodes.length).toBe(2)
          expect(title.firstChild.nodeType).toBe(3)
          expect(title.firstChild.textContent).toBe('Central ')
          expect(title.lastChild.tagName).toBe('SPAN')
          expect(title.lastChild.textContent).toBe(SEARCH_TERM)

        it 'should highlight the search text in the middle of a title', ->
          title = @myAutoComplete._createAnchorText SEARCH_TERM, 'Central London, Somewhere'

          expect(title.childNodes.length).toBe(3)
          expect(title.childNodes[0].nodeType).toBe(3)
          expect(title.childNodes[0].textContent).toBe('Central ')
          expect(title.childNodes[1].tagName).toBe('SPAN')
          expect(title.childNodes[1].textContent).toBe(SEARCH_TERM)
          expect(title.childNodes[2].nodeType).toBe(3)
          expect(title.childNodes[2].textContent).toBe(', Somewhere')

        it 'should highlight the search text if it exactly matches a title', ->
          title = @myAutoComplete._createAnchorText SEARCH_TERM, SEARCH_TERM

          expect(title.childNodes.length).toBe(1)
          expect(title.childNodes[0].tagName).toBe('SPAN')
          expect(title.childNodes[0].textContent).toBe(SEARCH_TERM)

        it 'should not highlight anything if the search text is not found', ->
          title = @myAutoComplete._createAnchorText 'Nowhere', 'London Central'

          expect(title.childNodes.length).toBe(1)
          expect(title.childNodes[0].nodeType).toBe(3)
          expect(title.childNodes[0].textContent).toBe('London Central')
