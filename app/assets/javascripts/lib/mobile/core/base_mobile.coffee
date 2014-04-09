define ['jsmin', 'lib/mobile/core/authenticator_mobile','lib/mobile/core/shopping_cart_mobile', 'lib/mobile/select_group_manager_mobile', 'lib/utils/asset_fetch', 'lib/utils/local_store', 'lib/utils/toggle_active'], ($, Authenticator, ShoppingCart, SelectGroupManager, AssetFetch, LocalStore, ToggleActive) ->

  class Base

    constructor: (args={})->
      @showUserBasket()
      @initialiseSelectGroupManager()
      @addNavTracking()
      @scrollPerf() unless window.lp.touch is true
      new ToggleActive

    showUserBasket: ->
      shopCart = new ShoppingCart()

    initialiseSelectGroupManager: ->
      new SelectGroupManager()

    addNavTracking: ->
      $('#js-primary-nav').on 'click', (e)->
        if e.target.hasClass('js-nav-item') then window.s.linkstacker(e.target.innerText)
        if e.target.hasClass('js-nav-cart') then window.s.linkstacker("shopping-cart")

      $('#js-primary-nav').on 'submit', (e)->
        if e.target.hasClass('js-nav-search') then window.s.linkstacker("search")

      $('#js-secondary-nav').on 'click', (e)->
        if e.target.hasClass('js-nav-item') then window.s.linkstacker(e.target.innerText + "-sub")

      $('#js-breadcrumbs').on 'click', (e)->
        if e.target.hasClass('js-nav-item') then window.s.linkstacker("breadcrumbs")

      $('#js-footer-nav').on 'click', (e)->
        if e.target.hasClass('js-nav-item') then window.s.linkstacker("footer")

    scrollPerf: ->
      enableTimer = false

      window.addEventListener 'scroll', ->
        clearTimeout(enableTimer);
        document.documentElement.style.pointerEvents = "none"
        enableTimer = setTimeout ->
          document.documentElement.style.pointerEvents = "auto"
        , 300
      , false
