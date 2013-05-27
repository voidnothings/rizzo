define ['lib/analytics/analytics_auth','lib/analytics/analytics_perf','lib/analytics/s_code'], (AnalyticsAuth, AnalyticsPerf) ->

  class Analytics

    constructor: (data)->
      data ?= (window.lp.tracking)
      @config = $.extend(data,@userAuth())
    
    trackLink: (name, params = {}) ->
      @save()
      @add(params)
      @copy()
      if(typeof(window.s.tl) is 'function')
        window.s.tl()
      @restore()

    track: (params = {}, restore = false) ->
      @save() if restore
      @add(params)
      @copy()
      if(typeof(window.s.t) is 'function')
        window.s.t()
      @restore() if restore

    add: (params = {})->
      for a of params
        @config[a] = params[a]

    copy: ->
      for a of @config
        window.s[a] = @config[a]

    linkTrackVars: (context) ->
      evars = (a for a of context)
      window.s.linkTrackVars = evars

    linkTrackEvents: (events) ->
      window.s.linkTrackEvents = events

    save: ->
      @prevConfig = {}
      for a of @config
        @prevConfig[a] = @config[a]

    restore: ->
      for a of @config
        delete window.s[a]
      @config = {}
      for a of @prevConfig
        @config[a] = @prevConfig[a]
      @copy()
      @prevConfig = null
      true

    trackView: (args={}) ->
      params = @pagePerf()
      @track(params, true)

    userAuth: ->
      params = new AnalyticsAuth()
      params.get()

    pagePerf: ->
      params = new AnalyticsPerf()
      params.get()

