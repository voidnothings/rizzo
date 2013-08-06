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
        
      it 'should initialise if the autocomplete elements exist', ->
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        expect(@myAutoComplete.el).toBeDefined()
        expect(@myAutoComplete.inputElt).toBeDefined()
        expect(AutoComplete.prototype.init).toHaveBeenCalled()

      it 'should not initialise if the input element does not exist', ->
        @myAutoComplete = new AutoComplete({id: 'not_my_search'})
        expect(AutoComplete.prototype.init).not.toHaveBeenCalled()
        expect(@myAutoComplete.el).toBeNull()

    describe 'event handlers', ->
      beforeEach ->
        loadFixtures('autocomplete_mobile.html')
        spyOn AutoComplete.prototype, '_addListHandler'

      it 'should add an event handler for clicking on a list item by default', ->
        @myAutoComplete = new AutoComplete({id: 'my_search'})

        expect(AutoComplete.prototype._addListHandler).toHaveBeenCalled()

      it 'should not add an event handler for clicking on a list item if specified listOnly', ->
        @myAutoComplete = new AutoComplete({id: 'my_search', listOnly: true})

        expect(AutoComplete.prototype._addListHandler).not.toHaveBeenCalled()

    describe 'selecting a list item', ->
      beforeEach ->
        loadFixtures('autocomplete_mobile.html')
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        spyOn @myAutoComplete, '_emptyList'

      it 'copies the text value to the input field and empties the list', ->
        @myAutoComplete._enterTargetValue 'Example text'
        expect(@myAutoComplete.inputElt.value).toBe('Example text')
        expect(@myAutoComplete._emptyList).toHaveBeenCalled()


    describe 'updating the UI when text has been entered in the search field', ->
      beforeEach ->
        loadFixtures('autocomplete_mobile.html')
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        spyOn @myAutoComplete, "_doRequest"
        spyOn @myAutoComplete, "_updateUI"

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
          expect(@myAutoComplete._updateUI).not.toHaveBeenCalled()
          expect(@myAutoComplete.showingList).toBe(false)

        it 'clears the current list when the list is populated', ->
          @myAutoComplete.showingList = true

          @myAutoComplete._searchFor 'ab'
          expect(@myAutoComplete.el).not.toHaveClass('results-displayed')
          expect(@myAutoComplete._doRequest).not.toHaveBeenCalled()
          expect(@myAutoComplete._updateUI).toHaveBeenCalledWith(EMPTY_RESULTS)
          expect(@myAutoComplete.showingList).toBe(false)

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

    describe 'updating the UI when search results are returned', ->
      beforeEach ->
        loadFixtures('autocomplete_mobile.html')
        @myAutoComplete = new AutoComplete({id: 'my_search'})
        @myAutoComplete._updateUI SEARCH_RESULTS

      it 'should add a list of highlighted search results to the page', ->
        expect(@myAutoComplete.showingList).toBe(true)
        expect(@myAutoComplete.el).toHaveClass('results-displayed')
        expect($('#my_search ul li').length).toBe(2)

      it 'should replace the existing search results when called a second time', ->
        @myAutoComplete._updateUI EMPTY_RESULTS

        expect($('#my_search ul li').length).toBe(0)

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

        it 'should create an anchor item with the item details', ->
          listItem = @myAutoComplete._createAnchor SEARCH_RESULTS[0]
          $listItem = $(listItem)

          expect(listItem.tagName).toBe('A')
          expect(listItem.getAttribute('href')).toEqual(SEARCH_RESULTS[0].uri)
          expect(listItem.childNodes.length).toBe(1)
          expect(listItem.textContent).toBe(SEARCH_RESULTS[0].title)
          expect($listItem).toHaveClass("autocomplete__result")
          expect($listItem).toHaveClass("icon-list--#{SEARCH_RESULTS[0].type}")

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

          expect(anchorRemainder.nodeType).toBe(TEXT_NODE)
          expect(anchorRemainder.textContent).toBe('on')

        it 'should highlight the search text at the end of a title', ->
          testSearchTerm = 'don'

          @myAutoComplete.searchTerm = testSearchTerm
          anchor = @myAutoComplete._createAnchor SEARCH_RESULTS[0]
          anchorRemainder = anchor.childNodes[0]
          anchorTerm = anchor.childNodes[1]

          expect(anchorRemainder.nodeType).toBe(TEXT_NODE)
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

          expect(anchorRemainderStart.nodeType).toBe(TEXT_NODE)
          expect(anchorRemainderStart.textContent).toBe('L')

          expect(anchorTerm.tagName).toBe('SPAN')
          expect(anchorTerm.getAttribute('class')).toBe('autocomplete__result--highlight')
          expect(anchorTerm.textContent).toBe(testSearchTerm)

          expect(anchorRemainderEnd.nodeType).toBe(TEXT_NODE)
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

          expect(anchorText.nodeType).toBe(TEXT_NODE)
          expect(anchorText.textContent).toBe('Paris')
