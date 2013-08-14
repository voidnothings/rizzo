define [], () ->

  class AutoComplete

    CONFIG =
      threshold: 3,
      resultsClass: 'autocomplete__results',
      resultItemClass: 'autocomplete__result',
      map:
        title: 'title',
        type: 'type',
        uri: 'uri'

    constructor: (args) ->
      @_init args if args.id and args.uri

    _init: (args) ->
      CONFIG = @_updateConfig args
      @_addEventHandlers()
      @results = @_buildResults()

    _updateConfig: (args) ->
      newConfig = CONFIG
      newConfig[key] = value for own key, value of args
      newConfig

    _addEventHandlers: ->

    _buildResults: ->
      results = document.createElement 'UL'
      results.className = CONFIG.resultsClass

      results.addEventListener 'mouseover', =>
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
      @_makeRequest searchTerm if searchTerm?.length >= CONFIG.threshold

    _makeRequest: ->

    _generateURI: (searchTerm, scope) ->
      uri = "#{CONFIG.uri}#{searchTerm}"
      uri += "?scope=#{scope}" if scope
      uri


    _populateResults: ->
      @results.appendChild document.createElement('LI')
      @results.appendChild document.createElement('LI')




    _createListItem: (item, searchTerm) ->
      listItem = document.createElement 'LI'
      listItem.className = CONFIG.resultItemClass

      highlightedText = @_highlightText item[CONFIG.map.title], searchTerm

      if CONFIG.map.uri? and item.uri?
        anchor = document.createElement 'A'
        anchor.href = item[CONFIG.map.uri]
        anchor.innerHTML = highlightedText
        listItem.appendChild anchor
      else
        listItem.innerHTML = highlightedText

      listItem

    _highlightText: (text, term) ->
      regex = new RegExp term, 'ig'
      text.replace regex, "<b>$&</b>"
