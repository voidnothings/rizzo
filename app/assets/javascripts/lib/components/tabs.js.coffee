# 
# Params: @args {
#   selector: parent element
# }
# 

define ['jquery'], ($) ->
 
  class Tabs

    config =
      tabs: ''
      tabsContainer: ''
      tabLabels: ''

    tabsAreHidden = ->
      if config.tabsContainer.is(':hidden') then true else false


    openNewTab = (tabLabel, tab) ->
      config.tabLabels.removeClass('active')
      tabLabel.addClass('active')

      config.tabsContainer.css('opacity', '0').find('.js-tab').removeClass('active')
      if tabsAreHidden() then config.tabsContainer.removeClass('is-hidden')
      
      # Get padding (jquery box sizing bug - http://bugs.jquery.com/ticket/10413)
      padding = (parseInt(tab.css('padding'), 10) * 2)
      config.tabsContainer.css('height', (tab.children().outerHeight() + padding))

      setTimeout ->
        config.tabsContainer.find(tab).addClass('active')
        config.tabsContainer.css('opacity', '1')
      , 300


    closeTabs = ->
      config.tabLabels.removeClass('active')
      config.tabsContainer.addClass('is-hidden').children('.js-tab').removeClass('active')


    bindEvents = (tabs, tabsContainer) =>
      tabs.on 'click', '.js-tab-item', (e) ->
        tabLabel = $(@)
        tab = $(tabLabel.attr('href'))
        if tabLabel.hasClass('active') then closeTabs() else openNewTab(tabLabel, tab)
        false


    switch: (tab) ->
      if typeof(tab) is "number"
        tabLabel = $(config.tabLabels[tab-1])
        tab = $(config.tabsContainer.find('.js-tab')[tab-1])
      else
        tabLabel = config.tabLabels.filter("[href=#{tab}]")
        tab = $(tab)
      
      openNewTab(tabLabel, tab)


    constructor: (selector) ->
      config.tabs = $(selector)
      config.tabsContainer = config.tabs.find('.js-tabs-container')
      config.tabLabels = config.tabs.find('.js-tab-item')
      bindEvents(config.tabs, config.tabsContainer)

