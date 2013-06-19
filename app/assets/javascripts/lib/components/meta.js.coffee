define ['jquery'], ($) ->
 
  class Meta

    LISTENER = '#js-card-holder'

    constructor: () ->
      @listen()

    # Subscribe
    listen: ->
      $(LISTENER).on ':cards/received', (e, data) =>
        if data.copy && data.copy.title
          @_updateTitle(data.copy.title)
          @_updateMeta(data)

      $(LISTENER).on ':page/received', (e, data) =>
        if data.copy && data.copy.title
          @_updateTitle(data.copy.title)
          @_updateMeta(data)


    # Private

    _updateTitle: (title) ->
      document.title = title

    _updateMeta: (data) ->
      $('meta[name="title"]').attr('content', data.copy.title)
      $('meta[name="description"]').attr('content', data.copy.description)
