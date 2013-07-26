define [], ->

  class AutoComplete

    constructor: (args={}) ->
      @el = document.getElementById(args.id)
      @init() if @el

    init: ->
      @el.addEventListener 'change', @_change, false
      @resultsElt = document.getElementById 'autocomplete__results'

    _change: (searchString) ->
      if searchString && searchString.length >= 3
        @searchString = searchString
        @_searchFor @searchString

    _searchFor:  ->
      # do xhr and call _updateUI with results once complete

    _updateUI: (searchResults) ->
      resultsList = @_createList searchResults.results
      @el.parentNode.replaceChild resultsList, document.getElementById 'autocomplete__results'

    _createList: (results) ->
      resultItems = (@_createListItem item for item in results)
      console.log resultItems
      list = document.createElement 'UL'
      list.setAttribute 'id', 'autocomplete__results'
      list.appendChild listItem for listItem in resultItems
      list

    _createListItem: (item) ->
      anchor = @_createAnchor item
      listItem = document.createElement 'LI'
      listItem.appendChild anchor
      listItem

    _createAnchor: (item) ->
      anchor = document.createElement 'A'
      anchor.setAttribute 'href', item.uri
      anchor.setAttribute 'class', "autocomplete__result--#{item.type}"
      titleNode = @_createAnchorText @searchString, item.title
      anchor.appendChild titleNode
      anchor

    _createAnchorText: (searchString, title) ->
      # this is probly going to be easier to do using innerHTML and a string replace, tbh
      start = title.indexOf(searchString)
      node = document.createDocumentFragment()

      if start >= 0
        end = start + searchString.length

        # create a plain text node of any text before the search term
        @_appendTextNode node, title.substring(0, start) if start > 0

        # create a span around the search term
        span = document.createElement 'SPAN'
        span.setAttribute 'class', 'autocomplete__result--highlight'
        span.appendChild document.createTextNode(searchString)
        node.appendChild span

        # create a plain text node of any text after the search term
        @_appendTextNode node, title.substring(end, title.length) if end < title.length
      else
        @_appendTextNode node, title

      node

    _appendTextNode: (node, text) ->
      textNode = document.createTextNode text
      node.appendChild textNode
      node
