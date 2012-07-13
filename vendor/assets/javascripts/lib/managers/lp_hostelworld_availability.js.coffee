# Provides 'show prices per night' popup and price totals calc for hostelworld bed availability
# on lodging detail page
#
# Arguments:
#   target: css selector for top level hostelworld HTML element to bind to
#
# Example:
#   hostelworldAvailability = new window.lp.HostelworldAvailability()
#   ..
#   # once we've rendered the hostelworld availability results e.g. in ajax success callback
#   hostelworldAvailability.init(target: '#hostelworld-rooms')
#
# Dependencies:
# JQuery
#


define(['jquery'],($)->

  class HostelworldAvailability

    init: (@args={})->
      @target = $(@args.target)
      if @target.length > 0
        @bookButtonState(false)
        @target.find('#hostelworld-rooms-form').submit @hasRoomsSelected
        @target.find('.show-price-action').click @togglePricePerNight
        @target.find('.room-guests').change @guestSelected

    bookButtonState: (enabled)->
      @bookButton ?= @target.find('#book-button')
      if enabled
        @bookButton.removeAttr('disabled')
      else
        @bookButton.attr('disabled', 'disabled')

    togglePricePerNight: (e)->
      e.preventDefault()
      link = $(e.target)
      td = link.closest('.price-per-person')
      td.toggleClass('blue-highlight')
      prices = td.find('.prices-per-night')
      prices.css('left', "#{(td.width()-prices.width())/2}px")
      prices.toggle()

    guestSelected: (e)=>
      guestsSelect = $(e.target)
      @updateRoomTotal(guestsSelect)
      @updateTotalPrice()
      @bookButtonState(@hasRoomsSelected())

    updateRoomTotal: (guestsSelect)->
      people = (Number) guestsSelect.find('option:selected').attr('value') 
      $roomTr = guestsSelect.closest('.hostelworld-room')
      pricePerPerson = (Number) $roomTr.find('td.price-per-person .big-price .price-amount').text()
      $totalAmount = $roomTr.find('.room-price-total .big-price .price-amount')
      totalAmount = people * pricePerPerson
      $totalAmount.text(totalAmount.toFixed(2))

    updateTotalPrice: ->
      totalPrice = 0.0
      for roomPriceTotal in @target.find('.room-price-total .price-amount')
        totalPrice += (Number) $(roomPriceTotal).text()
      @roomsPriceTotalAmount ?= @target.find('.rooms-price-total .price-amount')
      @roomsPriceTotalAmount.text(totalPrice.toFixed(2))
      deposit = totalPrice * 0.1
      @depositAmount ?= @target.find('.book-action .price-amount')
      @depositAmount.text(deposit.toFixed(2))

    selectedRoomsAndQuantity: ->
      selected = []
      for select, idx in @target.find('.room-guests')
        optionSelected = $(select).find('option:selected')
        quantity = (Number) optionSelected.attr('value')
        if quantity > 0
          code = $(select).attr('data-code')
          selected.push({code: code, quantity: quantity})
      selected

    hasRoomsSelected: =>
      @selectedRoomsAndQuantity().length > 0

)
