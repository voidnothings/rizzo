define [], () ->

  class PageState

    augmentedUrls: /\/rated$|\/apartments$|\/hostels-and-budget-hotels$|\/guesthouses$/
    checkFilters: /filters/
    checkSearch: /search/

    getUrl: ->
      window.location.href

    getSlug: ->
      window.location.pathname

    getparams: ->
      window.location.search

    getDocumentRoot: ->
      url = @getSlug()
      url = if @augmentedUrls.test(url) then url.split('/hotels')[0] + '/hotels' else url

    hasFiltered: ->
      url = @getSlug()
      if @augmentedUrls.test(url) then return true
      params = @getparams()
      @checkFilters.test(params)

    hasSearched: ->
      params = @getparams()
      @checkSearch.test(params)