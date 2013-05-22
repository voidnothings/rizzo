# ------------------------------------------------------------------------------
#
# Availability Info
#
# ------------------------------------------------------------------------------
  
define ['jquery', 'lib/extends/events', 'lib/utils/page_state'], ($, EventEmitter, PageState) ->

  class AvailabilityInfo extends PageState

    $.extend(@prototype, EventEmitter)

    config :
      el: null
      LISTENER: '#js-card-holder'

    constructor: (args={}) ->
      $.extend @config, args
      @init()

    init: ->
      @$el = $(@config.el)
      @$btn = @$el.find('.js-availability-edit-btn')
      @listen()
      @broadcast()

    
    # Subscribe
    listen: ->
      $(@config.LISTENER).on ':page/request', =>
        @_block()

      $(@config.LISTENER).on ':page/received', (e, params) =>
        if @hasSearched()
          @_unblock(params.search)
          @_update()
          @_show()

    # Publish
    broadcast: ->
      @$btn.on 'click', (e) =>
        e.preventDefault()
        @trigger(':info/change')
        false


    # Private area
    
    _update: (params = {}) ->
      #to-do: iterate on params with base selector
      $('.js-availability-from').text(params.from)
      $('.js-availability-to').text(params.to)
      guestCopy = if params.guests > 1 then 'guests' else 'guest'
      $('.js-availability-guests').text("#{params.guests} #{guestCopy}")
      $('.js-availability-currency').removeClass('currency__icon--aud currency_icon--eur currency__icon--gbp currency__icon--usd')
      $('.js-availability-currency').addClass("currency__icon--#{params.currency.toLowerCase()}")
      $('.js-availability-currency').text(params.currency)

    _show: ->
       @$el.removeClass('is-hidden')

    _hide: ->
       @$el.addClass('is-hidden')

    _block: ->
       @$btn.addClass('disabled').attr('disabled', true)
  
    _unblock: ->
       @$btn.removeClass('disabled').attr('disabled', false)    

