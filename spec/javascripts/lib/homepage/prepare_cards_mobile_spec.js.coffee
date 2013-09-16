require ['public/assets/javascripts/lib/homepage/prepare_cards_mobile.js'], (PrepareCardsMobile) ->

  describe 'PrepareCardsMobile', ->

    describe 'Object', ->
      it 'is defined', ->
        expect(PrepareCardsMobile).toBeDefined()

    describe 'Small screen', ->
      beforeEach ->
        window.cards = new PrepareCardsMobile({el: '#js-card-holder'})
        spyOn(window.cards, "getViewPort").andReturn('400')
        spyOn(window.cards, "_loadImages")
        loadFixtures('cards.html')
        cards.constructor({el: '#js-card-holder'})

      it 'loads the first 1025px of images', ->
        expect(window.cards.firstCards.length).toBe(3)
        expect(window.cards._loadImages).toHaveBeenCalledWith(window.cards.firstCards)


    describe 'Tablet', ->
      beforeEach ->
        window.cards = new PrepareCardsMobile({el: '#js-card-holder'})
        spyOn(window.cards, "getViewPort").andReturn('1000')
        spyOn(window.cards, "_loadImages")
        loadFixtures('cards.html')
        cards.constructor({el: '#js-card-holder'})

      it 'loads the first 1025px of images', ->
        expect(window.cards.firstCards.length).toBe(4)
        expect(window.cards._loadImages).toHaveBeenCalledWith(window.cards.firstCards)


    describe 'On Scroll', ->
      beforeEach ->
        window.cards = new PrepareCardsMobile({el: '#js-card-holder'})
        spyOn(window.cards, "_loadImages")
        loadFixtures('cards.html')
        cards.constructor({el: '#js-card-holder'})

      it 'loads all the images', ->
        cards.$el.trigger('scroll')
        expect(cards._loadImages).toHaveBeenCalledWith(window.cards.$cards)

