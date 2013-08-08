require ['lib/mobile/autocomplete_mobile'], (AutoComplete) ->

  describe 'AutoComplete', ->

    SEARCH_TERM = 'London'
    TEXT_NODE = 3
    EMPTY_RESULTS = []
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
    MAPPED_RESULTS = [
      {
        name: "London"
        location: "/london"
        category: "place"
      }
      {
        name: "Paris"
        location: "/paris"
        category: "hotel"
      }
    ]
    RESULT_MAP = [
      title: 'name',
      uri: 'location',
      type: 'category'
    ]

    describe 'Object', ->
      it 'is defined', ->
        expect(AutoComplete).toBeDefined()

    describe 'Initialisation', ->
      beforeEach ->
        spyOn AutoComplete.prototype, "init"
        loadFixtures('autocomplete_mobile.html')
        
      it 'should initialise if the element exists', ->
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        expect(@myAutoComplete.$el).toBeDefined()
        expect(AutoComplete.prototype.init).toHaveBeenCalled()

      it 'should not initialise if the input element does not exist', ->
        @myAutoComplete = new AutoComplete({id: 'not_my_search'})
        expect(AutoComplete.prototype.init).not.toHaveBeenCalled()

    describe 'navigating list with keys', ->
      beforeEach ->
        loadFixtures('autocomplete_mobile.html')
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        @myAutoComplete._updateUI SEARCH_RESULTS

      it 'should not highlight any items by default', ->
        expect(@myAutoComplete.currentHighlight).not.toBeDefined()
        expect($('#search_results .autocomplete__active').length).toBe(0)

      it 'should highlight the first item when pressing down arrow', ->
        @myAutoComplete._highlightDown()

        expect(@myAutoComplete.currentHighlight).toBe(0)
        expect($('#search_results .autocomplete__active').length).toBe(1)


      it 'should highlight the last item when pressing up arrow', ->
        @myAutoComplete._highlightUp()

        expect(@myAutoComplete.currentHighlight).toBe(1)
        expect($('#search_results .autocomplete__active').length).toBe(1)

      it 'should not go up beyond the start of the list', ->
        @myAutoComplete._highlightUp()
        @myAutoComplete._highlightUp()
        @myAutoComplete._highlightUp()

        expect(@myAutoComplete.currentHighlight).toBe(0)
        expect($('#search_results .autocomplete__active').length).toBe(1)

      it 'should not go down beyond the end of the list', ->
        @myAutoComplete._highlightDown()
        @myAutoComplete._highlightDown()
        @myAutoComplete._highlightDown()

        expect(@myAutoComplete.currentHighlight).toBe(1)
        expect($('#search_results .autocomplete__active').length).toBe(1)

      it 'should select enter the text of the currently selected item in the input element', ->
        @myAutoComplete._highlightDown() # select first item
        @myAutoComplete._selectHighlighted()

        expect(@myAutoComplete.$el.value).toBe('London')
        expect($('#search_results ul').length).toBe(0)

    describe 'updating the UI when text has been entered in the search field', ->
      beforeEach ->
        loadFixtures('autocomplete_mobile.html')
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        spyOn @myAutoComplete, "_doRequest"
        spyOn @myAutoComplete, "_removeResults"

      describe 'when enough characters have been entered to search for', ->
        it 'makes a request when the list is clean', ->
          minimumSearch = 'abc'

          @myAutoComplete.showingList = false
          @myAutoComplete._searchFor minimumSearch
          expect(@myAutoComplete._doRequest).toHaveBeenCalledWith(minimumSearch)

        it 'makes a request when the list is populated', ->
          minimumSearch = 'abc'

          @myAutoComplete.showingList = true
          @myAutoComplete._searchFor minimumSearch
          expect(@myAutoComplete._doRequest).toHaveBeenCalledWith(minimumSearch)

      describe 'when not enough characters have been entered to search for', ->
        it 'does not make a request when the list is empty', ->
          @myAutoComplete.showingList = false

          @myAutoComplete._searchFor 'ab'
          expect(@myAutoComplete.el).not.toHaveClass('results-displayed')
          expect(@myAutoComplete._doRequest).not.toHaveBeenCalled()
          expect(@myAutoComplete._removeResults).not.toHaveBeenCalled()

        it 'clears the current list when the list is populated', ->
          @myAutoComplete.showingList = true

          @myAutoComplete._searchFor 'ab'
          expect(@myAutoComplete.el).not.toHaveClass('results-displayed')
          expect(@myAutoComplete._doRequest).not.toHaveBeenCalled()
          expect(@myAutoComplete._removeResults).toHaveBeenCalled()

      describe 'search throttling', ->
        it 'makes a request when not throttled', ->
          expect(@myAutoComplete.throttled).toBe(false)
          @myAutoComplete._searchFor 'abc'

          expect(@myAutoComplete._doRequest).toHaveBeenCalled()

        it 'does not make a request when throttled', ->
          @myAutoComplete.throttled = true
          @myAutoComplete._searchFor 'abc'

          expect(@myAutoComplete._doRequest).not.toHaveBeenCalled()


    describe 'generating the search URI', ->
      beforeEach ->
        @testUri = '/testSearch/'
        @testScope = 'testScope'
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        @myAutoComplete.searchTerm = 'abcdefg'

      it 'should return a URI that begins with the specified URI', ->
        myUri = @myAutoComplete._generateURI @testUri

        expect(myUri).toBe(@testUri+@myAutoComplete.searchTerm)

      it 'should return a URI that begins with the specified scope', ->
        myUri = @myAutoComplete._generateURI @testUri, @testScope

        expect(myUri).toBe(@testUri+@myAutoComplete.searchTerm+'?scope='+@testScope)

    describe 'removing search results from the page', ->
      beforeEach ->
        loadFixtures('autocomplete_mobile.html')
        @myAutoComplete = new AutoComplete({id: 'my_search'})

      it 'should remove the search results list from the page', ->
        @myAutoComplete._updateUI SEARCH_RESULTS
        @myAutoComplete._removeResults()

        expect($('#search_results ul').length).toBe(0)
        expect(@myAutoComplete.showingList).toBe(false)

      it 'should remove the search showing class from the body', ->
        @myAutoComplete._updateUI SEARCH_RESULTS
        @myAutoComplete._removeResults()

        expect($('body')).not.toHaveClass('hero-search-results-displayed')

    describe 'updating the UI when search results are returned', ->
      beforeEach ->
        loadFixtures('autocomplete_mobile.html')
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        @myAutoComplete._updateUI SEARCH_RESULTS

      it 'should add a class to the document body when search results are displayed', ->
        expect(@myAutoComplete.showingList).toBe(true)
        expect(@myAutoComplete.currentHighlighted).not.toBeDefined()
        expect($('body')).toHaveClass('hero-search-results-displayed')

      it 'should add a list of highlighted search results to the page', ->
        expect(@myAutoComplete.showingList).toBe(true)
        expect(@myAutoComplete.currentHighlighted).not.toBeDefined()
        expect($('#search_results ul li').length).toBe(2)

      it 'should replace the existing search results when called a second time', ->
        @myAutoComplete._updateUI [SEARCH_RESULTS[1]]

        expect(@myAutoComplete.currentHighlighted).not.toBeDefined()
        expect($('#search_results ul li').length).toBe(1)

      describe 'creating a list of items to be added to the UI', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({id: 'my_search'})
          @myAutoComplete.searchTerm = SEARCH_TERM

        it 'should create an unordered list with an item for each result', ->
          list = @myAutoComplete._createList SEARCH_RESULTS

          expect(list.tagName).toBe('UL')
          expect(list.className).toBe('autocomplete__results')
          expect(list.childNodes.length).toBe(2)

        it 'should create an unordered list with a specified number of search results', ->
          @myAutoComplete.args.results = 1
          list = @myAutoComplete._createList SEARCH_RESULTS

          expect(list.tagName).toBe('UL')
          expect(list.className).toBe('autocomplete__results')
          expect(list.childNodes.length).toBe(1)

        it 'should create an unordered list no items when the results list is empty', -> 
          list = @myAutoComplete._createList EMPTY_RESULTS
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

        it 'should create an anchor item with all item details', ->
          listItem = @myAutoComplete._createAnchor SEARCH_RESULTS[0]
          $listItem = $(listItem)

          expect(listItem.tagName).toBe('A')
          expect(listItem.getAttribute('href')).toEqual(SEARCH_RESULTS[0].uri)
          expect(listItem.childNodes.length).toBe(1)
          expect(listItem.textContent).toBe(SEARCH_RESULTS[0].title)
          expect($listItem).toHaveClass("autocomplete__result")
          expect($listItem).toHaveClass("autocomplete__result__type")
          expect($listItem).toHaveClass("autocomplete__result__type--#{SEARCH_RESULTS[0].type}")

        it 'should create an anchor item without href if not specified', ->
          delete @myAutoComplete.responseMap.uri

          listItem = @myAutoComplete._createAnchor SEARCH_RESULTS[0]
          $listItem = $(listItem)

          expect(listItem.tagName).toBe('A')
          expect(listItem.getAttribute('href')).toEqual('#')
          expect(listItem.childNodes.length).toBe(1)
          expect(listItem.textContent).toBe(SEARCH_RESULTS[0].title)
          expect($listItem).toHaveClass("autocomplete__result")
          expect($listItem).toHaveClass("autocomplete__result__type")
          expect($listItem).toHaveClass("autocomplete__result__type--#{SEARCH_RESULTS[0].type}")

        it 'should create an anchor item without result type classes if not specified', ->
          delete @myAutoComplete.responseMap.type

          listItem = @myAutoComplete._createAnchor SEARCH_RESULTS[0]
          $listItem = $(listItem)

          expect(listItem.tagName).toBe('A')
          expect(listItem.getAttribute('href')).toEqual('#')
          expect(listItem.childNodes.length).toBe(1)
          expect(listItem.textContent).toBe(SEARCH_RESULTS[0].title)
          expect($listItem).toHaveClass("autocomplete__result")
          expect($listItem).not.toHaveClass("autocomplete__result__type")

      describe 'highlighting the search term', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({id: 'my_search'})

        it 'should highlight the search text at the start of a title', ->
          testSearchTerm = 'Lond'

          highlightedText = @myAutoComplete._highlightText SEARCH_RESULTS[0].title, testSearchTerm
          expect(highlightedText).toBe('<b>Lond</b>on')

        it 'should highlight the search text at the end of a title', ->
          testSearchTerm = 'don'

          highlightedText = @myAutoComplete._highlightText SEARCH_RESULTS[0].title, testSearchTerm
          expect(highlightedText).toBe('Lon<b>don</b>')

        it 'should highlight the search text in the middle of a title', ->
          testSearchTerm = 'ond'

          highlightedText = @myAutoComplete._highlightText SEARCH_RESULTS[0].title, testSearchTerm
          expect(highlightedText).toBe('L<b>ond</b>on')

        it 'should highlight the search text if it exactly matches a title', ->
          testSearchTerm = 'London'

          highlightedText = @myAutoComplete._highlightText SEARCH_RESULTS[0].title, testSearchTerm
          expect(highlightedText).toBe('<b>London</b>')

        it 'should not highlight anything if the search text is not found', ->
          testSearchTerm = 'London'

          highlightedText = @myAutoComplete._highlightText SEARCH_RESULTS[1].title, testSearchTerm
          expect(highlightedText).toBe('Paris')
