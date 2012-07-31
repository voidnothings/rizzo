# A class to handle the lazyloading mechanism
# 
# It requires a remote_url and a callback
# 

define ['jquery'], ($) ->

  class LoadMore
    
    @version: '0.0.1'
    
    config: {
      pagination        : '.lodgings-footer'
      targetcontainer   : '.lodgings-list'
      btnLabel          : 'Show more hotels'
      btnAltLabel       : 'Loading...'
      nextBtnClass      : '.js-next-page'
      inProgress        : false
    }

    addHandlers: ->
      @btn.bind 'click', (e) =>
        e.preventDefault()
        @loadMoreContent()

    getNextUrl: (parent) ->
      $(parent).find(@config.nextBtnClass).attr('href')

    createButton: ->
      @container = $('<footer/>').css('text-align', 'center')
      @btn = $('<a/>').attr('id', 'js-load-more').addClass('read-more-btn').text(@config.btnLabel)
      @container.append(@btn)
      $(@config.pagination).after(@container)

    removePagination: ->
      if $(@config.nextBtnClass).length is 0
        @container.remove()
      $(@config.pagination).remove()

    setInProgress: (isInProgress) ->
      @config.inProgress = isInProgress
      if isInProgress
        @btn.addClass('loading disabled').text(@config.btnAltLabel)
      else
        @btn.removeClass('loading disabled').text(@config.btnLabel)

    loadMoreContent: ->
      @setInProgress(true)
      $.ajax({
        url: @config.nextUrl
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Accept", "text/html")
        success: (data) =>
          @appendContent(data)
          @setInProgress(false)
        error: (data) ->
      })

    appendContent: (data) ->
      @container.before($(data))
      @config.nextUrl = @getNextUrl(data)
      @removePagination()

    constructor : (args) ->
      $.extend @config, args
      @config.nextUrl = @getNextUrl('body')
      @createButton()
      @removePagination()
      @addHandlers()