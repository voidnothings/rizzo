# 
# Params: @args {
#   selector: {string} parent element,
#   delay: {number} timeout between switching slides,
#   autoHeight: {boolean} True if you want the tabs to determine the height
# }
# 

define ['jquery'], ($) ->
 
  class Tabs

    config = {
      animationDelay: 300
    }
    activeTimeout = null


    constructor: (args) ->

      config.tabs = $(args.selector)
      config.tabsContainer = config.tabs.find('.js-tabs-content')
      config.tabLabels = config.tabs.find('.js-tab-trigger')
      config.animationDelay = args.delay
      config.autoHeight = args.autoHeight?

      config.tabs.on 'click', '.js-tab-trigger', (e) ->
        tabLabel = $(@)
        tab = $(tabLabel.attr('href'))
        _openNewTab(tabLabel, tab)
        false

      config.tabsContainer.removeClass('is-loading')
      $(config.tabLabels.filter(':first').addClass('is-active').attr('href')).addClass('is-active')
    

    # Private Functions

    _openNewTab = (tabLabel, tab) ->
      unless tab.hasClass('is-active')
        
        config.tabsContainer.find('.is-active').removeClass('is-active')
        config.tabLabels.removeClass('is-active')
        tabLabel.addClass('is-active')
      
        # Get padding (jquery box sizing bug - http://bugs.jquery.com/ticket/10413)
        unless config.autoHeight
          padding = (parseInt(tab.css('padding'), 10) * 2)
          config.tabsContainer.css('height', (tab.children().outerHeight() + padding))

        activeTimeout = setTimeout ->
          config.tabsContainer.find(tab).addClass('is-active')
          config.tabsContainer.css('opacity', '1')
          activeTimeout = null
        , config.animationDelay
