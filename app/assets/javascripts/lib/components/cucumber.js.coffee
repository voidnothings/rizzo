define ['jquery'], ($) ->
 
  class Cucumber

    config :
      LISTENER: '#js-card-holder'

    constructor: (args={}) ->
      @listen()

    # Subscribe
    listen: ->
      $(@config.LISTENER).on ':page/received', (e) ->
        $('body').removeClass('js-clock')
        false

      $(@config.LISTENER).on ':cards/append/received', (e) =>
        $('body').removeClass('js-clock')
        false

