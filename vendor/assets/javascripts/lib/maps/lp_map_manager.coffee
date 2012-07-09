# MapManager (lp.MapManager)
# A simple map manager to orchestrate the async load of the google map lib and initialize the lodging map.
#
# Arguments
# No need for arguments, however (and for now) it reads the latitude, longitude, title, zoom, ...
# from the window.lp.map object. For further details on this object run console.log(lp.map) on the
# browser inspector
#
# Example:
# It only loads the lib and instantiates the map if window.lp.map is defined
#
# if(window.lp.map){
#   self.mapWidget = new window.lp.MapManager({});
# }
#

window.lp?= {}
window.lp.MapManager = class MapManager
  @version: '0.0.11'
  @isLoaded: false

  @loadLib: ->
    unless @isLoaded
      script = document.createElement("script")
      script.type = "text/javascript"
      script.src = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=lp.MapManager.initMap"
      document.body.appendChild(script)

  @initMap: ()->
    @isLoaded = true
    opts =
      zoom: window.lp.map.zoom
      center: new google.maps.LatLng(window.lp.map.latitude, window.lp.map.longitude)
      mapTypeId: google.maps.MapTypeId.ROADMAP

    map = new google.maps.Map(document.getElementById("map_canvas"), opts)
    pinkParksStyles = [
      featureType: "all",
      stylers: [
        { hue: "#586c8c" },
        { visibility: "on" },
        { lightness: 19 },
        { saturation: -66 },
        { gamma: 0.79 }
      ]
    ]
    map.setOptions({styles: pinkParksStyles})
    unless window.lp.lodging.genericCoordinates
      @setMapMarker(map)
      @getNearbyPOIs(map)

  @setMapMarker: (map)->
    opts =
      position: new google.maps.LatLng(window.lp.lodging.latitude, window.lp.lodging.longitude)
      map: map
      title: lp.lodging.title
      optimized: lp.map.optimized
    marker = new google.maps.Marker(opts)

  @getNearbyPOIs: (map) ->
    if lp.lodging.nearby_api_endpoint
      $.getJSON lp.lodging.nearby_api_endpoint, (data)=>
        @drawNearbyPOI(map, d) for d in data

  @drawNearbyPOI:(map, poi) ->
    opts =
      position: new google.maps.LatLng(poi.geometry.coordinates[1], poi.geometry.coordinates[0])
      map: map
      title: poi.properties.title
      optimized: lp.map.optimized
    marker = new google.maps.Marker(opts)

  constructor: ->
    window.lp.MapManager.loadLib()
