define [], () ->

  class AutoComplete

    CONFIG =
      threshold: 3,
      map:
        title: 'title',
        type: 'type',
        uri: 'uri'

    constructor: (args) ->
      @_init args if args.id and args.uri

    _init: (args) ->
      CONFIG = @_updateConfig args
      @_addEventHandlers()

    _updateConfig: (args) ->
      newConfig = CONFIG
      newConfig[key] = value for own key, value of args
      newConfig

    _addEventHandlers: ->
