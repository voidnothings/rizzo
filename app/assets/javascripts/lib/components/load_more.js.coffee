# ------------------------------------------------------------------------------
# @constructor
# Replace pagination with a load more button
# 
# @params {#object} - As below in config
# ------------------------------------------------------------------------------

define ['jquery', 'lib/utils/error_messages'], ($, ErrorMessages) ->

  class LoadMore

    config:
      pagination        : '.lodgings-footer'
      nextBtnClass      : '.js-next-page'
      btnLabel          : 'Show more hotels'
      btnAltLabel       : 'Loading...'
      inProgress        : false
      hasError          : false
      callback         : {}

    constructor : (args) ->
      $.extend @config, args
      if $(@config.nextBtnClass).length isnt 0
        @config.nextUrl = @getNextUrl('body')
        @appendButton()
        @removePagination()
        @addHandlers()


    appendButton: ->
      @container = $('<footer/>').css('text-align', 'center')
      @btn = $('<a/>').attr('id', 'js-load-more').addClass('btn--load-more').text(@config.btnLabel)
      @container.append(@btn)
      $(@config.pagination).after(@container)


    removePagination: ->
      if $(@config.nextBtnClass).length is 0
        @container.remove()
      $(@config.pagination).remove()


    addHandlers: ->
      # Trigger Ajax call
      @btn.bind 'click', (e) =>
        e.preventDefault()
        @loadMoreContent()
      
      # Ajax success
      $('body').on 'receivedHotels/success', (e, data) =>
        @container.before($(data))
        @config.nextUrl = @getNextUrl(data)
        @removePagination()
        @setInProgress(false)
        if @config.callback && @config.callback.onsucess
          @config.callback.onsucess()

      # Ajax error
      $('body').on 'receivedHotels/error', (e, data) =>
        msg = ErrorMessages::systemError()
        @container.before(msg)
        @config.hasError = true
        @setInProgress(false)

        if @config.callback && @config.callback.onerror
          @config.callback.onerror()


    loadMoreContent: ->
      if @config.hasError then removeErrorMsg()
      @setInProgress(true)
      $.ajax({
        url: @config.nextUrl
        beforeSend: (xhr) -> xhr.setRequestHeader('X-APPEND', 'true')
        success: (data) => $('body').trigger 'receivedHotels/success', data
        error: -> $('body').trigger 'receivedHotels/error'
      })


    setInProgress: (isInProgress) ->
      @config.inProgress = isInProgress
      if isInProgress
        @btn.addClass('loading disabled').text(@config.btnAltLabel)
      else
        @btn.removeClass('loading disabled').text(@config.btnLabel)


    removeErrorMsg: ->
      @container.prev('.js-error').remove()
      @config.hasError = false


# ------------------------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------------------------

    getNextUrl: (parent) ->
      $(parent).find(@config.nextBtnClass).attr('href')
    
