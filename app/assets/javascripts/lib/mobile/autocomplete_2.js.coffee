define [], () ->

  class AutoComplete

    DEFAULTS =
      threshold: 3,
      resultsClass: 'autocomplete__results',
      resultItemClass: 'autocomplete__result',
      resultLinkClass: 'autocomplete__result__link',
      map:
        title: 'title',
        type: 'type',
        uri: 'uri'

    constructor: (args) ->
      @_init args if args.id and args.uri

    _init: (args) ->
      @config = @_updateConfig args
      @el = document.getElementById @config.id
      @_addEventHandlers()
      @results = @_buildResults()

    _updateConfig: (args) ->
      newConfig = {}
      newConfig[key] = value for own key, value of DEFAULTS
      newConfig[key] = value for own key, value of args
      newConfig

    _addEventHandlers: ->
      @el.addEventListener 'input', (e) =>
        @_searchFor e.currentTarget.value

    _buildResults: ->
      results = document.createElement 'UL'
      results.className = @config.resultsClass

      results.addEventListener 'mouseover', (e) =>
        @_resultsMouseOver()
      , false

      results.addEventListener 'mouseout', =>
        @_resultsMouseOut()
      , false

      results

    # event handlers for mouse events
    _resultsMouseOver: ->
      @results.hovered = true

    _resultsMouseOut: ->
      delete @results.hovered

    _searchFor: (searchTerm) ->
      @_makeRequest searchTerm if searchTerm?.length >= @config.threshold

    _makeRequest: (searchTerm) ->
      myRequest = new XMLHttpRequest()
      myRequest.addEventListener 'readystatechange', =>
        if myRequest.readyState == 4
          if myRequest.status == 200
            @_populateResults JSON.parse(myRequest.responseText), searchTerm

      myRequest.open 'get', @_generateURI(searchTerm, @config.scope)
      myRequest.setRequestHeader 'Accept', '*/*'
      myRequest.send()

    _generateURI: (searchTerm, scope) ->
      uri = "#{@config.uri}#{searchTerm}"
      uri += "?scope=#{scope}" if scope
      uri

    _populateResults: (resultItems, searchTerm) ->
      if @results.populated
        @_emptyResults()

      @results.appendChild(@_createListItem listItem, searchTerm) for listItem in resultItems
      @results.populated = true
      @_appendResults()

    _appendResults: ->
      @el.parentNode.insertBefore @results, @el.nextSibling # insertAfter @el

    # _removeResults: ->

    _emptyResults: ->
      @results.removeChild @results.firstChild while @results.firstChild

    _createListItem: (item, searchTerm) ->
      listItem = document.createElement 'LI'
      listItem.className = @config.resultItemClass

      highlightedText = @_highlightText item[@config.map.title], searchTerm

      if @config.map.uri? and item.uri?
        anchor = document.createElement 'A'
        anchor.href = item[@config.map.uri]
        anchor.className = @config.resultLinkClass

        anchor.innerHTML = highlightedText
        listItem.appendChild anchor
      else
        listItem.innerHTML = highlightedText

      listItem

    _highlightText: (text, term) ->
      regex = new RegExp term, 'ig'
      text.replace regex, "<b>$&</b>"
