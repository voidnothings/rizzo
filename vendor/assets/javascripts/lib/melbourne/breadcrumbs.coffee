define ['jquery', 'lib/melbourne/breadcrumb_bar', 'lib/melbourne/breadcrumb_resizer'], ($, BreadcrumbBar, BreadcrumbResizer) ->
  breadcrumbs =
    get:(src) ->
      try
        $.ajax
          type: "GET"
          url: src
          contentType: "text/xml"
          dataType: "html"
          cache: true
          success: (data) =>
            @parse(data)
          error: (data) =>
            # TODO: implement fallBack
    
    parse: (_fragment) ->
      $("#breadcrumbWrap").replaceWith(_fragment)
      brdBar = new BreadcrumbBar('#breadcrumb')
      brdRez = new BreadcrumbResizer()

    init: (_src)->
      $(document).ready ($) =>
        @get(_src)

