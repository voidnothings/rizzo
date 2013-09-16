define ['jquery', 'jplugs/jquery-cookies.2.2.0'], ($)->

  class ShoppingCart

    @version = '0.0.13'

    constructor: ->
      itemCount = null
      @cartData = $.cookies.get("shopCartCookie")
      if (@cartData && @cartData["A"])
        itemCount = @cartData["A"].length
      if (itemCount)
        $(".js-user-basket").append("<span class=\"user-basket__items icon--small js-basket-items\">#{itemCount}</span>")
