define [], ->

  class AutoComplete

    constructor: (args={}) ->

    _change: (searchString) ->
      if searchString && searchString.length >= 3
        @_searchFor searchString

    _searchFor:  ->


    _updateUI: (results) ->
      @_createListItem menuItem for menuItem in results
      

    _createListItem: ->
