
define ['jquery', 'vendor/jquery/plugins/jquery-ujs','lib/managers/lp_nightly_rates_manager','lib/managers/lp_rate_disclaimer_manager','lib/managers/lp_popup'], ($, _ujs, NightlyRatesManager, RateDisclaimerManager, Popup) ->

  class RoomsManager
    
    @init: ->
      form = $('#availability_search')
      button = form.find('.booking-form-submit button')
      container = $('.booking-section')
      list = $('.rooms')
      hostelWorldAvailability = new window.lp.HostelworldAvailability()

      form.on 'ajax:before', ->
        list.slideUp 400, ->
          list.remove()
        button.html('Searching… <img src="/assets/ajax-loader.gif">').addClass('disabled').attr('disabled', true)

      form.on 'ajax:success', (event, data) ->
        list = $(data).hide()
        container.append(list)

        NightlyRatesManager.init()
        RateDisclaimerManager.init()
        hostelWorldAvailability.init(target: '#hostelworld-rooms')
        Popup.init()

        list.slideDown()
        button.html('Find rooms').removeClass('disabled').attr('disabled', false)
