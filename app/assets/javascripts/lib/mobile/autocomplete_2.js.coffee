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
      @_updateConfig args

    _updateConfig: ->
