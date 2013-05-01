define ['jquery', 'lib/base/events', 'lib/utils/serialize_form'], ($, EventEmitter, Serializer) ->

  class LodgingFilter

    $.extend(@prototype, EventEmitter)

    config :
      el: null
      state: null
      
    constructor: (args={}) ->
      $.extend @config, args
      @init()

    init: ->
      @$el = $(@config.el)
      @removeSEOLinks()
      @listen()

    listen: ->  
      @$el.on('change', 'input[type=checkbox]', (e) =>
        if e.currentTarget.name
          $(e.currentTarget).siblings('.js-filter-label').toggleClass('active')
          @submit()
        false
      )
      @$el.on('click', '.js-filter-reset', (e) =>
        e.preventDefault()
        @reset($(e.currentTarget).parent('label').siblings('.filters__body--drop-down'))
        false
      )  
    
    submit: ->
      @trigger(':change', @serialize())

    set: (name, value=false)->
      filter = @$el.find("input[name*='#{name}']")
      if filter
        filter.attr('checked', value)
        if value
          filter.siblings('label').addClass('active')
        else
          filter.siblings('label').removeClass('active')

    reset: (target = @$el) ->
      for input in target.find('input[type=checkbox]')
        $input = $(input) 
        if $input.attr('name')
          $input.attr('checked', false)
          label = $input.siblings('label.js-filter-label')
          label.removeClass('active')
      @submit()

    hideGroup: (name) ->
      @$el.find(".js-#{name}-filter").addClass('is-hidden')

    showGroup: (name) ->
      target = @$el.find(".js-#{name}-filter")
      target.removeClass('is-hidden')
      @enable(target)

    disable: (target) ->  
      inputs = target.find('input[type=checkbox]')
      inputs.attr('checked', false).attr('disabled', true)
      labels = target.find('label.js-filter-label')
      labels.removeClass('active')

    enable: (target) ->  
      inputs = target.find('input[type=checkbox]')
      inputs.attr('disabled', false)
 
    serialize : ->
      new Serializer(@$el)
 
    currentParams: ->  
      @serialize()

    removeSEOLinks: (parent)->
      @$el.find('.js-filter-label').each ->
        $(this).html($(this).children('a').text())      

