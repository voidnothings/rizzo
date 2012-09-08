define( ['jquery','lib/core/ad_manager','lib/utils/asset_fetch', 'lib/core/authenticator','lib/core/shopping_cart'], ($, AdManager, AssetFetch, Authenticator, ShoppingCart) ->

  class Base

    constructor: ->
      @authenticateUser()
      @showUserBasket()
      @showLeaderboard()
      @manageSearchBoxExpand() 

    adConfig: ->
      adZone : window.lp.ads.adZone or 'home'
      adKeywords : window.lp.ads.adKeywords or ' '
      tile : lp.ads.tile or ' '
      segQS : lp.ads.segQS or ' '
      mtfIFPath : (lp.ads.mtfIFPath or '/')
      unit: [728,90]
      
    authenticateUser: ->
      @auth = new Authenticator()
      AssetFetch.get "https://secure.lonelyplanet.com/sign-in/status", () =>
        @auth.update()

    showLeaderboard: ->
      if window.lp and window.lp.ads 
        AdManager.init(@adConfig(),'ad_leaderboard')

    showUserBasket: ->
      shopCart = new ShoppingCart()

    manageSearchBoxExpand: ->
      $('input.js-global-search').on('focus', =>
        if !@auth.userSignedIn()
          $('a.user-basket').toggleClass('is-invisible')
      )
      $('input.js-global-search').on('blur', =>
        if !@auth.userSignedIn()
          $('a.user-basket').toggleClass('is-invisible')
      )

)
