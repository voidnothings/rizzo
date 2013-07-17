# 
# Params: @args {
#   selector: {string} parent element,
#   delay: {number} timeout between switching slides,
# }
# 

define [], ->
 
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

      config.tabs.addEventListener 'click', (e) ->
        e.preventDefault()
        tabLabel = e.target.parentNode
        tab = document.getElementById(tabLabel.hash.substr(1))
        _openNewTab(tabLabel, tab)
        false

      config.tabsContainer.classList.remove('is-loading')
      firstElement = config.tabLabels[0]
      firstElement.classList.add('is-active')
      document.getElementById(firstElement.hash.substr(1)).classList.add('is-active')
    

    # Private Functions

    _openNewTab = (tabLabel, tab) ->

      unless ((" " + tab.className + " ").replace(/[\n\t]/g, " ").indexOf('is-active') > -1)

        config.tabsContainer.getElementsByClassName('is-active')[0].classList.remove('is-active')
        for label in config.tabLabels
          label.classList.remove('is-active')
        
        tabLabel.classList.add('is-active')

        activeTimeout = setTimeout ->
          tab.classList.add('is-active')
          config.tabsContainer.style.opacity = 1
          activeTimeout = null
        , config.animationDelay
