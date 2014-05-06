define ['jquery', 'lib/utils/page_state', 'lib/extends/events', 'lib/extends/pushstate', 'lib/utils/deparam'], ($, PageState, EventEmitter, PushState) ->

  class Controller extends PageState

    $.extend(@prototype, EventEmitter)

    LISTENER = '#js-card-holder'
    state: {}

    constructor: (args = {}) ->
      $.extend @config, args

      @pushstate      = new PushState()

      @init()
      @listen()


    init: ->
      # Controller uses the main listening element for pub & sub
      @$el = $(LISTENER)
      @_generateState()


    # Subscribe
    listen: ->
      $(LISTENER).on ':cards/request', (e, data, analytics) =>
        @_updateState(data)
        @_callServer(@pushstate.createRequestUrl(@_serializeState()), @replace, analytics)

      $(LISTENER).on ':cards/append', (e, data, analytics) =>
        @_updateState(data)
        # We don't want to modify the url for appending content
        existingUrl = @getUrl()
        @_callServer(@pushstate.createRequestUrl(@_serializeState(), existingUrl), @append, analytics)

      $(LISTENER).on ':page/request', (e, data, analytics) =>
        @newDocumentRoot = data.url.split('?')[0]
        @_callServer(@pushstate.createRequestUrl(@_serializeState(), @newDocumentRoot), @newPage, analytics)

      $(LISTENER).on ':htmlpage/request', (e, data, analytics) =>
        @newDocumentRoot = data.url.split('?')[0]
        @_callServer(@pushstate.createRequestUrl(@_serializeState(), @newDocumentRoot), @htmlPage, analytics, 'html')


    # Publish

    # Page offset currently lives within search so we must check and update each time
    replace: (data, analytics) =>
      @_updateOffset(data.pagination) if data.pagination and data.pagination.page_offsets
      @pushstate.navigate(@_serializeState())
      @trigger(':cards/received', [data, @state, analytics])

    append: (data, analytics) =>
      @_updateOffset(data.pagination) if data.pagination and data.pagination.page_offsets
      @_removePageParam() # All other requests display the first page
      @trigger(':cards/append/received', [data, @state, analytics])

    newPage: (data, analytics) =>
      @_updateOffset(data.pagination) if data.pagination and data.pagination.page_offsets
      @pushstate.navigate(@_serializeState(), @newDocumentRoot)
      @trigger(':page/received', [data, @state, analytics])

    htmlPage: (data, analytics) =>
      @pushstate.navigate(@_serializeState(), @newDocumentRoot)
      @trigger(':htmlpage/received', [data, @state, analytics])


    # Private
    _callServer: (url, callback, analytics, dataType) ->
      $.ajax
        url: url
        dataType: dataType || 'json'
        success: (data) ->
          callback(data, analytics)

    _generateState: ->
      @state = $.deparam(@getParams())
      @_removePageParam()

    _updateState: (params) ->
      for key of params
        if params.hasOwnProperty(key)
          @state[key] = params[key]

    _updateOffset: (pagination) ->
      @state.search.page_offsets = pagination.page_offsets if @state.search

    _removePageParam: ->
      delete(@state.page)
      delete(@state.nearby_offset)

    _serializeState: ->
      $.param(@state)

