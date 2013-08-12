define [], () ->

  class AutoComplete

    CONFIG =
      threshold: 3,
      resultsClass: 'autocomplete__results',
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
