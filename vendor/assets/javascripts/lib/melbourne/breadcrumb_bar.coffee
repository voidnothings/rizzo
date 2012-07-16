define ['jquery','lib/melbourne/breadcrumb_tab'], ($, BreadcrumbTab) ->

  class BreadcrumbBar

    constructor: (_target) ->
      @items = []
      @items.push(new BreadcrumbTab(b,@)) for b in $(_target).children("li")

    resetAll: (_element) ->
      $(@items).each(-> @reset())

