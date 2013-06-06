define ['jquery', 'lib/utils/page_state', 'lib/extends/events', 'lib/utils/deparam'], ($, PageState, EventEmitter) ->

  class Controller extends PageState

    $.extend(@prototype, EventEmitter)

    config:
      LISTENER: '#js-card-holder'

    state: {}

    constructor: (args = {}) ->
      $.extend @config, args
      @init()
      @listen()

    init: ->
      # Controller uses the main listening element for pub & sub
      @$el = $(@config.LISTENER)
      @_generateState()
      @_initHistory()


    # Subscribe
    listen: ->
      $(@config.LISTENER).on ':cards/request', (e, data) =>
        @_updateState(data)
        @_callServer(@_createRequestUrl(), @replace)

      $(@config.LISTENER).on ':cards/append', (e, data) =>
        @_updateState(data)
        @_callServer(@_createRequestUrl(), @append)

      $(@config.LISTENER).on ':page/request', (e, data) =>
        @newDocumentRoot = data.url.split('?')[0]
        @_callServer(@_createRequestUrl(@newDocumentRoot), @newPage)


    # Publish
    replace: (data) =>
      @_navigate(@_createUrl())
      @trigger(':cards/received', [data, @state])

    append: (data) =>
      @_navigate(@_createUrl())
      @trigger(':cards/append/received', [data, @state])

    newPage: (data) =>
      @_navigate(@_createUrl(@newDocumentRoot))
      @trigger(':page/received', [data, @state])


    # Private
    _callServer: (url, callback) ->
      $.ajax
        url: url
        dataType: 'json'
        success: callback

    _initHistory: ->
      if @_supportsHistory()
        # Modern browsers
        # WebKit fires a popstate event on document load
        # https://code.google.com/p/chromium/issues/detail?id=63040
        setTimeout((()=>$(window).bind 'popstate', =>
          @setUrl(@getUrl())
        ), 1)
      else if @_supportsHash()
        #ie8 and ie9
        @allowHistoryNav = true
        # Set up our event listener to listen to hashchange (back/forward)
        $(window).on('hashchange', @_onHashChange)
        # If there's a hash on page load, fire the _onHashChange function and redirect the user to the correct page.
        @_onHashChange() if @getHash()
      else
        #ie7
        false

    _supportsHistory: ->
      @isHistoryEnabled ?= (window.history and window.history.pushState and window.history.replaceState and !navigator.userAgent.match(/((iPod|iPhone|iPad).+\bOS\s+[1-4]|WebApps\/.+CFNetwork)/))

    _supportsHash: ->
      @isHashEnabled ?= ("onhashchange" of window)

    _generateState: ->
      @state = $.deparam(@getParams())

    _updateState: (params) ->
      for key of params
        if params.hasOwnProperty(key)
          @state[key] = params[key]

    _serializeState: ->
      $.param(@state)

    # If navigating to a subsection we pass in the new document root
    _createRequestUrl: (rootUrl) ->
      documentRoot = rootUrl or @getDocumentRoot()
      documentRoot + ".json?" + @_serializeState()

    # If navigating to a subsection we pass in the new document root
    _createUrl: (rootUrl) ->
      documentRoot = rootUrl or @getDocumentRoot()
      if @_supportsHistory()
        base = documentRoot + "?" + @_serializeState()
      else
        base = "#!" + documentRoot + @_serializeState()

    _navigate: (url, callback) ->
      if (@_supportsHistory() or @_supportsHash())
        @_setState(url)
      else
        @setUrl(url) 

    _setState: (url) ->
      if @_supportsHistory()
        window.history.pushState({}, null, url)
      else
        # Ensure we don't trigger a refresh
        @allowHistoryNav = false
        # Store the new url in the hash
        @setHash(url)

    _onHashChange: () =>
      # Only cause a refresh if it's back/forward
      if @allowHistoryNav
        hash = @getHash()
        url = if hash then (hash.substring(2)) else @getUrl()
        @setUrl(url)
      # Ensure we are always listening for back/forward navigation
      @allowHistoryNav = true