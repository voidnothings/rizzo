define [], () ->

  class AutoComplete

    DEFAULTS =
      threshold: 3,
      resultsClass: 'autocomplete__results',
      resultItemClass: 'autocomplete__result',
      resultLinkClass: 'autocomplete__result__link',
      resultItemHoveredClass: 'autocomplete__current',
      activeClass: 'autocomplete__active'
      map:
        title: 'title',
        type: 'type',
        uri: 'uri'

    KEY =
      tab: 9,
      enter: 13,
      esc: 27,
      up: 38,
      down: 40

    constructor: (args) ->
      @_init args if args.id and args.uri

    _init: (args) ->
      @config = @_updateConfig args
      @el = document.getElementById @config.id
      @parentElt = document.getElementById @config.parentElt if @config.parentElt
      @_addEventHandlers()
      @results = @_buildResults()

    _updateConfig: (args) ->
      newConfig = {}
      newConfig[key] = value for own key, value of DEFAULTS
      newConfig[key] = value for own key, value of args
      newConfig

    _addEventHandlers: ->
      @el.addEventListener 'input', (e) =>
        @_searchFor e.currentTarget.value

      @el.addEventListener 'keypress', (e) =>
        @_keypressHandler e

    _buildResults: ->
      results = document.createElement 'UL'
      @_addClass results, @config.resultsClass
      @_addClass results, "#{@config.resultsClass}--#{@config.classModifier}" if @config.classModifier

      results.addEventListener 'click', (e) =>
        @_resultsClick e
      , false

      results.addEventListener 'mouseover', (e) =>
        @_resultsMouseOver e.target
      , false

      results.addEventListener 'mouseout', (e) =>
        @_resultsMouseOut e.target
      , false

      results

    # event handlers
    _keypressHandler: (e) ->
      switch e.keyCode
        when KEY.up
          e.preventDefault()
          @_highlightUp()
        when KEY.down
          e.preventDefault()
          @_highlightDown()
        when KEY.tab
          e.preventDefault() if @results.displayed
          if e.shiftKey
            @_highlightUp()
          else
            @_highlightDown()
        when KEY.enter
          if @results.highlighted
            e.preventDefault()
            @_handleEnter()
        when KEY.esc
          @el.value == 'hdhfdhd'
          console.log @el.value
          @_removeResults() if @results.displayed

    _resultsClick: (e) ->
      target = e.target

      # if the target was a b, check its parent
      target = target.parentNode if target.tagName == 'B'

      # if the real target was an anchor, prevent the event from bubbling so the text isn't selected
      if target.tagName == 'A'
        e.stopPropagation()
      else if target.tagName == 'LI'
        @_selectCurrent()

    _resultsMouseOver: (target) ->
      until target.tagName is 'LI'
        target = target.parentNode

      # clear old highlight
      @_removeClass(@results.highlighted, @config.resultItemHoveredClass) if @results.highlighted

      @results.highlighted = target
      @results.hovered = true
      @_highlightCurrent()

    _resultsMouseOut: ->
      # clear old highlight
      @_removeClass(@results.highlighted, @config.resultItemHoveredClass) if @results.highlighted

      delete @results.hovered
      delete @results.highlighted

    _selectCurrent: ->
      @el.value = @results.highlighted.textContent
      @config.selectCallback.call @results.highlighted if @config.selectCallback
      @_removeResults()

    _highlightCurrent: ->
      @_addClass @results.highlighted, "#{@config.resultItemHoveredClass}"

    # keypress handlers
    _handleEnter: ->
      # check if the child of the selected node is a link
      highlighted = @results.highlighted.firstChild
      if highlighted.tagName == 'A'
        # it's a link, change the href
        @_navigateTo highlighted.href
      else 
        @_selectCurrent()

    _highlightDown: ->
      if not @results.highlighted
        @results.highlighted = @results.firstChild
      else
        unless @results.highlighted.nextSibling == null
          @_removeClass(@results.highlighted, @config.resultItemHoveredClass) if @results.highlighted
          @results.highlighted = @results.highlighted.nextSibling 
      @_highlightCurrent()

    _highlightUp: ->
      if not @results.highlighted
        @results.highlighted = @results.lastChild
      else
        unless @results.highlighted.previousSibling == null
          @_removeClass(@results.highlighted, @config.resultItemHoveredClass) if @results.highlighted
          @results.highlighted = @results.highlighted.previousSibling 
      @_highlightCurrent()

    _navigateTo: (location) ->
      window.location = location

    _searchFor: (searchTerm) ->
      if searchTerm?.length >= @config.threshold
        @_makeRequest searchTerm
      else if @results.displayed
        @_removeResults()

    _makeRequest: (searchTerm) ->
      myRequest = new XMLHttpRequest()
      myRequest.addEventListener 'readystatechange', =>
        if myRequest.readyState == 4
          if myRequest.status == 200
            @_populateResults JSON.parse(myRequest.responseText), searchTerm

      myRequest.open 'get', @_generateURI(searchTerm, @config.scope)
      myRequest.setRequestHeader 'Accept', '*/*'
      myRequest.send()

    _generateURI: (searchTerm, scope) ->
      uri = "#{@config.uri}#{searchTerm}"
      uri += "?scope=#{scope}" if scope
      uri

    _populateResults: (resultItems, searchTerm) ->
      @_emptyResults() if @results.displayed

      resultItems = resultItems.slice(0, @config.limit) if @config.limit

      @results.appendChild(@_createListItem listItem, searchTerm) for listItem in resultItems
      @_addClass @parentElt, "#{@config.activeClass}" if @config.parentElt
      @_showResults() unless @results.displayed

    _showResults: ->
      @el.parentNode.insertBefore @results, @el.nextSibling # insertAfter @el
      @results.displayed = true

    _removeResults: ->
      @_emptyResults()
      @results.parentNode.removeChild @results
      @_removeClass @parentElt, @config.activeClass if @config.parentElt
      delete @results.displayed
      delete @results.highlighted

    _emptyResults: ->
      @results.removeChild @results.firstChild while @results.firstChild

    _createListItem: (item, searchTerm) ->
      listItem = document.createElement 'LI'
      @_addClass listItem, @config.resultItemClass

      highlightedText = @_highlightText item[@config.map.title], searchTerm

      if @config.map.uri? and item.uri?
        anchor = document.createElement 'A'
        anchor.href = item[@config.map.uri]
        anchor.className = @config.resultLinkClass
        anchor.className += " autocomplete__result__typed icon--#{item[@config.map.type]}--white--before" if @config.map.type
        anchor.innerHTML = highlightedText
        listItem.appendChild anchor
      else
        listItem.innerHTML = highlightedText

      if @config.map.data?
        listItem.setAttribute("data-#{key}", item[key]) for key in @config.map.data

      listItem

    _highlightText: (text, term) ->
      regex = new RegExp term, 'ig'
      text.replace regex, "<b>$&</b>"

    # utility functions
    _addClass: (item, _class) ->
      if (item.className.indexOf _class) < 0
        item.className += " #{_class}"

    _removeClass: (item, _class) ->
      reg = new RegExp ' ?'+_class, 'g'
      item.className = item.className.replace reg, ''
