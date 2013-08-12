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
      results