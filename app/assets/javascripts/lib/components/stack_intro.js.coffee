define ['jquery', 'lib/extends/events','lib/components/group_toggle'], ($, EventEmitter, GroupToggle) ->

  class StackIntro extends EventEmitter

    config :
      el: '.js-stack-intro'
      title: '.js-copy-title'
      lead: '.js-copy-lead'
      body: '.js-copy-body' 
      
    constructor: (args={}) ->
      console.log('this is in')
      $.extend @config, args
      @$el = $(@config.el)
      @$title = $("#{@config.el} #{@config.title}")
      @$lead = $("#{@config.el} #{@config.lead}")
      @$body = $("#{@config.el} #{@config.body}")
      @init()

    init: ->
      @introContentToggle = new GroupToggle({el: "#{@config.el} .js-group-toggle" })

    update: (args) ->
      @checkContentPresence(args)
      @$title.text(args.title)
      @$lead.text(args.lead)
      @$body.html(args.body)
    
    checkContentPresence: (args) ->
      if args.lead is ''
        @$lead.hide()
      else  
        @$lead.show()

      if args.body is ''
        @introContentToggle.disable()
      else  
        @introContentToggle.enable()

      


