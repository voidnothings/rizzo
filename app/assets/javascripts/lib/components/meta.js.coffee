define ['jquery'], ($) ->
 
  class Meta

    config :
      LISTENER: '#js-card-holder'

    constructor: (args={}) ->
      $.extend @config, args
      @listen()


    # Subscribe
    listen: ->
      $(@config.LISTENER).on ':cards/received', (e, data) =>
        if data.copy.title
          @_updateTitle(data.copy.title)
          @_updateMeta(data)
          @_updateView(data)


    # Private

    _updateTitle: (title) ->
      document.title = title

    _updateMeta: (data) ->
      $('meta[name="title"]').attr('content', data.copy.title)
      $('meta[name="description"]').attr('content', data.copy.description)

    _updateView: (data) ->
      $('.js-intro-title').text(data.copy.title)
      if data.copy.stack_description
        $('.js-intro-lead').text(data.copy.stack_description)
      else
        $('.js-intro-lead').empty()
