require ['public/assets/javascripts/lib/components/cards.js'], (Cards) ->

  describe 'Cards', ->
    
    params = 
      types: ".test, .test2"

    describe 'Setup', ->
      it 'is defined', ->
        expect(Cards).toBeDefined()

      it 'has default options', ->
        expect(Cards::config).toBeDefined()


    describe 'on page request', ->
      beforeEach ->
        loadFixtures('cards.html')
        window.cards = new Cards(params)
        spyOn(cards, "_block")
        $(cards.config.LISTENER).trigger(':page/request')

      it 'disables the cards', ->
        expect(cards._block).toHaveBeenCalled()


    describe 'blocking', ->
      beforeEach ->
        loadFixtures('cards.html')
        window.cards = new Cards(params)
        $(cards.config.LISTENER).trigger(':page/request')

      it 'adds disabled classes to the cards', ->
        expect($(cards.$el).find(params.types).hasClass('card--disabled')).toBe(true)


    describe 'on page request', ->
      beforeEach ->
        loadFixtures('cards.html')
        window.cards = new Cards(params)
        spyOn(cards, "_unblock")
        $(cards.config.LISTENER).trigger(':page/received')

      it 'disables the cards', ->
        expect(cards._unblock).toHaveBeenCalled()


    describe 'unblocking', ->
      beforeEach ->
        loadFixtures('cards.html')
        window.cards = new Cards(params)
        $(cards.config.LISTENER).trigger(':page/received')

      it 'removes disabled classes from the cards', ->
        expect($(cards.$el).find(params.types).hasClass('card--disabled')).toBe(false)