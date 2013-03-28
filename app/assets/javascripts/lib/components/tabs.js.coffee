# 
# Params: @args {
#   selector: parent element
# }
# 

define ['jquery'], ($) ->
 
  class Tabs

    config = {}
    activeTimeout = null

    tabsAreHidden = ->
      if config.tabsContainer.is(':hidden') then true else false

    openNewTab = (tabLabel, tab) ->
      unless tab.hasClass('is-active')
        config.tabLabels.removeClass('is-active')
        tabLabel.addClass('is-active')

        config.tabsContainer.css('opacity', '0').find('.js-tab-panel').removeClass('is-active')
        if tabsAreHidden() then config.tabsContainer.removeClass('is-hidden')
      
        # Get padding (jquery box sizing bug - http://bugs.jquery.com/ticket/10413)
        padding = (parseInt(tab.css('padding'), 10) * 2)
        config.tabsContainer.css('height', (tab.children().outerHeight() + padding))

        activeTimeout = setTimeout ->
          config.tabsContainer.find(tab).addClass('is-active')
          config.tabsContainer.css('opacity', '1')
          activeTimeout = null
        , 300


    bindEvents = (tabs, tabsContainer) =>
      tabs.on 'click', '.js-tab-trigger', (e) ->
        tabLabel = $(@)
        tab = $(tabLabel.attr('href'))
        if tabLabel.hasClass('is-active') then Tabs::closeTabs() else openNewTab(tabLabel, tab)
        false


    closeTabs : ->
      clearTimeout(activeTimeout) if activeTimeout
      config.tabLabels.removeClass('is-active')
      config.tabsContainer.addClass('is-hidden').children('.js-tab-panel').removeClass('is-active')


    switch: (tab) ->
      tabLabel = config.tabLabels.filter("[href=#{tab}]")
      tab = $(tab)
      openNewTab(tabLabel, tab)


    constructor: (selector) ->
      config.tabs = $(selector)
      config.tabsContainer = config.tabs.find('.js-tabs-content')
      config.tabLabels = config.tabs.find('.js-tab-trigger')
      bindEvents(config.tabs, config.tabsContainer)

