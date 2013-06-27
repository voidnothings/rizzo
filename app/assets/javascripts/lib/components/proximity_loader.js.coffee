define ['jquery'], ($) ->
 
  class ProximityLoader

    LISTENER = '#js-card-holder'


    # params
    # el: 
    # list: comma delimited list of elements to watch
    constructor: (args) ->
      $el = $(args.el || LISTENER)
      return false if $el.length is 0
      @_setUpElems(args)


    _setUpElems: (args) ->
      @elems = []
      console.log($(args.list)) if window.console 
      for el in args.list.split(',')
        $el = $(el)
        @elems.push({
          $el: $el
          top: $el.offset().top
          threshold: $el.data('threshold')
        })
      console.log @elems
      

    # Private

    