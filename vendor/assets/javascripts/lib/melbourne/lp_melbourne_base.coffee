_dep = [
  'jquery'
  'melbourne/ad_manager'
  'melbourne/lp_footer'
  'melbourne/lp_breadcrumbs'
  'lib/utils/lp_asset_fetch'
  'melbourne/lp_destination_nav'
  'melbourne/lp_authentication'
  'melbourne/lp_shopping_cart'
]

define(_dep, ($, AdManager, Footer, Breadcrumbs, AssetFetch, DestinationNav, Authentication, ShoppingCart) ->

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
      # Breadcrumbs.init("/assets/breadcrumbs.html?destId=357884")
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
