define [], ->

  class AutoComplete

    constructor: (args={}) ->
      @el = document.getElementById(args.id)
      @init() if @el

    init: ->
      @el.addEventListener 'change', @_change, false
      @resultsElt = document.getElementById 'autocomplete__results'

    _change: (evt) ->

      if searchTerm && searchTerm.length >= 3
        @searchTerm = searchTerm
        @_searchFor @searchTerm

    _searchFor:  ->
      # do xhr and call _updateUI with results once complete
      self = @
      myRequest = new XMLHttpRequest()
      myRequest.addEventListener 'readystatechange', ->
        if myRequest.readyState == 4
          if myRequest.status == 200
            console.log 'worked'

      myRequest.open 'get', "/search/#{@searchTerm}?scope=homepage"

    _updateUI: (searchResults) ->
      resultsList = @_createList searchResults.results
      @el.parentNode.replaceChild resultsList, document.getElementById 'autocomplete__results'

    _createList: (results) ->
      resultItems = (@_createListItem item for item in results)
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
      anchor.innerHTML = item.title.replace @searchTerm, "<span class='autocomplete__result--highlight'>#{@searchTerm}</span>"
      anchor
