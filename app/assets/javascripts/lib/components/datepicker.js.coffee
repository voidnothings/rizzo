# ------------------------------------------------------------------------------
# Constructor for initialising availability search datepickers and behaviour
# 
# Called by Availability_form_manager
# 
# @params
# container #{string} - The parent form
# ------------------------------------------------------------------------------

define ['jquery', 'jplugs/pickadate.legacy'], ($) ->

  class AvailabilityDatepicker
 
    constructor: (@target, @callbacks = {}) ->
      self = @
      @firstTime = true
      @in_date =  $(@target).find("#js-av-start")
      @out_date = $(@target).find("#js-av-end")
      @in_label = $('.js-av-start-label')
      @out_label = $('.js-av-end-label')
      today = []
      tomorrow = []
      d = new Date()
      today.push(d.getFullYear(), (d.getMonth() + 1), d.getDate())
      tomorrow.push(d.getFullYear(), (d.getMonth() + 1), (d.getDate() + 1))

      @in_date.pickadate({
        dateMin: today
        onSelect: ->
          self.dateSelected(this.getDate('yyyy/mm/dd'), "start")
      })

      @out_date.pickadate({
        dateMin: tomorrow
        onSelect: ->
          self.dateSelected(this.getDate('yyyy/mm/dd'), "end")

      })

    dateSelected : (date, type)->
      if type is "start"
        unless @isValidEndDate()
          checkOut = @normalizeDate(date)
          @out_date.data('pickadate').setDate(checkOut.year, checkOut.month, checkOut.day + 1)
        @in_label.text(@in_date.val())

      else if type is "end"
        if !@isValidEndDate() or @firstTime
          checkOut = @normalizeDate(date)
          @in_date.data('pickadate').setDate(checkOut.year, checkOut.month, checkOut.day - 1)
        @out_label.text(@out_date.val()).removeClass('is-hidden')

      @firstTime = false
      
      if @callbacks.onDateSelect
        @callbacks.onDateSelect(date, type)

    inValue: ->
      new Date($(@in_date).data('pickadate').getDate('yyyy/mm/dd'))

    outValue: ->
      new Date($(@out_date).data('pickadate').getDate('yyyy/mm/dd'))

    isValidEndDate: ->
      @inValue() < @outValue()

    normalizeDate: (date) ->
      date = date.split('/')
      friendlyDate =
        year:  date[0]
        month: date[1]
        day:   parseInt(date[2], 10)


 

