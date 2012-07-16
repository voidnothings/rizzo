define( ['jquery','lib/melbourne/ad_manager','lib/melbourne/footer', 'lib/utils/asset_fetch', 'lib/melbourne/destination_nav', 'lib/melbourne/authentication', 'lib/melbourne/shopping_cart'], ($, AdManager, Footer, AssetFetch, DestinationNav, Authentication, ShoppingCart) ->

  class MelbourneBase

    constructor: ->
      @config()
      @header()
      @footer()

    config: ->
      @adConf =
        adZone : window.lp.ads.adZone or 'home'
        adKeywords : window.lp.ads.adKeywords or ' '
        tile : lp.ads.tile or ' '
        segQS : lp.ads.segQS or ' '
        mtfIFPath : (lp.ads.mtfIFPath or '/')
        unit: [728,90]

    header: ->
      AdManager.init(@adConf,'ad_masthead')
      
      shopCart = new ShoppingCart()
      AssetFetch.get "http://www.lonelyplanet.com/global-navigation", () ->
        dest = new DestinationNav(jsonNavItems.nav, "nav.primary ul li.destinations")

      lpLoggedInUsername = null
      auth = new Authentication()
      AssetFetch.get "https://secure.lonelyplanet.com/sign-in/status", () ->
        auth.update()

    footer: ->
      Footer.init()


)
