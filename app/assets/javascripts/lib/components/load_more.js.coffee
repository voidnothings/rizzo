define ['jquery', 'lib/utils/error_messages'], ($, ErrorMessages) ->

  class LoadMore
    
    version: '0.0.1'
    
    config: {
      pagination        : '.lodgings-footer'
      targetcontainer   : '.lodgings-list'
      btnLabel          : 'Show more hotels'
      btnAltLabel       : 'Loading...'
      nextBtnClass      : '.js-next-page'
      inProgress        : false
      hasError          : false
    }

    constructor : (args) ->
      $.extend @config, args
      @config.nextUrl = @getNextUrl('body')
      @createButton()
      @removePagination()
      @addHandlers()

    addHandlers: ->
      @btn.bind 'click', (e) =>
        e.preventDefault()
        @loadMoreContent()
      $('body').on 'receivedHotels/success', (e, data) =>
        @appendContent(data)
        @setInProgress(false)
      $('body').on 'receivedHotels/error', (e, data) =>
        @appendErrorMsg()
        @setInProgress(false)

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
      if @config.hasError then removeErrorMsg()
      @setInProgress(true)
      $.ajax({
        url: @config.nextUrl
        beforeSend: (xhr) ->
          xhr.setRequestHeader('X-APPEND', 'true')
        success: (data) =>
          $('body').trigger 'receivedHotels/success', data
        error: ->
          $('body').trigger 'receivedHotels/error'
      })

    appendContent: (data) ->
      @container.before($(data))
      @config.nextUrl = @getNextUrl(data)
      @removePagination()
    
    appendErrorMsg: ->
      msg = ErrorMessages::systemError()
      @container.before(msg)
      @config.hasError = true
    
    removeErrorMsg: ->
      @container.prev('.system-error').remove()
      @config.hasError = false

    