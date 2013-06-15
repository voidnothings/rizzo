define ['jquery', 'lib/extends/events','lib/components/group_toggle'], ($, EventEmitter, GroupToggle) ->

  class StackIntro extends EventEmitter

    LISTENER = '#js-card-holder'

    # @params
    # el: {string} selector for parent element
    constructor: (args={}) ->
      @config =
        title: '.js-copy-title'
        lead: '.js-copy-lead'
        body: '.js-copy-body' 

      $.extend @config, args
      @$el = $(@config.el)
      @init() unless @$el.length is 0

    init: ->
      @$title = $("#{@config.el} #{@config.title}")
      @$lead = $("#{@config.el} #{@config.lead}")
      @$body = $("#{@config.el} #{@config.body}")
      @_introContentToggle = new GroupToggle({el: "#{@config.el} .js-group-toggle" })
      @listen()

    listen: ->
      $(LISTENER).on ':cards/received', (e, data) =>
        @_update(data.copy)

      $(LISTENER).on ':page/received', (e, data) =>
        @_update(data.copy)

    # Private

    _update: (args) ->
      @_checkContent(args)
      @$title.text(args.title)
      @$lead.text(args.lead)
      @$body.html(args.body)
    
    _checkContent: (args) ->
      if args.lead is ''
        @$lead.hide()
      else  
        @$lead.show()

      if args.body is ''
        @_introContentToggle.disable()
      else  
        @_introContentToggle.enable()

