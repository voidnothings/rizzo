required = if window.lp.isMobile then 'jsmin' else 'jquery'

define [required, 'lib/extends/events'], ($, EventEmitter) ->

  class ProximityLoader

    for key, value of EventEmitter
      @prototype[key] = value

    LISTENER = '#js-row--content'

    # params
    # el: The listening element
    # list: comma delimited list of elements to watch
    # success: event to fire when the criteria is matched
    # successParams: Custom parameters to pass through with the success event
    constructor: (args) ->
      @success = args.success || ':asset/uncomment'
      @klass = args.klass || ''
      @$el = $(args.el || LISTENER)
      return false if @$el.length is 0

      @elems = @_setUpElems(args)
      @_check() # Check on load in case the user refreshes midway down the page
      @_watch()


    # Private

    _getViewportEdge: ->
      window.pageYOffset + window.innerHeight

    _setUpElems: (args) ->
      elems = []
      for el in args.list.split(',')
        $elems = @$el.find(el)
        for $el in $elems
          $el = if $.fn then $($el) else $el
          elems.push({
            $el: $el
            top: parseInt($el.offset().top, 10)
            threshold: parseInt($el.data('threshold') || 500, 10)
          })
      elems

    _watch: ->
      enableTimer = false
      # Only create jquery object if necessary, otherwise we already have the node
      win = if $.fn then $(window) else window
      win.on 'scroll', =>
        clearTimeout(enableTimer) if enableTimer
        enableTimer = setTimeout =>
          @_check()
        , 200

    _check: ->
      fold = @_getViewportEdge()
      for el in @elems
        if (el.top - el.threshold) <= fold
          @trigger(@success, [el.$el, @klass])

