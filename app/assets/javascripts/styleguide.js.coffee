require ['jquery', 'lib/core/base'], ($, Base) ->

  $ ->
    base = new Base()

    require ['lib/styleguide/ajax-content', 'lib/styleguide/copy', 'lib/styleguide/snippet-expand']

    if /colours/.test(location.href)
      require ['lib/styleguide/colours']