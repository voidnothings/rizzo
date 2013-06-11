define ['lib/analytics/analytics_auth','lib/analytics/analytics_perf','lib/analytics/s_code'], (AnalyticsAuth, AnalyticsPerf) ->

  class Analytics

    constructor: (_window, data = null)->
      @_window = _window
      data ?= (@_window.lp.tracking)
      @config = $.extend(data,@_userAuth())

    trackView: (args={}) ->
      params = @_pagePerf()
      @track(params, true)

    trackLink: (name, params = {}) ->
      @_save()
      @_add(params)
      @_copy()
      if(typeof(@_window.s.tl) is 'function')
        @_window.s.tl()
      @_restore()

    track: (params = {}, restore = false) ->
      @_save() if restore
      @_add(params)
      @_copy()
      if(typeof(@_window.s.t) is 'function')
        @_window.s.t()
      @_restore() if restore

    #private
    _save: ->
      @prevConfig = {}
      for a of @config
        @prevConfig[a] = @config[a]

    _add: (params = {})->
      for a of params
        @config[a] = params[a]

    _copy: ->
      for a of @config
        @_window.s[a] = @config[a]

    _restore: ->
      for a of @config
        delete @_window.s[a]
      @config = {}
      for a of @prevConfig
        @config[a] = @prevConfig[a]
      @_copy()
      @prevConfig = null
      true

    _userAuth: ->
      params = new AnalyticsAuth()
      params.get()

    _pagePerf: ->
      params = new AnalyticsPerf()
      params.get()

