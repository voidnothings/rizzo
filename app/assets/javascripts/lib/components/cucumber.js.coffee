define ['jquery'], ($) ->
 
  class Cucumber

    LISTENER = '#js-card-holder'

    constructor: () ->
      @listen()

    # Subscribe
    listen: ->
      $(LISTENER).on ':cards/received', (e) ->
        $('body').removeClass('js-clock')
        false

      $(LISTENER).on ':page/received', (e) ->
        $('body').removeClass('js-clock')
        false

      $(LISTENER).on ':cards/append/received', (e) =>
        $('body').removeClass('js-clock')
        false

