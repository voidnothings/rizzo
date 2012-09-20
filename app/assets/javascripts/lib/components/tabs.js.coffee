# 
# Params: @args {
#   selector: parent element
# }
# 

define ['jquery'], ($) ->
 
  class Tabs
    
    bindEvents = (tabs, dropdown) =>
      tabs.on 'click', '.js-tab-item', (e) ->

        tabLink = $(@)
        tabSelected = tabLink.attr('href')
        contentArea = tabs.find('.js-tabs-container')
        
        # Closing the tabs completely
        if tabLink.hasClass('active')
          tabLink.removeClass('active')
          dropdown.hide()
          Tabs.isHidden = true
          contentArea.find(tabSelected).removeClass('active')
          
        else
          if Tabs.isHidden then dropdown.show()

          tabs.find('.js-tab-item').removeClass('active')
          tabLink.addClass('active')

          # Remove the active tabs
          dropdown.css('opacity', '0')
          contentArea.find('.js-tab').removeClass('active')
          
          # Set the new height
          newTab = contentArea.find(tabSelected)
          
          # Get padding (jquery box sizing bug - http://bugs.jquery.com/ticket/10413)
          padding = (parseInt(newTab.css('padding'), 10) * 2)
          
          # dropdown.css('height', (newTab.children().outerHeight() + padding))
          
          # setTimeout ->
          #   contentArea.find(tabSelected).addClass('active')
          #   dropdown.css('opacity', '1')
          # , 300
          
          setTimeout ->
            contentArea.find(tabSelected).addClass('active')
            dropdown.css('opacity', '1')
          , 1
        
        # Stop the page jump
        false

    constructor: (selector) ->
      @parent = $(selector)
      @dropdown = @parent.find('.js-tabs-container')
      bindEvents(@parent, @dropdown)
    
    
