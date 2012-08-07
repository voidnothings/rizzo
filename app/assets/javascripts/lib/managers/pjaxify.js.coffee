define ['jquery', 'jplugs/jquery.pjax'], ($) ->

  class Pjaxify

    constructor: (@parent = 'body')->
      @addHandlers()

    addHandlers: ->

      $(@parent).on 'click', 'a[data-pjax]', (e) ->
        e.preventDefault()
        $.pjax
          url      : e.target.href
          container: '#js-pjax-container'

