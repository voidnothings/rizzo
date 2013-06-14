require ['public/assets/javascripts/lib/components/stack.js'], (Stack) ->

  describe 'Stack', ->
    
    config = 
      types: ".test, .test2, .js-error"
      allTypes: ".test, .test2, .js-error, .js-stack-card-filter"
      el: '#js-results'

    params =
      content: "<div class='test4'>Four</div><div class='test5'>Four</div><div class='test6'>Four</div>"

    describe 'Object', ->
      it 'is defined', ->
        expect(Stack).toBeDefined()

      it 'has default options', ->
        expect(Stack::config).toBeDefined()


    describe 'Initialising', ->
      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack({ el: '.foo'})
        spyOn(stack, "init")

      it 'When the parent element does not exist it does not initialise', ->
        expect(stack.init).not.toHaveBeenCalled()


    # --------------------------------------------------------------------------
    # Private Methods
    # --------------------------------------------------------------------------

    describe 'addLoader', ->

      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)
        stack._addLoader()

      it 'adds the loading spinner', ->
        expect(stack.$el).toHaveClass('is-loading')


    describe 'removeLoader', ->

      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)
        stack.$el.addClass('is-loading')
        stack._removeLoader()

      it 'removes the loading spinner', ->
        expect(stack.$el).not.toHaveClass('is-loading')


    describe 'blocking', ->

      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)
        stack._block()

      it 'adds the disabled class', ->
        expect(stack.$el.find(stack.config.types)).toHaveClass('card--disabled')


    describe 'unblocking', ->

      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)
        stack.$el.find(stack.config.types).addClass('card--disabled')
        stack._unblock()

      it 'clears the stack', ->
        expect(stack.$el.find(stack.config.types)).not.toHaveClass('card--disabled')


    describe 'clearing', ->

      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)

      it 'removes the cards but keeps the filters', ->
        stack._clear(true)
        expect($(stack.$el).find(config.types).length).toBe(0)
        expect($(stack.$el).find(config.allTypes).length).not.toBe(0)

      it 'removes the cards and the filters', ->
        stack._clear(false)
        expect($(stack.$el).find(config.types).length).toBe(0)
        expect($(stack.$el).find(config.allTypes).length).toBe(0)

      it 'removes any error messages', ->
        stack._clear(true)
        expect($(stack.$el).find(".js-error").length).toBe(0)


    describe 'adding', ->

      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)
        spyOn(stack, "_show")
        stack._add(params.content)


      it 'adds the stack with the returned cards', ->
        expect($(stack.$el).find(".test4")).toHaveClass('card--invisible')
        expect($(stack.$el).find(".test5")).toHaveClass('card--invisible')
        expect($(stack.$el).find(".test6")).toHaveClass('card--invisible')

      it 'shows the cards', ->
        expect(stack._show).toHaveBeenCalled()



    # --------------------------------------------------------------------------
    # Events API
    # --------------------------------------------------------------------------

    describe 'on cards request', ->
      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)
        spyOn(stack, "_addLoader")
        spyOn(stack, "_block")
        $(stack.config.LISTENER).trigger(':cards/request')

      it 'calls stack.addLoader', ->
        expect(stack._addLoader).toHaveBeenCalled()

      it 'calls stack.block', ->
        expect(stack._block).toHaveBeenCalled()


    describe 'on cards received', ->
      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)

      describe 'it calls', ->
        beforeEach ->
          spyOn(stack, "_removeLoader")
          spyOn(stack, "_clear")
          spyOn(stack, "_add")
          $(stack.config.LISTENER).trigger(':cards/received', params)  

        it 'calls stack._removeLoader', ->
          expect(stack._removeLoader).toHaveBeenCalled()

        it 'calls stack._clear', ->
          expect(stack._clear).toHaveBeenCalled()

        it 'calls stack._add', ->
          expect(stack._add).toHaveBeenCalledWith(params.content)


    describe 'on page append', ->
      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)

      describe 'does not clear down the existing cards', ->
        beforeEach ->
          spyOn(stack, "_clear")
          spyOn(stack, "_add")
          $(stack.config.LISTENER).trigger(':cards/append/received', params)  

        it 'does not call stack._clear', ->
          expect(stack._clear).not.toHaveBeenCalled()

        it 'calls stack._add', ->
          expect(stack._add).toHaveBeenCalledWith(params.content)


    describe 'when the user clicks a disabled card', ->
      beforeEach ->
        loadFixtures('stack_disabled.html')
        window.stack = new Stack(config)
        spyEvent = spyOnEvent(stack.$el, ':search/hide')
        stack.$el.find('.card--disabled').trigger('click')

      it 'triggers the search/hide event', ->
        expect(':search/hide').toHaveBeenTriggeredOn(stack.$el)


    describe 'when the user wants to clear all filters', ->
      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)
        spyEvent = spyOnEvent(stack.$el, ':filter/reset')
        stack.$el.find('.js-clear-all-filters').trigger('click')

      it 'triggers the filter/reset event', ->
        expect(':filter/reset').toHaveBeenTriggeredOn(stack.$el)


    describe 'when the user clicks to adjust their dates', ->
      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)
        spyEvent = spyOnEvent(stack.$el, ':search/change')
        stack.$el.find('.js-adjust-dates').trigger('click')

      it 'triggers the search/change event', ->
        expect(':search/change').toHaveBeenTriggeredOn(stack.$el)





