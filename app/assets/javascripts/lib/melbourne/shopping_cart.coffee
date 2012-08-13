define ['jquery', 'jplugs/jquery-cookies.2.2.0'], ($)->

  class ShoppingCart

    constructor: ->
      itemCount = 0
      cartData = $.cookies.get("shopCartCookie")
      if (cartData is not null) and (cartData.A is not undefined)
        itemCount = cartData.A.length
      $("nav.primary ul li.globalCartHead a").html("Cart: " + itemCount)
