# ------------------------------------------------------------------------------
# Constructor for initialising availability search datepickers and behaviour
#
# Called by Availability_form_manager
#
# @params
# container #{string} - The parent form
# ------------------------------------------------------------------------------

define ['jquery', 'pickadate/lib/picker', 'pickadate/lib/picker.date', 'pickadate/lib/picker'], ($) ->

  class AvailabilityDatepicker

    config =
      callbacks: {}
      dateFormat: 'd mmm yyyy'
      dateFormatLabel: 'yyyy/mm/dd'
      startSelector: "#js-av-start"
      endSelector: "#js-av-end"

    # Opts can contain the following:
    # target (required) The selector for the containing element (or the element itself)
    # callbacks (optional) Object containing the onDateSelect callback
    constructor: (opts) ->
      $.extend config, opts

      self = @
      @in_date =  $(config.target).find(config.startSelector)
      @out_date = $(config.target).find(config.endSelector)
      @in_label = $('.js-av-start-label')
      @out_label = $('.js-av-end-label')
      @firstTime = if (@in_date.val() is ''  or @in_date.val() is undefined) then true else false
      @day = 86400000
      today = []
      tomorrow = []
      d = new Date()
      today.push(d.getFullYear() + 1, d.getMonth(), d.getDate())
      tomorrow.push(d.getFullYear() + 1, d.getMonth(), (d.getDate() + 1))

      @in_date.pickadate({
        min: today
        format: config.dateFormat
        onSet: ->
          self.dateSelected(this.get('select', config.dateFormatLabel), "start")
      })

      @out_date.pickadate({
        min: tomorrow
        format: config.dateFormat
        onSet: ->
          self.dateSelected(this.get('select', config.dateFormatLabel), "end")
      })

    dateSelected: (date, type)->
      console.log(date, type, 'date, type')
      if type is "start"
        unless @isValidEndDate()
          @out_date.data('pickadate').set('select', new Date(date).getTime() + @day)
        @in_label.text(@in_date.val())

      else if type is "end"
        if !@isValidEndDate() or @firstTime
          @in_date.data('pickadate').set('select', new Date(date).getTime() - @day)
        @out_label.text(@out_date.val()).removeClass('is-hidden')

      @firstTime = false

      if config.callbacks.onDateSelect
        config.callbacks.onDateSelect(date, type)

    inValue: ->
      new Date($(@in_date).data('pickadate').get('select', config.dateFormatLabel))

    outValue: ->
      new Date($(@out_date).data('pickadate').get('select', config.dateFormatLabel))

    isValidEndDate: ->
      @inValue() < @outValue()
