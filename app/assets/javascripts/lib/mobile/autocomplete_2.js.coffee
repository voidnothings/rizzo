define [], () ->

  class AutoComplete

    CONFIG = {
      threshold: 3,
      map: {
        title: 'title',
        type: 'type',
        uri: 'uri'
      }
    }

    constructor: (args) ->
      @$el = document.getElementById(args.id)
      console.log @$el
      @_init() if @$el

    _init: ->