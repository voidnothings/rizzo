# A class to handle the lazyloading mechanism
# 
# It requires a remote_url and a callback
# 

define ['jquery'], ($) ->

  class LazyLoad
    
    @version: '0.0.1'
    
    config: {
      container: '.lodgings-list-wrapper'
      remoteUrl: 'http://blah.com'
      tolerancePoint: '600'
      preLoad: true
      callback: 'myFunction'
      startPage: 1
      pagination: '.lodgings-footer'
    }
    
    flags: {
      noMoreContent : false
      inProgress    : false
    }


    init: =>
      @config.pageHeight = $('body').height()
      @config.windowHeight = $(window).height()
      @addLazyLoadTrigger()
      @addresizeHandler()
      @manageDom()
      if @config.preLoad is true then @preLoad()


    addLazyLoadTrigger: ->
      $(window).scroll =>
        currentPos = $(window).scrollTop()
        pageEnd = currentPos + @config.windowHeight
        if ((@config.pageHeight - pageEnd) <= @config.tolerancePoint)
          if !@flags.inProgress and !@flags.noMoreContent
            @loadMoreContent()


    addresizeHandler: ->
      $(window).resize =>
        @config.windowHeight = $(window).height()


    manageDom: ->
      $(@config.pagination).remove()
      @lazyContainer = $('<div/>').addClass('lazy-load-container')
      $(@config.container).append(@lazyContainer)



    loadMoreContent: ->
      @flags.inProgress = true
      @lazyContainer.addClass('loading')
      @config.startPage += 1
      # Fetch data from Back End


    appendContent: (data) ->
      @lazyContainer.before($(data)).hide()
      # Run a check to see if that was the final page. Ipdate flags.noMoreContent
      @flags.inProgress = false


    constructor : (args) ->
      $.extend @config, args
      @init()
      