# AutoComplete
#
# TODO: - there's a bug with accented characters, they aren't being highlighted
#         (http://instanceof.me/post/17455522476/accent-folding-javascript as a possible solution)
#       - possibly cancel an existing XHR if typing continues and the last one hasn't returned yet
#       - might be better to attach to the form instead of the input
#       - pass an argument for the search endpoint
#       - pass an argument for the search scope (this may be redundant because of the last point)
#       - put the classes into a config object
#       - throttle the number of times the query is sent
#       - abstract the XHR code to a separate library
#
# Arguments:
#   _args (An object containing)
#     id    : [string] The target element
#
# Example:
#  args =
#    id: 'my_search'
#  new AutoComplete(args)
#
# Dependencies:
#   None

define [], ->

  class AutoComplete

    constructor: (args) ->
      @el = document.getElementById(args.id)
      @init() if @el

    init: ->
      @el.addEventListener 'input', (e) =>
        @_searchFor e.currentTarget.value
      , false
      @resultsElt = document.getElementById 'autocomplete__results'
      @showingList = false

    _searchFor: (searchTerm)  ->
      if searchTerm && searchTerm.length >= 3
        @searchTerm = searchTerm
        @_doRequest @searchTerm
      else if @showingList
        @_updateUI []
        @showingList = false

    _doRequest: ->
      myRequest = new XMLHttpRequest()
      myRequest.addEventListener 'readystatechange', =>
        if myRequest.readyState == 4
          if myRequest.status == 200
            @_updateUI JSON.parse myRequest.responseText

      myRequest.open 'get', "/search/#{@searchTerm}?scope=homepage"
      myRequest.setRequestHeader 'Accept', 'application/json'
      myRequest.send()

    _updateUI: (searchResults) ->
      resultsList = @_createList searchResults
      @el.parentNode.replaceChild resultsList, document.getElementById('autocomplete__results')
      @showingList = true

    _createList: (results) ->
      resultItems = (@_createListItem item for item in results)
      list = document.createElement 'UL'
      list.id = 'autocomplete__results'
      list.className = 'autocomplete__results'
      list.appendChild listItem for listItem in resultItems
      list

    _createListItem: (item) ->
      anchor = @_createAnchor item
      listItem = document.createElement 'LI'
      listItem.appendChild anchor
      listItem

    _createAnchor: (item) ->
      anchor = document.createElement 'A'
      anchor.href = item.uri
      anchor.className = "autocomplete__result autocomplete__result--#{item.type}"

      if @searchTerm
        regex = new RegExp @searchTerm, 'ig'
        anchor.innerHTML = item.title.replace regex, "<span class='autocomplete__result--highlight'>$&</span>"
      else
        anchor.innerHTML = item.title
      anchor
