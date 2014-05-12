define ['jquery', 'lib/utils/page_state', 'lib/extends/events', 'lib/extends/pushstate', 'lib/utils/deparam'], ($, PageState, EventEmitter, PushState) ->

  class Controller extends PageState

    $.extend(@prototype, EventEmitter)

    LISTENER = '#js-card-holder'
    state: []
    documentRoot: []

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
        @_navigate(@_serializeState())
        @_callServer(@_createRequestUrl(@_serializeState()), @replace, analytics)

      $(LISTENER).on ':cards/append', (e, data, analytics) =>
        @_updateState(data)
        # We don't want to modify the url for appending content
        existingUrl = @getUrl()
        @_callServer(@_createRequestUrl(@_serializeState(), existingUrl), @append, analytics)

      $(LISTENER).on ':page/request', (e, data, analytics) =>
        @_generateState( data.url.split('?')[0] )
        @_navigate(@_serializeState(), @documentRoot[@currentState])
        @_callServer(@_createRequestUrl(@_serializeState(), @documentRoot[@currentState]), @newPage, analytics)

      $(LISTENER).on ':layer/request', (e, data, analytics) =>
        @_generateState( data.url.split('?')[0] )
        @_navigate(@_serializeState(), @documentRoot[@currentState])
        @_callServer(@_createRequestUrl(@_serializeState(), @documentRoot[@currentState]), @htmlPage, analytics, 'html')

      $(LISTENER).on ':controller/back', (e, data, analytics) =>
        @_removeState()
        @_generateState(@documentRoot[@currentState])
        @_navigate(@_serializeState(), @documentRoot[@currentState])

    # Publish

    # Page offset currently lives within search so we must check and update each time
    replace: (data, analytics) =>
      @_updateOffset(data.pagination) if data.pagination and data.pagination.page_offsets
      @trigger(':cards/received', [data, @state[@currentState], analytics])

    append: (data, analytics) =>
      @_updateOffset(data.pagination) if data.pagination and data.pagination.page_offsets
      @_removePageParam() # All other requests display the first page
      @trigger(':cards/append/received', [data, @state[@currentState], analytics])

    newPage: (data, analytics) =>
      @_updateOffset(data.pagination) if data.pagination and data.pagination.page_offsets
      @trigger(':page/received', [data, @state[@currentState], analytics])

    htmlPage: (data, analytics) =>
      @trigger(':layer/received', [data, @state[@currentState], analytics])


    # Private
    _callServer: (url, callback, analytics, dataType) ->
      $.ajax
        url: url
        dataType: dataType || 'json'
        success: (data) ->
          callback(data, analytics)

    _generateState: (newDocumentRoot) ->
      if @currentState is undefined then @currentState = 0 else @currentState += 1
      @state.push $.deparam(@getParams())
      @documentRoot.push(newDocumentRoot || @getDocumentRoot())
      @_removePageParam()

    _removeState: ->
      @state.splice @state.length-1, 1
      @documentRoot.splice @documentRoot.length-1, 1
      @currentState = @currentState - 1;

    _updateState: (params) ->
      for key of params
        if params.hasOwnProperty(key)
          @state[@currentState][key] = params[key]

    _updateOffset: (pagination) ->
      @state[@currentState].search.page_offsets = pagination.page_offsets if @state.search

    _removePageParam: ->
      delete(@state[@currentState].page)
      delete(@state[@currentState].nearby_offset)

    _serializeState: ->
      $.param(@state[@currentState])

    # For testing, do not remove

    _createRequestUrl: (state, rootUrl) ->
      @pushstate.createRequestUrl(state, rootUrl)

    _navigate: (state, rootUrl, callback) ->
      @pushstate.navigate(state, rootUrl, callback)

