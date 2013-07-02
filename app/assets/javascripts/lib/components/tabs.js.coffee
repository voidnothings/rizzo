# 
# Params: @args {
#   selector: parent element
# }
# 

define ['jquery'], ($) ->
 
  class Tabs

    config = {
      animationDelay: 300
    }
    activeTimeout = null


    constructor: (selector, delay, autoHeight) ->
      config.tabs = $(selector)
      config.tabsContainer = config.tabs.find('.js-tabs-content')
      config.tabLabels = config.tabs.find('.js-tab-trigger')
      config.animationDelay = delay
      config.autoHeight = autoHeight?

      config.tabs.on 'click', '.js-tab-trigger', (e) ->
        tabLabel = $(@)
        tab = $(tabLabel.attr('href'))
        Tabs::_closeTabs()

        _openNewTab(tabLabel, tab)
        e.preventDefault()

      config.tabsContainer.removeClass('is-loading')
      $(config.tabLabels.filter(':first').addClass('is-active').attr('href')).addClass('is-active')
    

    # Private Functions

    _openNewTab = (tabLabel, tab) ->
      unless tab.hasClass('is-active')
        config.tabLabels.removeClass('is-active')
        tabLabel.addClass('is-active')

        config.tabsContainer.find('.js-tab-panel').removeClass('is-active')
        if _tabsAreHidden() then config.tabsContainer.removeClass('is-hidden')
      
        # Get padding (jquery box sizing bug - http://bugs.jquery.com/ticket/10413)
        padding = (parseInt(tab.css('padding'), 10) * 2)
        unless config.autoHeight
          config.tabsContainer.css('height', (tab.children().outerHeight() + padding))

        activeTimeout = setTimeout ->
          config.tabsContainer.find(tab).addClass('is-active')
          config.tabsContainer.css('opacity', '1')
          activeTimeout = null
        , config.animationDelay

    _closeTabs : ->
      config.tabLabels.each ->
        config.tabsContainer.find('.is-active').removeClass('is-active')
    
    _tabsAreHidden = ->
      if config.tabsContainer.is(':hidden') then true else false
