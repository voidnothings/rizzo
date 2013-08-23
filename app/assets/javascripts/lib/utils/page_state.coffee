define [], () ->

  class PageState

    augmentedUrls: /(.*)(?=\/rated$|\/apartments$|\/hostels-and-budget-hotels$|\/guesthouses$)/
    checkFilters: /filters/
    checkSearch: /search/

    getUrl: ->
      window.location.href

    getSlug: ->
      window.location.pathname

    getParams: ->
      window.location.search.replace(/^\?/, '')

    getHash: ->
      window.location.hash

    getViewPort: ->
      document.documentElement.clientWidth

    setUrl: (url) ->
      window.location.replace(url)

    setHash: (hash) ->
      window.location.hash = hash

    getDocumentRoot: ->
      url = @getSlug()
      url = if @augmentedUrls.test(url) then url.match(@augmentedUrls)[1] else url

    hasFiltered: ->
      url = @getSlug()
      if @augmentedUrls.test(url) then return true
      params = @getParams()
      @checkFilters.test(params)

    hasSearched: ->
      params = @getParams()
      @checkSearch.test(params)