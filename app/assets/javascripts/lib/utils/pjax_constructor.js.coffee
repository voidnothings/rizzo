# ------------------------------------------------------------------------------
# Handling pjax calls
# @constructor
# @param {#object} args - defined by config below
# ------------------------------------------------------------------------------

define ['jquery', 'jplugs/jquery.pjax'], ($) ->

  class Lpjax

    config =
      container : '#js-pjax-container'
      parent    : 'body'
      type      : 'GET'
      timeout   : 650
      url       : ''
      data      : ''
      success   : ->
      error     : ->

    init = ->
      $.pjax.defaults.scrollTo = false
      $(config.parent).on 'pjax:success', config.success
      $(config.parent).on 'pjax:error', config.error
      init = ->

    constructor: (args) ->
      $.extend config, args
      init()
      $.pjax
        url       : config.url
        container : config.container
        data      : config.data
        type      : config.type
        timeout   : config.timeout