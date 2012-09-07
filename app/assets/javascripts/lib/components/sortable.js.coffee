# LP Sortable
# A
#
# Arguments:
#   args [Object]
#     target             : [string]   A container to append the main gallery element.
#
# Dependencies:
#   Jquery
#
# Example:
#   var args = {
#     index: 0
#     data: [
#       {src:'a.png', thumb:'a-thumb.png'},
#       {src:'b.png', thumb:'b-thumb.png'},
#       {src:'c.png', thumb:'c-thumb.png'},
#       {src:'d.png', thumb:'d-thumb.png'}
#     ]
#     target: 'section.gallery-section'
#     delegate: {
#       onClose: function(){
#           //on close code here
#         }
#       }
#     };
#
#   var gallery = new window.lp.Gallery(args)
#   gallery.show()
#
#

define ['jquery'], ($) ->

  class Sortable
    @version: '0.0.1'
    @options:
      index: 0

    constructor: (@args={})->
      @args = $.extend Sortable.options, @args
      console.log "started sortable"
#      @prepare()
#
#    prepare: ->
#      @container = $('<div>').attr({id:'lp-gallery'})
#      $(@args.target).append(@container)
#      $(@container).append(@header())
#      @bindEvents()
#      @populateStage()
#      @populateThumbs()
#
#    header:() ->
#      toolbar = $('<div>').addClass('lp-gallery-toolbar')
#      if @args.title
#        title = $('<div>').addClass('lp-gallery-title').text(@args.title)
#        $(toolbar).append(title)
#      @btn_close = $('<div>').addClass('std btn-soft').append($('<span>').text('Close'))
#      $(toolbar).append(@btn_close)
#
#    populateStage:() ->
#      template = @args.stageTemplate
#      options =
#        target: '#lp-gallery'
#        handlers: true
#        template: template
#        slidesPerSet: @args.stageSlidesPerSet
#        speed: 400
#        index: @args.index
#        start: false
#        style: 'lp-gallery-stage'
#        msg: 'loading_images'
#        transform: 'opacity'
#        delegate :
#          onUpdate: @onStageUpdate
#      @stage = new Swipe(options)
#      @stage.render(@args.data)
#
#    onStageUpdate: (_bind, _i)=>
#      for a in [0...(@args.preload)]
#        @onSelect(_i)
#        do (a) =>
#          asset = $($(_bind.container).children()[_bind.index + a])
#          if asset
#            asset = asset.find('div.lp-gallery-img-wrap')
#            unless $(asset).data("state")
#              src = asset.data('src')
#              $(asset).data('state','true')
#              $(asset).empty().append($('<img>').attr({src:src}))
#
#    onSelect: (_i)->
#      elements = $(@thumb.container).find('li')
#      $(elements).removeClass('current')
#      $(elements[_i]).addClass('current')
#      @thumb.slideToSet(_i)
#
#    populateThumbs: ->
#      template = @args.thumbTemplate
#      options =
#        target: '#lp-gallery'
#        handlers: true
#        template: template
#        slidesPerSet: @args.thumbsSlidesPerSet
#        width: 498
#        speed: 400
#        style: 'lp-gallery-thumbs'
#        msg: 'loading_thumbs'
#        transform: 'translateX'
#        delegate :
#          onSelect:(e,i) => @displaySlide(e,i)
#      @thumb = new Swipe(options)
#      @thumb.render(@args.data)
#      @stage.start()
#
#    displaySlide: (_e, _index)->
#      @stage.transform(_index)
#      @stage.stopSlideShow()
#      @onSelect(_index)
#
#    show: ()->
#      $('html').addClass('lp-gallery-active')
#
#    close: ()->
#      @dump()
#      @args.delegate.onClose() if (@args.delegate && @args.delegate.onClose)
#
#    dump: ()->
#      $('html').removeClass('lp-gallery-active')
#      $('#lp-gallery').remove()
#      @container.remove()
#      $(document).unbind('keydown')
#
#    bindEvents: ()->
#      $(document).on('keydown', (e)=> @keyListener(e))
#      $(@btn_close).on('click', (e)=> @close())
#
#    keyListener: (e)->
#      @close() if(e.which is 27)
#      @stage.prev() if e.which is 37
#      @stage.next() if e.which is 39
