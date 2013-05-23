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
          spyOn(stack, "_replace")
          spyOn(stack, "_show")
          $(stack.config.LISTENER).trigger(':page/received')  

        it 'calls stack._clear', ->
          expect(stack._clear).toHaveBeenCalled()

        it 'calls stack._replace', ->
          expect(stack._replace).toHaveBeenCalledWith(params.list)
      
        it 'calls stack._show', ->
          expect(stack._show).toHaveBeenCalledWith(params.list)

      describe 'clear', ->
        beforeEach ->
          stack._clear()

        it 'clears the stack', ->
          expect($(stack.$el).find(config.types).length).toBe(0)

      describe 'replace', ->
        beforeEach ->
          spyOn(stack, "_show").andReturn(false)
          stack._replace(params.list)

        it 'replaces the stack with the returned cards', ->
          expect($(stack.$el).find(".test4").hasClass('card--invisible')).toBe(true)
          expect($(stack.$el).find(".test5").hasClass('card--invisible')).toBe(true)
          expect($(stack.$el).find(".test6").hasClass('card--invisible')).toBe(true)

      describe 'show', ->
        beforeEach ->
          stack._replace(params.list)

        it 'fades in the returned cards', ->
          expect($(stack.$el).find(".test4").hasClass('card--invisible')).toBe(false)
          expect($(stack.$el).find(".test5").hasClass('card--invisible')).toBe(false)
          expect($(stack.$el).find(".test6").hasClass('card--invisible')).toBe(false)


    describe 'on page append', ->
      beforeEach ->
        loadFixtures('stack.html')
        window.stack = new Stack(config)

      describe 'does not clear down the existing cards', ->
        beforeEach ->
          spyOn(stack, "_replace")
          spyOn(stack, "_show")
          $(stack.config.LISTENER).trigger(':page/append')  

        it 'does not call stack._clear', ->
          expect(stack._clear).not.toHaveBeenCalled()

        it 'calls stack._replace', ->
          expect(stack._replace).toHaveBeenCalledWith(params.list)
      
        it 'calls stack._show', ->
          expect(stack._show).toHaveBeenCalledWith(params.list)

        it 'appends the cards', ->
          expect($(stack.$el).find(config.types).length).not.toBe(0)
