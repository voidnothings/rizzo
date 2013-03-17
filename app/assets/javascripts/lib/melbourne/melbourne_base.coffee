define( ['jquery','lib/melbourne/ad_manager','lib/melbourne/footer', 'lib/utils/asset_fetch', 'lib/melbourne/destination_nav', 'lib/melbourne/authentication', 'lib/melbourne/shopping_cart', 'lib/managers/select_group_manager'], ($, AdManager, Footer, AssetFetch, DestinationNav, Authentication, ShoppingCart, SelectGroup) ->

  class MelbourneBase

    constructor: ->
      @config()
      @header()
      @footer()

    config: ->
      # Needs strong refactoring
      @adConf =
        if window.lp and window.lp.ads
          adZone : window.lp.ads.adZone or 'home'
          adKeywords : window.lp.ads.adKeywords or ' '
          tile : lp.ads.tile or ' '
          segQS : lp.ads.segQS or ' '
          mtfIFPath : (lp.ads.mtfIFPath or '/')
          unit: [728,90]
        else
          adZone : 'home'
          adKeywords : 'europe'
          tile : ' '
          segQS : ' '
          mtfIFPath : '/'
          unit: [728,90]

    header: ->
      AdManager.init(@adConf,'ad_masthead')
      shopCart = new ShoppingCart()
      AssetFetch.get "http://www.lonelyplanet.com/global-navigation", () ->
        if (window.jsonNavItems and (window.jsonNavItems isnt '') and (window.jsonNavItems isnt 'undefined'))
          dest = new DestinationNav(jsonNavItems.nav, "a.nav__item--destinations")
          console.log(dest)

      lpLoggedInUsername = null
      auth = new Authentication()
      AssetFetch.get "https://secure.lonelyplanet.com/sign-in/status", () ->
        auth.update()

    footer: ->
      Footer.init()


)
