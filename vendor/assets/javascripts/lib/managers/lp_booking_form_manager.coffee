# This class manages the event biding and interaction
# for the booking form widget.
#
# Arguments:
# $             - The JS framework to be used inside the scoped object
# _args         - An hash with target form element.
#
# Example:
# new window.Lp.BookingFormManager(jQuery,{target:'section.booking'});
#
# Dependencies:
# JQuery
#
  
_dep = [
  'jquery'
  'vendor/date'
  'plugins/jquery-date-picker'
]

define _dep, ($) ->

  class BookingFormManager

    constructor: (_args={})->
      @target = _args.target || 'section.booking-section'
      @in_date = $("#{@target} input.search_start_date")
      @out_date = $("#{@target} input.search_end_date")
      @initSelectGroup()
      @initDatePicker()

    initSelectGroup: ()->
      $("#{@target} select.search_currency, #{@target} select.search_guests").bind('change', (e) =>
        @selectGroupLabelValue(e))

    initDatePicker: ()->
      date_picker_opts =
        clickInput: true
        createButton: false

      start = @in_date.val()
      end = @out_date.val()

      @in_date.datePicker(date_picker_opts).val(start).trigger('change')
      @out_date.datePicker(date_picker_opts).val(end).trigger('change')
      
      # Set earliest check-out date to tomorrow
      @out_date.dpSetStartDate(new Date(new Date().getTime() + 1 * 1000 * 60 * 60 * 24).asString())

      @in_date.bind('dateSelected', (e, selectedDate, $td) =>
        # Set check-out date one day after check-in if it falls before or on check-in date
        @out_date.dpSetSelected(new Date(@inValue() + 1 * 1000 * 60 * 60 * 24).asString()) unless @isValidEndDate()
        
        @updateNightsTotal()
      )

      @out_date.bind('dateSelected', (e, selectedDate, $td) =>
        # Set check-in date one day ahead check-out if it falls after or on check-out date
        @in_date.dpSetSelected(new Date(@outValue() - 1 * 1000 * 60 * 60 * 24).asString()) unless @isValidEndDate()
        
        @updateNightsTotal()
      )

      @in_date.bind('focus', (e) => @in_date.dpDisplay())
      @out_date.bind('focus', (e) => @out_date.dpDisplay())

      @updateNightsTotal()
    
     inValue: ->
       @normalizeDate($(@in_date).val())

     outValue: ->
       @normalizeDate($(@out_date).val())

     isValidEndDate: ->
       @inValue() < @outValue()

     updateNightsTotal: ->
       total_days = Math.round((@outValue() - @inValue())/86400000) if @inValue() && @outValue()
       total_days = 1 if total_days == 0
       
       if(total_days)
         $("#{@target} fieldset.booking-form-nights label").html(total_days)
         $("#{@target} fieldset.booking-form-nights span").text(if (total_days is 1) then 'night' else 'nights')

      normalizeDate: (date) ->
        Date.parse(date) if date

      selectGroupLabelValue: (e) ->
        $(e.target).prev('label').text($(e.target).find('option:selected').text())
