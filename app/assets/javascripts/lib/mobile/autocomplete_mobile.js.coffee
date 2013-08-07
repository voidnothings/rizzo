# AutoComplete
#
# TODO: - there's a bug with accented characters, they aren't being highlighted
#         (http://instanceof.me/post/17455522476/accent-folding-javascript as a possible solution)
#       - possibly cancel an existing XHR if typing continues and the last one hasn't returned yet
#       - put the classes into a config object
#       - abstract the XHR code to a separate library
#
# Arguments:
#   _args (An object containing)
#     id        : [string] The target form element
#     uri       : [string] The search endpoint
#     listOnly  : [boolean] (Optional) Flag whether to only show the list of results
#     scope     : [string] (Optional) Value to specify as the scope of the search
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

    DEFAULT_MAP = 
      title: 'title',
      type: 'type',
      uri: 'uri'

    constructor: (@args) ->
      @el = document.getElementById(args.id)
      @init() if @el

    init: ->
      if @args.responseMap
        @responseMap = @args.responseMap
      else
        @responseMap = DEFAULT_MAP

      @_addEventHandlers()
      @showingList = false
      @throttled = false

    _addEventHandlers: ->
      @el.addEventListener 'input', (e) =>
        @_searchFor e.currentTarget.value
      , false

      @el.addEventListener 'keydown', (e) =>
        if @showingList
          @_handleKeypress e

      @el.parentNode.addEventListener 'click', (e) =>
        if e.target.tagName == 'A'
          if e.target.getAttribute('href') == '#'
            e.preventDefault()
            @el.value = e.target.textContent
            @_removeResults()

    _handleKeypress: (e) ->
      if e.keyCode == 40 # down arrow
        e.preventDefault()
        @_highlightDown()
      if e.keyCode == 38 # up arrow
        e.preventDefault()
        @_highlightUp()
      if e.keyCode == 13 # enter
        if @args.listOnly
          location.href = e.target.childNodes[0].href
        else
          e.preventDefault()
          @_selectHighlighted()
      if e.keyCode == 27
        @_removeResults()

    _highlightDown: ->
      if @currentHighlight >= 0
        @_updateHighlight @currentHighlight+1, @currentHighlight
      else
        @currentHighlight = 0
        @_updateHighlight @currentHighlight

    _highlightUp: ->
      resultsLength = @resultsList.childNodes.length

      if @currentHighlight < resultsLength
        @_updateHighlight @currentHighlight-1, @currentHighlight
      else
        @currentHighlight = resultsLength-1
        @_updateHighlight @currentHighlight

    _updateHighlight: (newActive, oldActive) ->
      results = @resultsList.childNodes

      if newActive >= results.length
        newActive = results.length-1

      if newActive < 0
        newActive = 0

      @currentHighlight = newActive
      results[newActive].classList.add 'autocomplete__active'
      results[oldActive].classList.remove 'autocomplete__active' if oldActive >= 0 and oldActive != newActive

    _selectHighlighted: ->
      @el.value = @resultsList.childNodes[@currentHighlight].textContent
      @_removeResults()

    _searchFor: (searchTerm)  ->
      if searchTerm && searchTerm.length >= 3
        @searchTerm = searchTerm
        @_doRequest @searchTerm
      else if @showingList
        @_removeResults()

    _doRequest: ->
      if not @throttled
        myRequest = new XMLHttpRequest()
        myRequest.addEventListener 'readystatechange', =>
          if myRequest.readyState == 4
            if myRequest.status == 200
              @_updateUI JSON.parse myRequest.responseText

        myRequest.open 'get', @_generateURI(@args.uri, @args.scope)
        myRequest.setRequestHeader 'Accept', '*/*'
        myRequest.send()
        @throttled = true
        window.setTimeout =>
          @throttled = false
        , 200

    _generateURI: (searchURI, scope) ->
      uri = "#{searchURI}#{@searchTerm}"
      uri += "?scope=#{scope}" if scope
      uri

    _removeResults: ->
      @el.parentNode.removeChild @resultsList if @resultsList
      document.body.classList.remove 'hero-search-results-displayed'
      @showingList = false

    _updateUI: (searchResults) ->
      if @showingList
        @el.parentNode.removeChild @resultsList

      @resultsList = @_createList searchResults
      @el.parentNode.insertBefore @resultsList, @el.nextSibling # aka insertAfter
      @showingList = true
      @currentHighlight = undefined
      document.body.classList.add 'hero-search-results-displayed'

    _createList: (results) ->
      resultItems = (@_createListItem item for item in results)
      resultItems.splice(0, @args.results) if @args.results
      list = document.createElement 'UL'
      list.className = 'autocomplete__results'
      list.appendChild listItem for listItem in resultItems
      list

    _createListItem: (item) ->
      listItem = document.createElement 'LI'
      listItem.appendChild @_createAnchor(item)
      listItem

    _createAnchor: (item) ->
      anchor = document.createElement 'A'
      anchor.href = if @responseMap.uri then item[@responseMap.uri] else '#'
      anchor.className = 'autocomplete__result'

      if @responseMap.type
        anchor.classList.add 'autocomplete__result__type'
        anchor.classList.add "autocomplete__result__type--#{item[@responseMap.type]}"

      if @searchTerm
        anchor.innerHTML = @_highlightText item[@responseMap.title], @searchTerm
      else
        anchor.innerHTML = item[@responseMap.title]
      anchor

    _highlightText: (text, term) ->
      regex = new RegExp term, 'ig'
      text.replace regex, "<b>$&</b>"
