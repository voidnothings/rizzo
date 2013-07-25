define [], ->

  class AutoComplete

    constructor: (args={}) ->
      @el = document.getElementById(args.id)
      @init() if @el

    init: ->

    _change: (searchString) ->
      if searchString && searchString.length >= 3
        @searchString = searchString
        @_searchFor searchString

    _searchFor:  ->

    _updateUI: (results) ->
      items = @_createListItem item for item in results

    _createListItem: (searchString, item) ->
      anchor = @_createAnchor searchString, item
      listItem = document.createElement 'LI'
      listItem.appendChild anchor
      listItem

    _createAnchor: (searchString, item) ->
      anchor = document.createElement 'A'
      anchor.setAttribute 'href', item.uri
      anchor.setAttribute 'class', "item__result--#{item.type}"
      titleNode = @_createAnchorText searchString, item.title
      anchor.appendChild titleNode
      anchor

    _createAnchorText: (searchString, title) ->
      node = document.createDocumentFragment()
      start = title.indexOf(searchString)
      end = start + searchString.length

      @_appendTextNode node, title.substring(0, start) if start > 0

      span = document.createElement 'SPAN'
      span.appendChild document.createTextNode(searchString)
      node.appendChild span

      @_appendTextNode node, title.substring(end, title.length) if end < title.length
      node

    _appendTextNode: (node, text) ->
      textNode = document.createTextNode text
      node.appendChild textNode
      node
