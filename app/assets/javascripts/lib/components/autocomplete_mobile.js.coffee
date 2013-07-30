define [], ->

  class AutoComplete

    constructor: (args={}) ->
      @el = document.getElementById(args.id)
      @init() if @el

    init: ->
      @el.addEventListener 'input', (e) =>
        e.stopPropagation()
        @_searchFor e.currentTarget.value
      , false
      @resultsElt = document.getElementById 'autocomplete__results'

    _searchFor: (searchTerm)  ->
      if searchTerm && searchTerm.length >= 3
        @searchTerm = searchTerm
        @_doRequest @searchTerm

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

    _createList: (results) ->
      resultItems = (@_createListItem item for item in results)
      list = document.createElement 'UL'
      list.setAttribute 'id', 'autocomplete__results'
      list.setAttribute 'class', 'autocomplete__results'
      list.appendChild listItem for listItem in resultItems
      list

    _createListItem: (item) ->
      anchor = @_createAnchor item
      listItem = document.createElement 'LI'
      listItem.appendChild anchor
      listItem

    _createAnchor: (item) ->
      regex = new RegExp @searchTerm, 'ig'
      anchor = document.createElement 'A'
      anchor.setAttribute 'href', item.uri
      anchor.setAttribute 'class', "autocomplete__result autocomplete__result--#{item.type}"
      anchor.innerHTML = item.title.replace regex, "<span class='autocomplete__result--highlight'>$&</span>"
      anchor
