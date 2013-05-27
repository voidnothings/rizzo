# ------------------------------------------------------------------------------
# Constructor class for the Availability form manager
#
# ------------------------------------------------------------------------------
  
define ['jquery', 'lib/extends/events', 'lib/utils/serialize_form', 'lib/managers/select_group_manager', 'lib/components/datepicker'], ($, EventEmitter, Serializer, SelectManager, AvailabilityDatepicker) ->

  class AvailabilitySearch

    $.extend(@prototype, EventEmitter)

    config :
      el: 'form'

    constructor: (args={}) ->
      $.extend @config, args
      @state = (if args.hasDates then 'submited' else 'initialized')
      @init()

    init: ->
      @$el = $(@config.el)
      @$form = @$el.find('form')
      formDatePicker = new AvailabilityDatepicker(@$el)
      guestSelect =  new SelectManager('.js-guest-select') 
      currencySelect = new SelectManager('.js-currency-select') 
      @listen()  
    
    listen: ->
      @$form.on 'submit', (e) =>
        e.preventDefault()
        @submit()
        false

    setDefaultDates: ->
      currentDate = new Date()
      today = [currentDate.getFullYear(), (currentDate.getMonth() + 1), currentDate.getDate()]
      @$el.find('#js-av-start').data('pickadate').setDate(today[0], today[1], today[2])
      @$el.find('#js-av-end').data('pickadate').setDate(today[0], today[1], today[2] + 1)

    hasBeenSubmitted: ->
      (@state is 'submited') ? true : false 

    submit: ->
      if @$form.find('#js-av-start').val() is ''  or @$form.find('#js-av-start').val() is undefined
        @setDefaultDates()
      params = @serialize()  
      if params
        @state = 'submited'
        @trigger(':submit', params)

    set: (name, value)->
      input = @$form.find("input[name*='#{name}']")
      if input and value
        input.attr('value', value)

    block: ->
       @$submit ?= @$form.find('#js-booking-submit')
       @$submit.addClass('disabled').attr('disabled', true)
  
    unblock: ->
       @$submit ?= @$form.find('#js-booking-submit')
       @$submit.removeClass('disabled').attr('disabled', false)    

    show: ->
       @$el.removeClass('is-hidden')


    hide: ->
       @$el.addClass('is-hidden')       

    serialize : ->
      new Serializer(@$form)

    currentParams : ->
      if @hasBeenSubmitted()
        return @serialize()
      else 
        return {}
