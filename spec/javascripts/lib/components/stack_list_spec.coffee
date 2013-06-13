require ['public/assets/javascripts/lib/components/stack_list.js'], (StackList) ->

  describe 'StackList', ->

    config = 
      el: '#js-stack-list-aside', 
      list: '.js-neighbourhood-item,.js-facet,.js-descendant-item,.js-stack-collection'

    describe 'Object', ->
      it 'is defined', ->
        expect(StackList).toBeDefined()

      it 'has default options', ->
        expect(StackList::config).toBeDefined()


    describe 'when the user clicks on a stack', ->
      beforeEach ->
        loadFixtures('stack_list.html')
        window.stackList = new StackList(config)

      it 'sets the nav item as current', ->
        element = stackList.$el.find('.js-neighbourhood-item')
        element.trigger('click')
        expect(element).toHaveClass('nav__item--current--stack')
        expect($('.js-facet')).not.toHaveClass('nav__item--current--stack')

      it 'triggers the page request event', ->
        element = stackList.$el.find('.js-neighbourhood-item')
        params = {url: element.attr('href')}
        spyEvent = spyOnEvent(stackList.$el, ':page/request');
        
        element.trigger('click')
        expect(':page/request').toHaveBeenTriggeredOnAndWith(stackList.$el, params)