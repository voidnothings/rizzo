define ['jquery', 'lib/utils/page_state', 'lib/extends/events', 'lib/utils/deparam'], ($, PageState, EventEmitter) ->

  class Controller extends PageState

    $.extend(@prototype, EventEmitter)

    config:
      LISTENER: '#js-card-holder'

    state:
      params: null

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
      $(@config.LISTENER).on ':page/request', (e, data) =>
        @_updateState(data)
        @_callServer(@replace)

      $(@config.LISTENER).on ':page/append', (e, data) =>
        @_updateState(data)
        @_callServer(@append)

    # Publish
    replace: (data)->
      @_navigate(@_createUrl())
      @trigger(':page/received', data)

    append: (data) =>
      @_navigate(@_createUrl())
      @trigger(':page/append/received', data)

    # Private

    _callServer: (callback) ->
      $.ajax
        url: @_createUrl()
        dataType: 'json'
        success: callback

    _initHistory: ->
      if @_supportsHistory()
        # Modern browsers
        # WebKit fires a popstate event on document load
        # https://code.google.com/p/chromium/issues/detail?id=63040
        setTimeout((()=>$(window).bind 'popstate', @onPopState), 1)
      else if @_supportsHash()
        #ie8 and ie9
        @allowHistoryNav = true
        $(window).on('hashchange', { _this: @ }, @onHashChange ) 
        @onHashChange({data:{ _this: @ }}) if @hashValue()
      else
        #ie7
        false

    _supportsHistory: ->
      @isHistoryEnabled ?= (window.history and window.history.pushState and window.history.replaceState and !navigator.userAgent.match(/((iPod|iPhone|iPad).+\bOS\s+[1-4]|WebApps\/.+CFNetwork)/))

    _supportsHash: ->
      @isHashEnabled ?= ("onhashchange" of window)

    _generateState: ->
      @state.params = $.deparam(@getParams())
      window.y = @state.params

    _updateState: (params) ->
      for key of params
        if params.hasOwnProperty(key)
          @state[key] = params[key]

    _serializeState: ->
      $.param(@state)

    _createUrl: ->
      base = @getDocumentRoot() + "?" + @_serializeState()

    _navigate: (url, callback) ->
      if (@_supportsHistory() or @_supportsHash())
        @_setState(url)
      else
        window.location.replace(url) 

    _setState: (url) ->
      if @_supportsHistory()
        window.history.pushState({}, null, url)
      else if @_supportsHash()
        @allowHistoryNav = false
        window.location.hash = "!#{url}"








# TODO
onPopState: (e) =>
  window.location.replace(window.location.href)

onHashChange: (e) =>
  _this = e.data._this
  if _this.allowHistoryNav
    hash = _this.hashValue()
    url = (if hash then (hash.substring(2)) else window.location.href)
    window.location.replace(url)
  _this.allowHistoryNav = true

hashValue: ->
  if (window.location.hash and window.location.hash isnt '')
    window.location.hash
  else
    false
