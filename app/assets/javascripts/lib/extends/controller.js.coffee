define ['jquery'], ($) ->

  class Controller

    initHistory: ->
      if @supportHistory() 
        setTimeout((()=>$(window).bind 'popstate', @onPopstate), 1)

    navigate: (url, callback) ->
      return window.location.replace(url) if !@useHistory()
      @historyReady = true
      @setState(url)
      @update(url, callback)

    setState: (url) ->
      window.history.pushState({}, null, url)

    onPopstate: (e) =>
      window.location.replace(window.location.href)
    
    useHistory: () ->
      ((window.lp.useHistory ?= true) and @supportHistory()) 
      
    supportHistory: ->
      @isHistoryEnabled ?= (window.history and window.history.pushState and window.history.replaceState and !navigator.userAgent.match(/((iPod|iPhone|iPad).+\bOS\s+[1-4]|WebApps\/.+CFNetwork)/))


