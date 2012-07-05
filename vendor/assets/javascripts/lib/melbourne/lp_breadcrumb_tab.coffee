define ['jquery'], ($)->

  class BreadcrumbTab

    constructor: (_target, _breadcrumbBar) ->
      @tab = $(_target)
      @span = @tab.children('span')
      @arrowLink = @span.children('a.dropDown')
      @arrow = @arrowLink.children('img.arrow')
      @dropDown = @tab.children('ul')
      @tab.on('hover', (=> @over()), (=>_breadcrumbBar.resetAll()))
      @dropDown.on('hover', (=> @dropDownOver()), (=> _breadcrumbBar.resetAll()))
      @arrowLink.on('hover', (=> @arrowOver()), (=> @arrowOut()))
      @arrowLink.on('click', ((e)=> @toggleDropDown(); e.preventDefault()))

    over: ->
      @highlight(@tab)

    dropDownOver: ->
      @highlight(@tab)
      @showDropDown()

    toggleDropDown: ->
      if @isDropDownVisible() then @hideDropDown() else @showDropDown()

    arrowOver: ->
      @highlight(@arrow)

    arrowOut: ->
      @removeHighlight(@arrow)

    reset: ->
      @removeHighlight(@tab)
      @hideDropDown()

    highlight: (_element)->
      _element.addClass('over')

    removeHighlight: (_element)->
      _element.removeClass('over')

    isDropDownVisible: ->
      @dropDown.hasClass('onScreen')

    showDropDown: ->
      @dropDown.addClass('onScreen')
      @span.addClass('shadow')

    hideDropDown: ->
      @dropDown.removeClass('onScreen')
      @span.removeClass('shadow')
