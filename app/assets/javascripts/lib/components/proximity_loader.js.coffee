define ['jquery'], ($) ->
 
  class ProximityLoader

    LISTENER = '#js-card-holder'


    # params
    # el: 
    # list: comma delimited list of elements to watch
    constructor: (args) ->
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
        $el = @$el.find(el)
        elems.push({
          $el: $el
          top: $el.offset().top
          threshold: $el.data('threshold')
        })
      elems
    
    _watch: ->
      enableTimer = false
      $(window).on 'scroll', =>
        clearTimeout(enableTimer) if enableTimer
        enableTimer = setTimeout =>
          @_check()
        , 200

    _check: ->
      fold = @_getViewportEdge()
      for el in @elems
        if (el.top - el.threshold) <= fold
          @_loadScriptFor(el)

    _loadScriptFor: (element) ->
      scriptPlaceholder = element.$el.find('.js-hidden-script')
      unless scriptPlaceholder.length is 0
        console.log(scriptPlaceholder) if window.console 
        commentedScript = scriptPlaceholder.html()
        # Remove the comments and execute the script
        script = commentedScript.replace('<!--', '').replace('-->', '')
        scriptPlaceholder.html(script)
        
