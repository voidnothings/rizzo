# LP Sortable
# Allows ordered lists to be sorted using HTML5 drag-and-drop
#
# Arguments:
#   args [Object]
#     target             : [string]   The list to make sortable.
#     draggingStyle      : [string]   The class to give the list item being dragged.
#     callback           : [function] Function that will be called when the list is re-ordered.
#     context            : [object]   The object which will be the context when the callback is invoked (optional)
#
# Dependencies:
#   jQuery
#
# Example:
#   var args = {
#     target: document.getElementById('#sortable'),
#     draggingStyle: 'dragging-element',
#     callback: function(){
#         // on sorted code here
#       }
#     };
#
#   var sortable = new Sortable(args)
#

define ['jquery'], ($) ->

  class Sortable
    @version: '0.0.1'
    @options:
      target:         null
      callback:       null
      context:        null
      draggingStyle:  'sortable-dragging'

    constructor: (@args={}) ->
      @options = $.extend Sortable.options, @args
      @target = @options.target

      # throw an error if element isn't an ordered list
      if @target.tagName != 'OL'
        throw "Can only make an ordered list sortable"
      else
        @placeholder = $('<li class="sortable-placeholder">')
        @items = $(@target).find('li')
        @bindEvents()

    bindEvents: ->
      t = $(@target)
      t.on('dragstart', 'li', (e) => @dragStart(e))
      t.on('dragenter', 'li[draggable]', (e) => @dragEnter(e))
      t.on('dragover', 'li', (e) => @dragOver(e))
      t.on('drop', 'li', (e) => @drop(e))
      t.on('dragend', 'li', (e) => @dragEnd(e))

    dragStart: (e) ->
      @dragSrcEl = $(e.currentTarget).addClass @options.draggingStyle
      @index = @dragSrcEl.index()

      # see http://www.whatwg.org/specs/web-apps/current-work/multipage/dnd.html#dnd
      dt = e.originalEvent.dataTransfer
      dt.dropEffect = 'move'
      dt.setData 'Text', 'dummy' # need to set this for FF to work

    dragEnter: (e) ->
      e.preventDefault()

      dragging = e.currentTarget
      e.originalEvent.dataTransfer.dropEffect = 'move'

      if @items.is(dragging)
        @dragSrcEl.hide()
        $(e.currentTarget)[ if @placeholder.index() < $(dragging).index() then 'after' else 'before' ](@placeholder)

    dragOver: (e) ->
      if e.preventDefault
        e.preventDefault() # Necessary. Allows us to drop.
      return false

    drop: (e) ->
      e.stopPropagation()
      @placeholder.after @dragSrcEl
      return false

    dragEnd: (e) ->
      @dragSrcEl.removeClass @options.draggingStyle
      @dragSrcEl.show()
      @dragSrcEl = null
      @placeholder.detach()

      if typeof @options.callback is 'function'
        @options.callback.call(@options.context || e.delegateTarget)
