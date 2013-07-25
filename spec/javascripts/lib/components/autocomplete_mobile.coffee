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

    describe 'updating the UI when search results are returned', ->

      describe 'creating a list item for each result item', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({selector: 'my_search'})
        
        it 'should create a list item for each result', ->
          spyOn @myAutoComplete, '_createListItem'
          @myAutoComplete._updateUI SUCCESS.results
          expect(@myAutoComplete._createListItem.callCount).toBe(2)

        it 'should create no list items when search results are empty', -> 
          spyOn @myAutoComplete, '_createListItem'
          @myAutoComplete._updateUI []
          expect(@myAutoComplete._createListItem.callCount).toBe(0)

        it 'should create a list item with an anchor as its only child', ->
          spyOn(@myAutoComplete, "_createAnchor").andCallThrough()
          listItem = @myAutoComplete._createListItem SEARCH_TERM, SUCCESS.results[0]

          expect(@myAutoComplete._createAnchor).toHaveBeenCalledWith(SEARCH_TERM, SUCCESS.results[0])
          expect(@myAutoComplete._createAnchor.callCount).toBe(1)
          expect(listItem.tagName).toBe('LI')
          expect(listItem.childNodes.length).toBe(1)

      describe 'creating an anchor item', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({selector: 'my_search'})

        it 'should create an anchor item', ->
          spyOn(@myAutoComplete, "_createAnchorText").andCallThrough()
          @myAutoComplete._createAnchor SEARCH_TERM, SUCCESS.results[0]

          expect(@myAutoComplete._createAnchorText).toHaveBeenCalledWith(SEARCH_TERM, SUCCESS.results[0].title)

        it 'should create an anchor item with the item details', ->
          listItem = @myAutoComplete._createAnchor SEARCH_TERM, SUCCESS.results[0]

          expect(listItem.tagName).toBe('A')
          expect(listItem.getAttribute('href')).toEqual (SUCCESS.results[0].uri)
          expect(listItem.getAttribute('class')).toBe("item__result--#{SUCCESS.results[0].type}")
          expect(listItem.childNodes.length).toBe(1)
          expect(listItem.textContent).toBe(SUCCESS.results[0].title)

      describe 'highlighting the search term', ->
        beforeEach ->
          @myAutoComplete = new AutoComplete({selector: 'my_search'})

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
