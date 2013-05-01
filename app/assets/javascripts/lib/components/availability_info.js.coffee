# ------------------------------------------------------------------------------
# Constructor class for the Availability form manager
#
# ------------------------------------------------------------------------------
  
define ['jquery', 'lib/extends/events', 'lib/utils/serialize_form', 'lib/managers/select_group_manager', 'lib/managers/availability/helpers/availability_datepicker'], ($, EventEmitter, Serializer, SelectManager, AvailabilityDatepicker) ->

  class AvailabilityInfo

    $.extend(@prototype, EventEmitter)

    config :
      el: null
      visible: null

    constructor: (args={}) ->
      $.extend @config, args
      @init()

    init: ->
      @$el = $(@config.el)
      @$btn = @$el.find('.js-availability-edit-btn')
      @listen()  
    
    listen: ->
      @$btn.on 'click', (e) =>
        e.preventDefault()
        @change()
        false

    update: (params = {}) ->
      #to-do: iterate on params with base selector
      $('.js-availability-from').text(params.from)
      $('.js-availability-to').text(params.to)
      guestCopy = if params.guests > 1 then 'guests' else 'guest'
      $('.js-availability-guests').text("#{params.guests} #{guestCopy}")
      $('.js-availability-currency').removeClass('currency__icon--aud currency_icon--eur currency__icon--gbp currency__icon--usd')
      $('.js-availability-currency').addClass("currency__icon--#{params.currency.toLowerCase()}")
      $('.js-availability-currency').text(params.currency)

    reset: () ->

    change: ->
      @trigger(':change')

    show: ->
       @$el.removeClass('is-hidden')

    hide: ->
       @$el.addClass('is-hidden')

    block: ->
       @$btn.addClass('disabled').attr('disabled', true)
  
    unblock: ->
       @$btn.removeClass('disabled').attr('disabled', false)    

