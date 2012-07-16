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

    @loadLib: ->
      # pointer to google-maps callback, not possible inside the regular closure environment
      lp.MapManager = MapManager

      unless @lodgingMap
        script = document.createElement("script")
        script.type = "text/javascript"
        script.src = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=lp.MapManager.initMap"
        document.body.appendChild(script)

    @initMap: ()->
      @lodgingMap = new LodgingMap(
        target: '#map_canvas'
        lodging: lp.lodging
        latitude: lp.map.latitude
        longitude: lp.map.longitude
        zoom: lp.map.zoom
        optimized: lp.map.optimized
        listener: @
      )
      unless lp.lodging.genericCoordinates
        @lodgingMap.setLodgingMarker()
        @getNearbyPOIs (data)=>
          pois = @parsePOIData(data)
          @lodgingMap.initMapPOIs(pois)
          @initNearbyThingsToDo(pois)

    @getNearbyPOIs: (callback) ->
      if lp.lodging.nearby_api_endpoint
        # $.getJSON '/top_rated_nearby_by_category.json', callback
        $.getJSON lp.lodging.nearby_api_endpoint, callback
    
    @parsePOIData: (data)->
      pois = {}
      sight.category = 'sight' for sight in data.sights
      activity.category = 'activity' for activity in data.activities
      pois.sights_or_activities = _.sortBy(data.activities.concat(data.sights || []),
                                           (poi)-> -poi.properties.rating)[0..2]
      pois.entertainment = data['entertainment-nightlife'][0]
      pois.entertainment.category = 'entertainment' if pois.entertainment?
      pois.restaurant = data.restaurants[0]
      pois.restaurant.category = 'restaurant' if pois.restaurant?
      pois

    @initNearbyThingsToDo: (pois)->
      @nearbyThingsToDo = new NearbyThingsToDo(
        target: '#pois-list-wrapper'
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

    constructor: ->
      MapManager.loadLib()

