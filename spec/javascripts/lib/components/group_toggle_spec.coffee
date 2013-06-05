require ['public/assets/javascripts/lib/components/group_toggle.js'], (GroupToggle) ->

  describe 'GroupToggle', ->
   
    describe 'Setup', ->

      it 'is defined', ->
        expect(GroupToggle).toBeDefined()

    describe 'default instance', ->    
      
      beforeEach ->
        loadFixtures('stack_intro.html')
        @toggle = new GroupToggle()
      
      it 'has default configuration', ->
        args =
          el: '.js-group-toggle'
          handler: '.js-group-handler'
          content: '.js-group-content'
        expect(@toggle.config).toEqual(args)
      
      it 'extends base configuration', ->
        customArgs =
          el: '.js-group-toggle'
          handler: '.js-group-handler'
          content: '.js-group-content'
        customToggle = new GroupToggle(customArgs)
        expect(customToggle.config).toEqual(customArgs)
    
    describe 'toggling content', ->
      beforeEach ->
        loadFixtures('stack_intro.html')
        args =
          el: '.js-group-toggle'
          handler: '.js-group-handler'
          content: '.js-group-content'
        @$el = $(args.el)
        @$handler = $(args.handler)
        @$content = $(args.content)
        @groupToggle = new GroupToggle(args)

      it 'show content container', ->
        @$handler.trigger('click')
        expect(@$el).toHaveClass('is-open')

      it 'hides content container', ->
        @$handler.trigger('click').trigger('click')
        expect(@$el).toHaveClass('is-close')

    describe 'state', ->
      beforeEach ->
        loadFixtures('stack_intro.html')
        args =
          el: '.js-group-toggle'
          handler: '.js-group-handler'
          content: '.js-group-content'
        @$handler = $(args.handler)
        @$content = $(args.content)
        @groupToggle = new GroupToggle(args)

      it 'disables component', ->
        @groupToggle.disable()
        expect(@$content).toBeHidden()
        expect(@$handler).toBeHidden()

      it 'enables content', ->
        @groupToggle.enable()
        expect(@$content).toBeVisible()
        expect(@$handler).toBeVisible()
