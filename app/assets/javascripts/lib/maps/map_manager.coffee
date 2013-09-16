# MapManager (lp.MapManager)
# A simple map manager to orchestrate the async load of the google map lib and initialize the lodging map.
#
# Arguments
# No need for arguments, however (and for now) it reads the latitude, longitude, title, zoom, ...
# from the lp.map object. For further details on this object run console.log(lp.map) on the
# browser inspector
#
# Example:
# It only loads the lib and instantiates the map if lp.map is defined
#
# if(lp.map){
#   self.mapWidget = new MapManager({});
# }
#

define ['jquery','lib/maps/lodging_map','lib/maps/nearby_things_to_do'], ($, LodgingMap, NearbyThingsToDo) ->

  class MapManager
    @version: '0.0.11'
    @lodgingMap: null
    @nearbyThingsToDo: null
    @currentPOI: null
    @config: {
      target: '#js-map-canvas'
    }

    @loadLib: ->
      unless @lodgingMap
        # pointer to google-maps callback, not possible inside the regular closure environment
        lp.MapManager = MapManager

        script = document.createElement("script")
        script.type = "text/javascript"
        script.src = "http://maps.googleapis.com/maps/api/js?v=2&sensor=false&callback=lp.MapManager.initMap"
        document.body.appendChild(script)


    @initMap: =>
      require ['maps_infobox'], =>
        if lp.lodging
          args = lp.lodging.map
          args.listener = @
          $.extend args, @config
          @lodgingMap = new LodgingMap(args)

          unless lp.lodging.map.genericCoordinates
            @lodgingMap.setLodgingMarker()
            @getNearbyPOIs((data) =>
              pois = @parsePOIData(@_sanitizeData(data))
              $('#js-nearby-pois, .infobox__interesting-places').removeClass('is-hidden')
              @lodgingMap.initMapPOIs(pois)
              @initNearbyThingsToDo(pois)
            )
          $(@config.target).removeClass('is-loading')

    @getNearbyPOIs: (callback) ->
      if lp.lodging.map.nearby_api_endpoint
        $.getJSON lp.lodging.map.nearby_api_endpoint, callback
      

    @parsePOIData: (data) ->
      pois = {}
      sight.category = 'sight' for sight in data.sights
      activity.category = 'activity' for activity in data.activities
      pois.sights_or_activities = @_sortBy(data.activities.concat(data.sights || []),
                                           (poi)-> -poi.properties.rating)[0..2]
      ents = data['entertainment-nightlife']
      pois.entertainment = (if ents.length isnt 0 then ents[0] else [])
      pois.entertainment.category = 'entertainment' if pois.entertainment.length isnt 0
      rests = data['restaurants']
      pois.restaurant = (if rests.length isnt 0 then rests[0] else [])
      pois.restaurant.category = 'restaurant' if pois.restaurant.length isnt 0
      pois

    @initNearbyThingsToDo: (pois)->
      @nearbyThingsToDo = new NearbyThingsToDo(
        target: '#js-nearby-pois'
        pois: pois
        listener: this
      )
      @nearbyThingsToDo.render()

    @poiSelected: (poi_id)->
      if poi_id is @currentPOI
        @currentPOI = null
        @lodgingMap.resetPOIs()
        @nearbyThingsToDo.resetPOIs()
      else
        @currentPOI = poi_id
        @lodgingMap.highlightPOI(poi_id)
        @nearbyThingsToDo.highlightPOI(poi_id)

    @_sanitizeData: (data) ->
      data.activities = @_filter(data.activities, (activity) -> activity.properties.uri)
      data.sights = @_filter(data.sights, (sight) -> sight.properties.uri)
      data['entertainment-nightlife'] = @_filter(data['entertainment-nightlife'], (ent) -> ent.properties.uri)
      data.restaurants = @_filter(data.restaurants, (restaurant) -> restaurant.properties.uri)
      data

    #===== Nicked from UnderscoreJS v1.5.1 =====#
    @_map = (obj, iterator, context) ->
      results = []
      return results  unless obj?
      return obj.map(iterator, context)  if Array.prototype.map and obj.map is Array.prototype.map
      each obj, (value, index, list) ->
        results.push iterator.call(context, value, index, list)

      results

    @_pluck = (obj, key) ->
      @_map obj, (value) ->
        value[key]

    @_sortBy = (obj, value, context) ->
      iterator = @_lookupIterator(value)
      @_pluck @_map(obj, (value, index, list) ->
        value: value
        index: index
        criteria: iterator.call(context, value, index, list)
      ).sort((left, right) ->
        a = left.criteria
        b = right.criteria
        if a isnt b
          return 1  if a > b or a is undefined
          return -1  if a < b or b is undefined
        (if left.index < right.index then -1 else 1)
      ), "value"

    @_lookupIterator = (value) ->
      (if $.isFunction(value) then value else (obj) ->
        obj[value]
      )

    @_filter = (obj, iterator, context) ->
      results = []
      return results  unless obj?
      return obj.filter(iterator, context)  if Array.prototype.filter and obj.filter is Array.prototype.filter
      each obj, (value, index, list) ->
        results.push value  if iterator.call(context, value, index, list)

      results
    #===== End UnderscoreJS thievery =====#

    constructor: (config) ->
      $.extend MapManager.config, config

      if config and config.loadSelector
        $(config.loadSelector).one(config.loadEventType, MapManager.loadLib)
      else
        MapManager.loadLib()

      if config and config.centerTrigger
        
        $(document).on 'change', config.centerTrigger, =>
          map = MapManager.lodgingMap.map

          overlay = new google.maps.OverlayView()
          overlay.draw = ->
          overlay.setMap map

          setTimeout ->
            oldCenter = map.getCenter()
            google.maps.event.trigger(map, "resize")
            newCenter = map.getCenter()

            projection = overlay.getProjection()
            oldCenterPoint = projection.fromLatLngToDivPixel(oldCenter)
            newCenterPoint = projection.fromLatLngToDivPixel(newCenter)

            # Move the y axis by the difference between the old and new center points.
            newCenterPoint.y -= newCenterPoint.y - oldCenterPoint.y
            map.panTo(projection.fromDivPixelToLatLng(newCenterPoint))
          , config.centerDelay || 0
