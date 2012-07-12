_dep = [
  'jquery'
  'plugins/jquery-ujs'
  'managers/lp_nightly_rates_manager'
  'managers/lp_rate_disclaimer_manager'
  'managers/lp_popup'
]

define _dep, ($, _ujs, NightlyRatesManager, RateDisclaimerManager, Popup) ->

  class RoomsManager
    
    @init: ->
      form = $('#availability_search')
      button = form.find('.booking-form-submit button')
      container = $('.booking-section')
      list = $('.rooms')

      form.on 'ajax:before', ->
        console.log(form)
        list.slideUp 400, ->
          list.remove()
        button.html('Searching… <img src="/assets/ajax-loader.gif">').addClass('disabled').attr('disabled', true)

      form.on 'ajax:success', (event, data) ->
        console.log(form)
        list = $(data).hide()
        container.append(list)

        NightlyRatesManager.init()
        RateDisclaimerManager.init()
        Popup.init()

        list.slideDown()
        button.html('Find rooms').removeClass('disabled').attr('disabled', false)
