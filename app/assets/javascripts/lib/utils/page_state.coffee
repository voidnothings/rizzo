define [], () ->

  class PageState

    augmentedUrls: /(.*)(?=\/rated$|\/apartments$|\/hostels-and-budget-hotels$|\/guesthouses$|\?)/
    checkFilters: /filters/
    checkSearch: /search/

    getUrl: ->
      window.location.href

    getSlug: ->
      window.location.pathname

    getParams: ->
      window.location.search

    getHashValue: ->
      window.location.hash

    getDocumentRoot: ->
      url = @getSlug() + @getParams()
      url = if @augmentedUrls.test(url) then url.match(@augmentedUrls)[1] else url

    hasFiltered: ->
      url = @getSlug()
      if @augmentedUrls.test(url) then return true
      params = @getparams()
      @checkFilters.test(params)

    hasSearched: ->
      params = @getparams()
      @checkSearch.test(params)