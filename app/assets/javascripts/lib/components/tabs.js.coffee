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
          dropdown.css('height', newTab.children().innerHeight())
          
          setTimeout ->
            contentArea.find(tabSelected).addClass('active')
            dropdown.css('opacity', '1')
          , 300
        
        # Stop the page jump
        false

    constructor: (selector) ->
      @parent = $(selector)
      @dropdown = @parent.find('.js-tabs-container')
      bindEvents(@parent, @dropdown)
    
    