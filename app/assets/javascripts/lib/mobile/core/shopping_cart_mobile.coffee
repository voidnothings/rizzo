define ['jsmin'], ($)->

  class ShoppingCart

    @version = '0.0.13'

    constructor: ->
      @cartData = @_getShopCookie()
      if (@cartData && !!@cartData["A"]) then @_showItemCount(@cartData["A"])

    _showItemCount: (items)->
      $(".js-user-basket").innerHTML += "<span class=\"user-basket__items icon--small js-basket-items\">#{items.length}</span>"

    _getShopCookie: ->
      JSON.parse($.cookies.get("shopCartCookie"))
