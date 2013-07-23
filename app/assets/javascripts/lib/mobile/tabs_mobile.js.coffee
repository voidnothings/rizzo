# 
# Params: @args {
#   selector: {string} parent element,
#   delay: {number} timeout between switching slides,
# }
# 

define ['jquerymin'], ($)->
 
  class Tabs
    config = {
      animationDelay: 300
    }
    activeTimeout = null


    constructor: (args) ->

      config.tabs = document.querySelector(args.selector)
      config.tabsContainer = config.tabs.getElementsByClassName('js-tabs-content')[0]
      config.tabLabels = config.tabs.getElementsByClassName('js-tab-trigger')
      config.animationDelay = args.delay

      config.tabs.on 'click', (e) ->
        e.preventDefault()
        tabLabel = e.target
        tabLabel = if (_hasClass(tabLabel, "js-tab-trigger")) then e.target else e.target.parentNode
        tab = document.getElementById(tabLabel.hash.substr(1))
        _openNewTab(tabLabel, tab)
      , false

      config.tabsContainer.classList.remove('is-loading')
      firstElement = config.tabLabels[0]
      firstElement.classList.add('is-active')
      document.getElementById(firstElement.hash.substr(1)).classList.add('is-active')
    

    # Private Functions

    _hasClass = (element, klass) ->
      if ((" " + element.className + " ").replace(/[\n\t]/g, " ").indexOf(klass) > -1) then true else false

    _openNewTab = (tabLabel, tab) ->
      unless _hasClass(tab, "is-active")

        config.tabsContainer.getElementsByClassName('is-active')[0].classList.remove('is-active')
        for label in config.tabLabels
          label.classList.remove('is-active')
        
        tabLabel.classList.add('is-active')

        activeTimeout = setTimeout ->
          tab.classList.add('is-active')
          config.tabsContainer.style.opacity = 1
          activeTimeout = null
        , config.animationDelay
