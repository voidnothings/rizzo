require ['public/assets/javascripts/lib/mobile/core/shopping_cart_mobile.js'], (ShoppingCart) ->

  describe 'ShoppingCart', ->

    describe 'Object', ->
      it 'is defined', ->
        expect(ShoppingCart).toBeDefined()

    describe 'An empty basket', ->
      beforeEach ->
        cart = new ShoppingCart()
        spyOn(cart, "_getShopCookie").andReturn('')
        loadFixtures('userBox.html')
        cart.constructor()

      it 'does not add any items count to the page', ->
        expect(document.querySelectorAll('.user-basket__items').length).toBe(0)

    describe 'A basket with one item', ->
      beforeEach ->
        cart = new ShoppingCart()
        spyOn(cart, "_getShopCookie").andReturn({"A":["5904"]})
        loadFixtures('userBox.html')
        cart.constructor()

      it 'adds an items count to the page', ->
        node = document.querySelectorAll('.user-basket__items')
        expect(node.length).toBe(1)

      it 'and the item count is 1', ->
        node = document.querySelector('.user-basket__items')
        expect(node.innerHTML).toBe("1")


    describe 'A basket with five items', ->
      beforeEach ->
        cart = new ShoppingCart()
        spyOn(cart, "_getShopCookie").andReturn({"D": "FOO", "A":["1", "2", "3", "4", "5"]})
        loadFixtures('userBox.html')
        cart.constructor()

      it 'and the item count is 5', ->
        node = document.querySelector('.user-basket__items')
        expect(node.innerHTML).toBe("5")

