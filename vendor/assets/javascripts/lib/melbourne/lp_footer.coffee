define ['jquery'], ($)->
  footer =
    init : () ->
      $("#language").removeClass('javascriptDisabled')
      $("#languageSelect").change ->
        $("#language").submit()

