define ['jquery', 'lib/extends/events','lib/components/group_toggle'], ($, EventEmitter, GroupToggle) ->

  class StackIntro extends EventEmitter

    constructor: (args={}) ->

      @config = 
        el: '.js-stack-intro'
        title: '.js-copy-title'
        lead: '.js-copy-lead'
        body: '.js-copy-body' 
      $.extend @config, args

      @$el = $(@config.el)
      @$title = $("#{@config.el} #{@config.title}")
      @$lead = $("#{@config.el} #{@config.lead}")
      @$body = $("#{@config.el} #{@config.body}")
      @init()

    init: ->
      @_introContentToggle = new GroupToggle({el: "#{@config.el} .js-group-toggle" })

    update: (args) ->
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

