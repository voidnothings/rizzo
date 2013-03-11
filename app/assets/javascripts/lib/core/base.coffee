define( ['jquery','lib/core/ad_manager','lib/utils/asset_fetch', 'lib/core/authenticator','lib/core/shopping_cart', 'lib/core/msg', 'lib/utils/local_store', 'lib/managers/select_group_manager'], ($, AdManager, AssetFetch, Authenticator, ShoppingCart, Msg, LocalStore, SelectGroup) ->

  class Base

    constructor: (args={})->
      @authenticateUser()
      @showUserBasket()
      @showLeaderboard() if !args.secure
      @showCookieComplianceMsg()
      @initialiseFooterSelects()
      @addNavTracking()

    adConfig: ->
      # defaults to window.lp (needs code refactoring)
      if window.lp and window.lp.ads
        adZone : window.lp.ads.adZone or 'home'
        adKeywords : window.lp.ads.adKeywords or ' '
        tile : lp.ads.tile or ' '
        segQS : lp.ads.segQS or ' '
        mtfIFPath : (lp.ads.mtfIFPath or '/')
        unit: [728,90]
      else   
        adZone : window.adZone or 'home'
        adKeywords : window.adKeywords  or ' '
        tile : window.tile or ' '
        segQS : window.segQS or ' '
        mtfIFPath : '/'
        unit: [728,90]
      
    authenticateUser: ->
      @auth = new Authenticator()
      AssetFetch.get "https://secure.lonelyplanet.com/sign-in/status", () =>
        @auth.update()

    showLeaderboard: ->
      AdManager.init(@adConfig(), 'ad-leaderboard')

    showUserBasket: ->
      shopCart = new ShoppingCart()

    initialiseFooterSelects: ->
      countrySelect = new SelectGroup '.js-select-country'
      languageSelect = new SelectGroup '.js-select-language', ->
        $('#js-language').submit()

    showCookieComplianceMsg: ->
      if LocalStore.get('cookie-compliance') is undefined or LocalStore.get('cookie-compliance') is null
        args = 
          content: "<p><strong>Hi there. We use cookies to improve your experience on our website. </strong><strong><a href='/legal/cookies'>Find out more about how we use cookies.</a></strong></p><p>You can update your settings by clic)king the <strong><a href='/legal/cookies'>Cookie Policy</a></strong> link which can be found anytime at the bottom of the page.</p>"
          style: "row--cookie-compliance js-cookie-compliance"
          delegate: 
            onRemove : -> 
              $('div.js-cookie-compliance').removeClass('row--cookie-compliance--open')
              $('div.js-cookie-compliance').addClass('row--cookie-compliance--close')
            onAdd : -> 
              window.setTimeout( ( => $('div.js-cookie-compliance').addClass('row--cookie-compliance--open')), 1)
        msg = new Msg(args)
        LocalStore.set('cookie-compliance', true)

    addNavTracking: ->
      $('#js-primary-nav').on 'click', '.js-nav-item', ->
        window.s.linkstacker($(this).text())

      $('#js-primary-nav').on 'click', '.js-nav-cart', ->
        window.s.linkstacker("shopping-cart")

      $('#js-primary-nav').on 'submit', '.js-nav-search', ->
        window.s.linkstacker("search")

      $('#js-secondary-nav').on 'click', '.js-nav-item', ->
        window.s.linkstacker($(this).text() + "-sub")

      $('#js-breadcrumbs').on 'click', '.js-nav-item', ->
        window.s.linkstacker("breadcrumbs")

      $('#js-footer-nav').on 'click', '.js-nav-item', ->
        window.s.linkstacker("footer")

)
