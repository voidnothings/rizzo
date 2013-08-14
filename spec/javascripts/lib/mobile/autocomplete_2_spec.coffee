require ['lib/mobile/autocomplete_2'], (AutoComplete) ->

  describe 'AutoComplete 2', ->

    myAutoComplete = null

    DEFAULT_CONFIG =
      id: 'my_search',
      uri: '/search/'

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
      {
        title: "Newcastle"
        uri: "/australia/newcastle"
        type: "publication"
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
      {
        name: "Newcastle"
        location: "/australia/newcastle"
        category: "publication"
      }
    ]
    RESULT_MAP =
      title: 'name',
      uri: 'location',
      type: 'category'

    describe 'Object', ->
      it 'is defined', ->
        expect(AutoComplete).toBeDefined()

    describe 'Initialisation', ->

      describe 'checking for required arguments', ->
        beforeEach ->
          loadFixtures 'autocomplete_mobile.html'
          spyOn(AutoComplete.prototype, "_init").andCallThrough()

        it 'should initialise if required arguments are supplied', ->
          myAutoComplete = new AutoComplete DEFAULT_CONFIG

          expect(AutoComplete.prototype._init).toHaveBeenCalledWith DEFAULT_CONFIG

        it 'should not initialise if required argument element ID is not supplied', ->
          myAutoComplete = new AutoComplete {uri: '/search'}

          expect(AutoComplete.prototype._init).not.toHaveBeenCalled()

        it 'should not initialise if required argument URI is not supplied', ->
          myAutoComplete = new AutoComplete {id: 'my_search'}

          expect(AutoComplete.prototype._init).not.toHaveBeenCalled()

      describe 'configuring the component', ->
        beforeEach ->
          loadFixtures 'autocomplete_mobile.html'
          myAutoComplete = new AutoComplete DEFAULT_CONFIG

        it 'should return a config object updated with the passed keys', ->
          newConfig = {uri: '/findme', parent: '.somewhere'}
          config = myAutoComplete._updateConfig newConfig

          expect(config.id).toBe DEFAULT_CONFIG.id
          expect(config.uri).toBe newConfig.uri
          expect(config.parent).toBe newConfig.parent

      describe 'setting up the component', ->
        beforeEach ->
          loadFixtures 'autocomplete_mobile.html'

        it 'should create the list element and add it as an object property', ->
          myAutoComplete = new AutoComplete DEFAULT_CONFIG

          expect(myAutoComplete.results).toBeDefined()
          expect(myAutoComplete.results.tagName).toBe 'UL'
          expect(myAutoComplete.results.childNodes.length).toBe 0
          expect(myAutoComplete.results.className).toBe 'autocomplete__results'
          expect(myAutoComplete.results.hovered).not.toBeDefined()

        it 'should create the list element with the specified class name', ->
          newConfig = {id: 'my_search', uri: '/search', resultsClass: 'mysearch__results'}
          myAutoComplete = new AutoComplete newConfig

          expect(myAutoComplete.results).toBeDefined()
          expect(myAutoComplete.results.className).toBe newConfig.resultsClass

    describe 'the results list', ->
      beforeEach ->
        loadFixtures 'autocomplete_mobile.html'
        myAutoComplete = new AutoComplete DEFAULT_CONFIG

      it 'should add a list hovered property to the component when mouse is over results', ->
        myAutoComplete._resultsMouseOver()

        expect(myAutoComplete.results.hovered).toBe true

      it 'should remove a list hovered property from the component when mouse is removed from results', ->
        myAutoComplete._resultsMouseOver()
        myAutoComplete._resultsMouseOut()

        expect(myAutoComplete.results.hovered).not.toBeDefined()

    describe 'updating the results list', ->

      describe 'performing a search', ->

        describe 'the search threshold', ->

          describe 'the default search threshold', ->
            beforeEach ->
              myAutoComplete = new AutoComplete DEFAULT_CONFIG
              spyOn myAutoComplete, '_makeRequest'

            it 'should perform a search if the threshold has been reached', ->
              minimumSearch = 'abc'
              myAutoComplete._searchFor minimumSearch

              expect(myAutoComplete._makeRequest).toHaveBeenCalledWith minimumSearch

            it 'should not perform a search if the threshold has not been reached', ->
              belowMinimumSearch = 'ab'
              myAutoComplete._searchFor belowMinimumSearch

              expect(myAutoComplete._makeRequest).not.toHaveBeenCalled()

          describe 'configuring the search threshold', ->
            beforeEach ->
              myAutoComplete = new AutoComplete DEFAULT_CONFIG
              spyOn myAutoComplete, '_makeRequest'
              myAutoComplete._updateConfig {threshold: 5}

            it 'should perfom a search if the configured threshold has been reached', ->
              minimumSearch = 'abcde'
              myAutoComplete._searchFor minimumSearch

              expect(myAutoComplete._makeRequest).toHaveBeenCalledWith minimumSearch

            it 'should not perfom a search if the configured threshold has not been reached', ->
              minimumSearch = 'abcd'
              myAutoComplete._searchFor minimumSearch

              expect(myAutoComplete._makeRequest).not.toHaveBeenCalled()

        describe 'generating the search URI', ->

          describe 'generating the default search endpoint', ->
            beforeEach ->
              myAutoComplete = new AutoComplete DEFAULT_CONFIG

            it 'should generate the full URI for the search endpoint with the search term', ->
              searchTerm = 'London'
              generatedURI = myAutoComplete._generateURI searchTerm

              expect(generatedURI).toBe "#{DEFAULT_CONFIG.uri}#{searchTerm}"

            it 'should generate the full URI for the search endpoint with the search term and scope', ->
              searchTerm = 'London'
              scope = 'homepage'
              generatedURI = myAutoComplete._generateURI searchTerm, scope

              expect(generatedURI).toBe "#{DEFAULT_CONFIG.uri}#{searchTerm}?scope=#{scope}"

          describe 'configuring the search endpoint', ->
            beforeEach ->
              myAutoComplete = new AutoComplete DEFAULT_CONFIG

            it 'should generate the full URI for the search endpoint with the search term', ->
              newConfig = {uri: '/mySearch='}
              searchTerm = 'London'
              myAutoComplete._updateConfig newConfig
              generatedURI = myAutoComplete._generateURI searchTerm

              expect(generatedURI).toBe "#{newConfig.uri}#{searchTerm}"

            it 'should generate the full URI for the search endpoint with the search term and scope', ->
              newConfig = {uri: '/mySearch='}
              searchTerm = 'London'
              scope = 'homepage'
              myAutoComplete._updateConfig newConfig
              generatedURI = myAutoComplete._generateURI searchTerm, scope

              expect(generatedURI).toBe "#{newConfig.uri}#{searchTerm}?scope=#{scope}"

        describe 'search throttling', ->
          it 'should do something cool'


      describe 'populating the results list', ->
        beforeEach ->
          myAutoComplete = new AutoComplete DEFAULT_CONFIG
  
        it 'should insert a list item for each result item into the results list element', ->
          myAutoComplete._populateResults SEARCH_RESULTS

          results = myAutoComplete.results.childNodes

          expect(myAutoComplete.results.populated).toBe true
          expect(results.length).toBe SEARCH_RESULTS.length
          expect(results[0].textContent).toBe SEARCH_RESULTS[0].title
          expect(results[1].textContent).toBe SEARCH_RESULTS[1].title
          expect(results[2].textContent).toBe SEARCH_RESULTS[2].title



      xdescribe 'generating the search result items', ->

        describe 'generating a list with links items', ->
          beforeEach ->
            myAutoComplete = new AutoComplete DEFAULT_CONFIG

          it 'should generate a list item with details matching the search results', ->
            myAutoComplete._populateResults SEARCH_RESULTS

            results = myAutoComplete.results.childNodes

            expect(results[0].tagName).toBe 'A'
            expect(results[0].textContent).toBe 'London'

        describe 'generating a list with text items', ->

          beforeEach ->
            basicMap = 
              title: 'name'

            newConfig = {responseMap: basicMap}

            myAutoComplete = new AutoComplete DEFAULT_CONFIG
            myAutoComplete._updateConfig newConfig

          it 'should generate a list item with details matching the search results', ->
            myAutoComplete._populateResults SEARCH_RESULTS

            results = myAutoComplete.results.childNodes

            expect(results[0].tagName).toBe 'LI'
            expect(results[0].textContent).toBe 'London'



      describe 'creating a list item', ->
        item = null
        searchTerm = 'Lon'
  
        describe 'creating a basic list item', ->
          basicMap = 
            title: 'title'
    
          beforeEach ->
            myAutoComplete = new AutoComplete DEFAULT_CONFIG
            myAutoComplete._updateConfig {map: basicMap}
            item = myAutoComplete._createListItem SEARCH_RESULTS[0], searchTerm

          it 'should return a list item containing the search results title', ->
            expect(item.tagName).toBe 'LI'
            expect(item.textContent).toBe SEARCH_RESULTS[0].title
            expect(item.className).toBe 'autocomplete__result'

          it 'should highlight the search term', ->
            expect(item.tagName).toBe 'LI'
            expect(item.innerHTML).toBe '<b>Lon</b>don'
        
        describe 'creating a list item that has a link inside when a URI is mapped', ->
          basicMap = 
            title: 'title',
            uri: 'uri'
    
          beforeEach ->
            myAutoComplete = new AutoComplete DEFAULT_CONFIG
            myAutoComplete._updateConfig {map: basicMap}
            item = myAutoComplete._createListItem SEARCH_RESULTS[0], searchTerm

          it 'should contain an anchor tag with the href set as the search results URI', ->
            anchor = item.childNodes[0]

            expect(anchor.tagName).toBe 'A'
            expect(anchor.getAttribute('href')).toBe SEARCH_RESULTS[0].uri

          it 'should contain an anchor tag containing the highlighted search term', ->
            anchor = item.childNodes[0]

            expect(anchor.tagName).toBe 'A'
            expect(anchor.innerHTML).toBe '<b>Lon</b>don'

      describe 'highlighting the search term', ->
        beforeEach ->
          myAutoComplete = new AutoComplete DEFAULT_CONFIG

        it 'should highlight the search text at the start of a title', ->
          testSearchTerm = 'Lond'

          highlightedText = myAutoComplete._highlightText SEARCH_RESULTS[0].title, testSearchTerm
          expect(highlightedText).toBe '<b>Lond</b>on'

        it 'should highlight the search text at the end of a title', ->
          testSearchTerm = 'don'

          highlightedText = myAutoComplete._highlightText SEARCH_RESULTS[0].title, testSearchTerm
          expect(highlightedText).toBe 'Lon<b>don</b>'

        it 'should highlight the search text in the middle of a title', ->
          testSearchTerm = 'ond'

          highlightedText = myAutoComplete._highlightText SEARCH_RESULTS[0].title, testSearchTerm
          expect(highlightedText).toBe 'L<b>ond</b>on'

        it 'should highlight the search text if it exactly matches a title', ->
          testSearchTerm = 'London'

          highlightedText = myAutoComplete._highlightText SEARCH_RESULTS[0].title, testSearchTerm
          expect(highlightedText).toBe '<b>London</b>'

        it 'should highlight the search text multiple times', ->
          testSearchTerm = 'London'
          testTitle = 'Is London really as nice as London?'

          highlightedText = myAutoComplete._highlightText testTitle, testSearchTerm
          expect(highlightedText).toBe 'Is <b>London</b> really as nice as <b>London</b>?'

        it 'should not highlight anything if the search text is not found', ->
          testSearchTerm = 'London'

          highlightedText = myAutoComplete._highlightText SEARCH_RESULTS[1].title, testSearchTerm
          expect(highlightedText).toBe 'Paris'
