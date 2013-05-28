require ['public/assets/javascripts/lib/components/stack.js'], (Stack) ->

  describe 'Stack', ->
    
    config = 
      types: ".test, .test2"

    params =
      list: "<div class='test4'>Four</div><div class='test5'>Four</div><div class='test6'>Four</div>"

    describe 'Setup', ->
      it 'is defined', ->
        expect(Stack).toBeDefined()

      it 'has default options', ->
        expect(Stack::config).toBeDefined()


    describe 'on page request', ->
      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)
        spyOn(stack, "_block")
        $(stack.config.LISTENER).trigger(':page/request')

      it 'calls stack.block', ->
        expect(stack._block).toHaveBeenCalled()

      describe 'blocking', ->
        beforeEach ->
          loadFixtures('stack.html')
          window.stack = new Stack(config)
          $(stack.config.LISTENER).trigger(':page/request')

        it 'adds disabled classes to the stack', ->
          expect($(stack.$el).find(config.types).hasClass('card--disabled')).toBe(true)


    describe 'on page received', ->
      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)

      describe 'it calls', ->
        beforeEach ->
          spyOn(stack, "_clear")
          spyOn(stack, "_add")
          $(stack.config.LISTENER).trigger(':page/received', params)  

        it 'calls stack._clear', ->
          expect(stack._clear).toHaveBeenCalled()

        it 'calls stack._add', ->
          expect(stack._add).toHaveBeenCalledWith(params.list)


      describe 'clear', ->
        beforeEach ->
          stack._clear()

        it 'clears the stack', ->
          expect($(stack.$el).find(config.types).length).toBe(0)

      describe 'add()', ->
        beforeEach ->
          spyOn(stack, "_show")
          stack._add(params.list)

        it 'adds the stack with the returned cards', ->
          expect($(stack.$el).find(".test4").hasClass('card--invisible')).toBe(true)
          expect($(stack.$el).find(".test5").hasClass('card--invisible')).toBe(true)
          expect($(stack.$el).find(".test6").hasClass('card--invisible')).toBe(true)

        it 'shows the cards', ->
          expect(stack._show).toHaveBeenCalled()


    describe 'on page append', ->
      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)

      describe 'does not clear down the existing cards', ->
        beforeEach ->
          spyOn(stack, "_clear")
          spyOn(stack, "_add")
          $(stack.config.LISTENER).trigger(':page/append', params)  

        it 'does not call stack._clear', ->
          expect(stack._clear).not.toHaveBeenCalled()

        it 'calls stack._add', ->
          expect(stack._add).toHaveBeenCalledWith(params.list)

        it 'appends the cards', ->
          expect($(stack.$el).find(config.types).length).not.toBe(0)


    describe 'when the user clicks a disabled card', ->
      beforeEach ->
        loadFixtures('stack_disabled.html')
        window.stack = new Stack(config)

      it 'triggers the info/change event', ->
        spyEvent = spyOnEvent(stack.$el, ':info/show');
        stack.$el.find('.card--disabled a').trigger('click')
        expect(':info/show').toHaveBeenTriggeredOn(stack.$el)


    describe 'when the user clicks a filter card', ->
      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)

      it 'triggers the :page/request event with the correct params', ->
        spyEvent = spyOnEvent(stack.$el, ':page/request');
        filterCard = stack.$el.find('.js-stack-card-filter')
        anchor = filterCard.find('a')
        params =
          url: anchor.attr('href')
          external_filter:
            filter: anchor.attr('data-filter')
            stack: anchor.attr('data-stack-kind')

        filterCard.trigger('click')
        expect(':page/request').toHaveBeenTriggeredOnAndWith(stack.$el, params)




