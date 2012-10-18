# 
# Params: @args {
#   parent: parent element
#   multiplePanels: can you have multiple panels open
#   callback: optional function
#   activeClass: optional args
#     elem: element to add/remove the class
#     className: classname to add/remove
# }
# 

define ['jquery'], ($) ->
 
  class Accordion

    config =
      multiplePanels: false

    openPanel : (panel) ->
      if config.multiplePanels is false then @closeAllPanels()
      panel = @sanitisePanel(panel)
      panel.removeClass('is-hidden')
      if config.hasOwnProperty('activeClass')
        panel.closest(config.activeClass.elem).addClass(config.activeClass.className)

    closePanel : (panel) ->
      panel = @sanitisePanel(panel)
      panel.addClass('is-hidden')
      if config.hasOwnProperty('activeClass')
        panel.closest(config.activeClass.elem).removeClass(config.activeClass.className)

    closeAllPanels : (panels) ->
      @panels.addClass('is-hidden')
      if config.hasOwnProperty('activeClass')
        @parent.find(config.activeClass.elem).removeClass(config.activeClass.className)

    refresh : () ->
      @panels = @parent.find('.js-accordion-panel')
      @closeAllPanels(@panels)

    constructor : (args) ->
      config = $.extend config, args
      window.x = config
      @parent = $(config.parent)
      @panels = @parent.find('.js-accordion-panel')

      @sanitisePanel = (panel) =>
        if typeof(panel) == 'number'
          $(@panels[panel])
        else
          $(panel)

      @closeAllPanels(@panels)
      config.callback && config.callback(@parent)