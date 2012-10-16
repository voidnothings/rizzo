# 
# Params: @args {
#   parent: parent element
#   multiplePanels: can you have multiple panels open
#   callback: optional function
# }
# 

define ['jquery'], ($) ->
 
  class Accordion

    config =
      multiplePanels: false

    openPanel : (panel) ->
      console.log config.multiplePanels
      if config.multiplePanels is false then @closeAllPanels()
      panel = @sanitisePanel(panel)
      panel.removeClass('is-hidden')

    closePanel : (panel) ->
      panel = @sanitisePanel(panel)
      panel.addClass('is-hidden')

    closeAllPanels : (panels) ->
      @panels.addClass('is-hidden')

    constructor : (args) ->
      config = $.extend config, args
      @parent = $(config.parent)
      @panels = @parent.find('.js-accordion-panel')

      @sanitisePanel = (panel) =>
        if typeof(panel) == 'number'
          $(@panels[panel])
        else
          $(panel)

      @closeAllPanels(@panels)
      config.callback && config.callback(@parent)