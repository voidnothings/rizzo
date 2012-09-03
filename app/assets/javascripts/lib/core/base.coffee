define( ['jquery','lib/core/ad_manager','lib/utils/asset_fetch', 'lib/core/authentication', 'lib/core/shopping_cart'], ($, AdManager, AssetFetch, Authentication, ShoppingCart) ->

  class Base

    constructor: ->
      @config()
      @userBox()
      @userBasket()
      @adLeaderboard()

    config: ->
      @adConf =
        adZone : window.lp.ads.adZone or 'home'
        adKeywords : window.lp.ads.adKeywords or ' '
        tile : lp.ads.tile or ' '
        segQS : lp.ads.segQS or ' '
        mtfIFPath : (lp.ads.mtfIFPath or '/')
        unit: [728,90]
      
    userBox: ->
      lpLoggedInUsername = null
      auth = new Authentication()
      AssetFetch.get "https://secure.lonelyplanet.com/sign-in/status", () ->
        auth.update()

    adLeaderboard: ->
      AdManager.init(@adConf,'ad_leaderboard')

    userBasket: ->
      shopCart = new ShoppingCart()

)
