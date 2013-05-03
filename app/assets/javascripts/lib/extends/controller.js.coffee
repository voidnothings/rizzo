define ['jquery'], ($) ->

  class Controller

    initHistory: ->
      if @supportHistory()
        # Modern browsers
        # WebKit fires a popstate event on document load
        # https://code.google.com/p/chromium/issues/detail?id=63040
        setTimeout((()=>$(window).bind 'popstate', @onPopState), 1)
      else if @supportHash()
        #ie8 and ie9
        @allowHistoryNav = true
        $(window).on('hashchange', { _this: @ }, @onHashChange ) 
        @onHashChange({data:{ _this: @ }}) if @hashValue()
      else
        #ie7
        false

    navigate: (url, callback) ->
      if (@supportHistory() or @supportHash())
        @setState(url) 
        @update(url, callback)
      else
        window.location.replace(url) 

    setState: (url) ->
      if @supportHistory()
        window.history.pushState({}, null, url)
      else if @supportHash()
        @allowHistoryNav = false
      window.location.hash = "!#{url}"

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

    supportHistory: ->
      @isHistoryEnabled ?= (window.history and window.history.pushState and window.history.replaceState and !navigator.userAgent.match(/((iPod|iPhone|iPad).+\bOS\s+[1-4]|WebApps\/.+CFNetwork)/))

    supportHash: ->
      @isHashEnabled ?= ("onhashchange" of window)

    update: (url, callback) ->
      false

