# Handling pjax calls
# @constructor
# @param {object} args
#   url - the remote url for the ajax call
#   parent - The parent dom element for the events, defaults to body
#   container - defaults to js-pjax-container
#   callback - Function to fire on success
# 

define ['jquery', 'jplugs/jquery.pjax'], ($) ->

  class Lpjax
    
    config =
      container : '#js-pjax-container'
      parent    : 'body'
    
    constructor: (args) ->
      $.extend config, args
      @addSuccessHandler()
      $.pjax
        url       : config.url
        container : config.container

    addSuccessHandler: ->
      $(config.parent).on 'pjax:success', config.callback