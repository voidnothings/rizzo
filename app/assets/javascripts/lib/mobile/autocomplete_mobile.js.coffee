# AutoComplete
#
# TODO: - there's a bug with accented characters, they aren't being highlighted
#         (http://instanceof.me/post/17455522476/accent-folding-javascript as a possible solution)
#       - possibly cancel an existing XHR if typing continues and the last one hasn't returned yet
#       - pass an argument for the search endpoint
#       - pass an argument for the search scope (this may be redundant because of the last point)
#       - put the classes into a config object
#       - throttle the number of times the query is sent
#       - abstract the XHR code to a separate library
#
# Arguments:
#   _args (An object containing)
#     id    : [string] The target form element
#     uri   : [string] The search endpoint
#     scope : [string] An optional value to specify the scope of the search
#
# Example:
#  args =
#    id: 'my_search'
#    uri: '/search'
#    scope: 'homepage'
#  
#  new AutoComplete(args)
#
# Dependencies:
#   None

define [], ->

  class AutoComplete

    constructor: (@args) ->
      @el = document.getElementById(args.id)
      if @el
        @inputElt = @el.getElementsByTagName('input')[0]
      @init() if @el and @inputElt

    init: ->
      @resultsElt = @el.getElementsByTagName('ul')
      @inputElt.addEventListener 'input', (e) =>
        @_searchFor e.currentTarget.value
      , false
      @showingList = false
      @el.classList.remove 'results-displayed'

    _searchFor: (searchTerm)  ->
      if searchTerm && searchTerm.length >= 3
        @searchTerm = searchTerm
        @_doRequest @searchTerm
      else if @showingList
        @_updateUI []
        @showingList = false
        @el.classList.remove 'results-displayed'

    _doRequest: ->
      myRequest = new XMLHttpRequest()
      myRequest.addEventListener 'readystatechange', =>
        if myRequest.readyState == 4
          if myRequest.status == 200
            @_updateUI JSON.parse myRequest.responseText

      myRequest.open 'get', @_generateURI(@args.uri, @args.scope)
      myRequest.setRequestHeader 'Accept', 'application/json'
      myRequest.send()

    _generateURI: (searchURI, scope) ->
      uri = "#{searchURI}#{@searchTerm}"
      uri += "?scope=#{scope}" if scope
      uri

    _updateUI: (searchResults) ->
      resultsList = @_createList searchResults
      @el.replaceChild resultsList, @resultsElt[0]
      @showingList = true
      @el.classList.add 'results-displayed'

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
      anchor.className = "autocomplete__result icon-list--#{item.type}"

      if @searchTerm
        regex = new RegExp @searchTerm, 'ig'
        anchor.innerHTML = item.title.replace regex, "<span class='autocomplete__result--highlight'>$&</span>"
      else
        anchor.innerHTML = item.title
      anchor
