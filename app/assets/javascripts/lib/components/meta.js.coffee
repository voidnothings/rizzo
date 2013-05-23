define ['jquery'], ($) ->
 
  class Meta

    config :
      LISTENER: '#js-card-holder'

    constructor: (args={}) ->
      $.extend @config, args
      @listen()


    # Subscribe
    listen: ->
      $(@config.LISTENER).on ':page/received', (e, data) =>
        @_updateTitle(data.title)
        @_updateMeta(data)
        @_updateView(data)


    # Private

    _updateTitle: (title) ->
      document.title = title

    _updateMeta: (data) ->
      console.log(data.title) if window.console 
      $('meta[name="title"]').attr('content', data.title)
      $('meta[name="description"]').attr('content', data.description)

    _updateView: (data) ->
      $('.js-intro-title').text(data.title)
      if data.stack_description
        $('.js-intro-lead').text(data.stack_description)
      else
        $('.js-intro-lead').empty()
