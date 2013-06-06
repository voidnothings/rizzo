define ['jquery', 'lib/extends/events', 'lib/utils/serialize_form'], ($, EventEmitter, Serializer) ->

  class Filter

    $.extend(@prototype, EventEmitter)

    config :
      el: null
      state: null
      LISTENER: '#js-card-holder'
      
    constructor: (args={}) ->
      $.extend @config, args
      @init()

    init: ->
      @$el = $(@config.el)
      @listen()
      @broadcast()
      @_removeSEOLinks(@$el)


    # Subscribe
    listen: ->  

      $(@config.LISTENER).on ':page/received', (e, data) =>
        @_update(data)

      $(@config.LISTENER).on ':filter/reset', =>
        @_reset()


    # Publish
    broadcast: ->

      @$el.on 'change', 'input[type=checkbox]', (e) =>
        # currentTarget.name filters out the checkboxes used to toggle the accordion
        if e.currentTarget.name
          @_toggleActiveClass(e.currentTarget)
          @trigger(':cards/request', @_serialize())
        false

      # Listen to filter cards that exist outside of the component
      $(@config.LISTENER).on 'click', '.js-stack-card-filter', (e) =>
        e.preventDefault()
        filters = $(e.currentTarget).find('[data-filter]').data('filter')
        @_set(filters, true)
        @trigger(':cards/request', @_serialize())


    # Private area

    _removeSEOLinks: (parent) ->
      parent.find('.js-filter-label').each ->
        $(this).html($(this).children('a').text())

    _update: (data)->
      if data.disable_price_filters
        @_hideGroup('price')
      else
        @_showGroup('price')
        @_enable('price')

    _hideGroup: (name) ->
      @$el.find(".js-#{name}-filter").addClass('is-hidden')

    _showGroup: (name) ->
      @$el.find(".js-#{name}-filter").removeClass('is-hidden')

    _enable: (name) ->  
      @$el.find(".js-#{name}-filter").find('input[type=checkbox]').attr('disabled', false)

    _toggleActiveClass: (element) ->
      @$el.find(element).siblings('.js-filter-label').toggleClass('active')

    _serialize : ->
      filters = new Serializer(@$el)
      # Hand the controller an empty filters object rather than simply an empty object
      filters = if filters.hasOwnProperty('filters') then filters else {filters: {}}

    _set: (filters, value=false)->
      for name in filters.split(',')
        filter = @$el.find("input[name*='#{name}']")
        if filter
          filter.attr('checked', value)
          if value
            filter.siblings('label').addClass('active')
          else
            filter.siblings('label').removeClass('active')

    _reset: () ->
      for input in @$el.find('input[type=checkbox]')
        $input = $(input) 
        if $input.attr('name')
          $input.attr('checked', false)
          label = $input.siblings('label.js-filter-label')
          label.removeClass('active')
      @trigger(':cards/request', @_serialize())

    
    
    # Still used??
      
      # @$el.on('click', '.js-filter-reset', (e) =>
      #   e.preventDefault()
      #   @reset($(e.currentTarget).parent('label').siblings('.filters__body--drop-down'))
      #   false
      # )  
      
      # disable: (target) ->  
      #   inputs = target.find('input[type=checkbox]')
      #   inputs.attr('checked', false).attr('disabled', true)
      #   labels = target.find('label.js-filter-label')
      #   labels.removeClass('active')

    
 
    
 
 
