define ['jquery', 'vendor/jquery/plugins/jquery-bgiframe-2.1.3', 'vendor/jquery/plugins/jquery-toggle-class-on-event', 'vendor/jquery/plugins/jquery-tolerant-hover'], ($, _o, _h, _l)->

  class DestinationNav

    constructor: (_fragment, @selector) ->
      @tab = $(@selector)
      return false if (@tab.hasClass('tabNotReady'))
      @append(_fragment)
      @prepare()
      @bindEvents()

    append: (_fragment) ->
      @tab.append(_fragment)
      $("#{@selector + 'span.arrow'}").removeClass('invisible')

    prepare: ->
      opts =
        className: 'highlight'
        event: 'tolerantHover'
        tolerance: 200
        tolerancePredicate: =>
          @tab.find('> .menu:not(.hidden)').length is not 0
        offHover: =>
          @tab.children('ul').addClass('hidden')
      @tab.toggleClassOnEvent(opts)

      @down_arrows = @tab.find('span.arrow')
      @right_arrows = @tab.find('ul.menu > li > .arrow')
      @down_arrows.add(@right_arrows).add(@tab.children('a'))
# 
    bindEvents: ->
      @down_arrows.toggleClassOnEvent({className:'highlight', event:'hover'})
      subMenu = @tab.find('li:has(.submenu)')
      subMenu.bind('mouseenter', (e) =>
        if (@tab.find('.submenu:not(.hidden)').length is 0)
          $(@).addClass('highlight')
      )
      subMenu.bind('mouseleave', (e) =>
        if (@tab.find('.submenu:not(.hidden)').length is 0)
          $(@).removeClass('highlight')
      )
      subMenu.toggleClassOnEvent({className: 'selectable',event: 'hover'})

      @down_arrows.on('click', (e) =>
        e.preventDefault()
        e.stopPropagation()
        @tab.addClass('highlight')
        @tab.children('ul').toggleClass('hidden')
        @tab.find('.submenu').addClass('hidden')
        @tab.find('.menu li').removeClass('highlight')
        userTab = @tab.filter('.userLoggedIn, .currentUserLoggedIn')
        userTab.children('ul').width(userTab.width() - 2)
      )
# 
      @addBgIframe(m) for m in @tab.find('.menu')

    addBgIframe: (_element) ->
      menu = $(_element).bgiframe()
      menuItems = menu.children('li')
      @bindSubMenuEvent(item, menu, menuItems) for item in menuItems
# 
    bindSubMenuEvent: (_item, _menuItems, _menu) ->
      submenu = $(_item).find('.submenu').bgiframe()
      $(_item).on('click', =>
        if submenu.hasClass('hidden')
          $(_menuItems).find('.submenu').addClass('hidden')

          submenu.removeClass('hidden')
          topPadding = 14
          bottomPadding = 7
          currentTop = parseInt(submenu.css('top'), 10) || 0
          submenuTop = Math.floor(($(_item).height() - submenu.height()) / 2) - currentTop
          windowBottomEdge = $(window).scrollTop() + $(window).height()
          submenuOffsetTop = submenu.offset().top
          submenuBottomEdge = submenu.outerHeight() + submenuOffsetTop + submenuTop

          if windowBottomEdge <= (submenuBottomEdge + bottomPadding)
            submenuTop -= (submenuBottomEdge + bottomPadding) - windowBottomEdge

          menuTopEdge = _menu.offset().top
          submenuTopEdge = submenuOffsetTop + submenuTop

          if submenuTopEdge <= (menuTopEdge + topPadding)
            submenuTop += (menuTopEdge + topPadding) - submenuTopEdge
            submenu.css('top', (submenuTop + currentTop) + 'px')
            $(_menuItems).removeClass('highlight')
            $(_item).addClass('highlight')
        else
          $(_menuItems).find('.submenu').addClass('hidden')
      )
     
      $(_item).children('a').add(submenu).on('click',(e)=>
        e.stopPropagation()
      )
