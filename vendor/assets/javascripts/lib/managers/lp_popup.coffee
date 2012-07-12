
define ['jquery'], ($) ->

  class Popup

    @init: ->

      $("*[data-behaviour=popup]").live "click", (event) ->
        event.preventDefault()
        event.stopPropagation()

        width = $(this).data("width")
        height = $(this).data("height")
        url = $(this).attr("href")

        window.open(url, "", "height=#{height},width=#{width}")

