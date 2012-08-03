# LP Nearby Things To Do
# Shows a list of nearby things to do
#
# Arguments:
#   args [Object]
#     target            : [string]  A container to append this widget to
#     pois              : [Object]  A hash of things to do category to the nearby top rated things to do in that category
#     listener          : [Object]  Object with poiSelected(poi_id) function - callback when a POI in the list is selected
#
# Dependencies:
#   Jquery
#   Handlebars
#   Underscore
#
# Example:
#   var nearbyThingsToDo = new window.lp.NearbyThingsToDo(target: '#nearby_list', pois: pois);
#   nearbyThingsToDo.render()
#
#


define ['jquery','handlebars','underscore'], ($) ->

  class NearbyThingsToDo

    constructor: (@args={})->
      @prepare()

    prepare: ->
      @container = $('<div>').addClass('lp-nearby-pois')
      $(@args.target).append(@container)
      templ = "
        {{#with properties}}
        <li class='nearby-poi-item' data-poi-id='{{id}}'>
          <div class='icon-poi-small icon-poi-{{../category}}-small'></div>
          <div class='poi-item-description'>
            <a href='{{uri}}' class='poi-item-title'>{{title}}</a>
            {{{description}}}
          </div>
        </li>
        {{/with}}
      "
      @listItemTemplate = Handlebars.compile(templ)

    render: ->
      @container.empty()
      @container.append($("<h3>").addClass('section-title').text("Interesting places nearby"))
      list = $('<ul>').addClass('nearby-pois-list')
      list.append(@listItemTemplate(activity)) for activity in @args.pois.sights_or_activities
      list.append(@listItemTemplate(@args.pois.entertainment)) if @args.pois.entertainment.length isnt 0
      list.append(@listItemTemplate(@args.pois.restaurant)) if @args.pois.restaurant isnt 0
      @container.append(list)
      @bindOnPOISelection()

    bindOnPOISelection: ->
      @container.find('li').on 'click', (e)=>
        poi_id = $(e.target).closest("li[data-poi-id]").attr('data-poi-id')
        @args.listener.poiSelected(poi_id) if (@args.listener? and poi_id?)

    highlightPOI: (poi_id)->
      @container.find('li[data-poi-id]').removeClass('nearby-poi-highlighted')
      @container.find("li[data-poi-id=#{poi_id}]").addClass('nearby-poi-highlighted')

    resetPOIs: ->
      @container.find('li[data-poi-id]').removeClass('nearby-poi-highlighted')


