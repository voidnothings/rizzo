define [], ->

  class AutoComplete

    constructor: (args={}) ->
      @el = document.getElementById(args.id)
      @init() if @el

    init: ->
      @el.addEventListener 'change', @_change, false

    _change: (searchString) ->
      if searchString && searchString.length >= 3
        @searchString = searchString
        @_searchFor @searchString

    _searchFor:  ->

    _updateUI: (searchResults) ->
      listFragment = @_createList searchResults.results
      @el.parentNode.appendChild listFragment

    _createList: (results) ->
      resultItems = (@_createListItem item for item in results)
      console.log resultItems
      list = document.createElement 'UL'
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
      anchor.setAttribute 'class', "item__result--#{item.type}"
      titleNode = @_createAnchorText @searchString, item.title
      anchor.appendChild titleNode
      anchor

    _createAnchorText: (searchString, title) ->
      start = title.indexOf(searchString)
      node = document.createDocumentFragment()

      if start >= 0
        end = start + searchString.length

        @_appendTextNode node, title.substring(0, start) if start > 0

        span = document.createElement 'SPAN'
        span.appendChild document.createTextNode(searchString)
        node.appendChild span

        @_appendTextNode node, title.substring(end, title.length) if end < title.length
      else
        @_appendTextNode node, title

      node

    _appendTextNode: (node, text) ->
      textNode = document.createTextNode text
      node.appendChild textNode
      node
