require ['public/assets/javascripts/lib/homepage/prepare_cards.js'], (PrepareCards) ->

  describe 'PrepareCards', ->

    describe 'Object', ->
      it 'is defined', ->
        expect(PrepareCards).toBeDefined()

    describe 'Splitting the cards into slides', ->
      beforeEach ->
        window.cards = new PrepareCards({el: '#js-card-holder'})
        spyOn(window.cards, "getViewPort").andReturn('1000')
        loadFixtures('cards.html')
        cards.constructor({el: '#js-card-holder'})

      it 'creates a slider container with a width of 800px', ->
        expect(window.cards.$el.find('.slider__container').width()).toBe(800)

      it 'should create 3 slides', ->
        expect(window.cards.$el.find('.slider__container').children().length).toBe(3)

      it 'should add two groups to each slide', ->
        expect(window.cards.$el.find('.slider__slide:first').children().length).toBe(2)

      it 'should publish an event to uncomment the images on the first slide', ->
        spyEvent = spyOnEvent(window.cards.$el, ':asset/uncomment')
        cards.constructor({el: '#js-card-holder'})
        expect(':asset/uncomment').toHaveBeenTriggeredOn(window.cards.$el)