define ['jquery'], ($)->

 class BreadcrumbResizer

   constructor: ->
     @theBreadcrumbHeight = $('#breadcrumbWrap').height()
     @theBreadcrumbLink = $('#breadcrumb li a')
     @subBreadcrumbLinks = $('#breadcrumb li ul li a')
     if (@theBreadcrumbHeight > 40 && @theBreadcrumbHeight < 75)
       @theBreadcrumbLink.css('font-size', '.7em').css('margin-top', '3px')
       @subBreadcrumbLinks.css('font-size', '1em')
     if (@theBreadcrumbHeight > 75)
       @theBreadcrumbLink.css('font-size', '.55em').css('padding-right', '2px').css('padding-left', '2px').css('margin-top', '3px')
       @subBreadcrumbLinks.css('font-size', '1em')
