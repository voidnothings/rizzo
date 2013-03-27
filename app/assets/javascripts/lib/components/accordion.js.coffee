# 
# Params: @args {
#   parent: parent element
#   multiplePanels: can you have multiple panels open
#   callback: optional function
#   animateHeights: boolean
#   openHeight: optional open height - assumed to outer height of panel if not specified
#   closedHeight: optional closed height - assumed to outer height of panel if not specified
# }
# 

define ['jquery'], ($) ->
 
  class Accordion

    config =
      multiplePanels: false
      animateHeights: false
      openPadding: 0

    prepare : (panels) ->
      panels.each ->
        closedHeight = if config.height then config.height else $(@).find('.js-accordion-trigger').outerHeight()
        openHeight = if config.openHeight then config.openHeight else closedHeight + $(@).find('.js-accordion-panel').outerHeight() + config.openPadding
        $(@).attr('data-open', openHeight).attr('data-closed', closedHeight)

    bindEvents : (parent) ->
      that = @
      parent.on 'click', '.js-accordion-trigger', ->
        panel = $(@).closest('.js-accordion-item').index()
        that.openPanel(panel)
        false

    openPanel : (panel) ->
      panel = @sanitisePanel(panel)
      if panel.hasClass('is-open')
          @closePanel(panel)
      else
        if config.multiplePanels is false then @closeAllPanels()
        panel.removeClass('is-closed').addClass('is-open')
        if config.animateHeights then panel.height(panel.attr('data-open'))

    closePanel : (panel) ->
      panel = @sanitisePanel(panel)
      panel.removeClass('is-open').addClass('is-closed')
      if config.animateHeights then panel.height(panel.attr('data-closed'))

    closeAllPanels : (panels) ->
      @panels.removeClass('is-open').addClass('is-closed')
      if config.animateHeights
        @panels.each ->
          $(@).height($(@).attr('data-closed'))

    refresh : () ->
      @panels = @parent.find('.js-accordion-item')
      if config.animateHeights then @prepare(@panels)
      @closeAllPanels(@panels)

    sanitisePanel : (panel) =>
      if typeof(panel) == 'number'
        $(@panels[panel])
      else if panel.jquery isnt undefined
        panel
      else
        $(panel)

    constructor : (args) ->
      config = $.extend config, args
      @parent = $(config.parent)
      @panels = @parent.find('.js-accordion-item')
      if config.animateHeights then @prepare(@panels)
      @bindEvents(@parent)
      @closeAllPanels(@panels)
      config.callback && config.callback(@parent)
