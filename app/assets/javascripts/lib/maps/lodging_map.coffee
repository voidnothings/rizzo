# LP Lodging Map 
# Shows a map with a lodging and optionally nearby things to do
#
# Arguments:
#   args [Object]
#     target            : [string]    A container to append this widget to
#     lodging           : [Object]    A hash of info about the lodging such as name and long/lat
#     longitude         : [number]    center of map
#     latitude          : [number]    center of map
#     zoom              : [number]    zoom of map
#     optimized         : [boolean]   google maps API optimized setting to use for markers
#     listener          : [Object]    object has a poiSelected(poi_id) function - called when a poi is selected
#
# Dependencies:
#   Jquery
#
# Example:
#   var lodgingMap = new window.lp.LodgingMap(
#     target: '#map_canvas',
#     lodging: window.lp.lodging,
#     longitude: window.lp.map.latitude,
#     latitude: window.lp.map.longitude,
#     zoom: window.lp.map.zoom
#   );
#   lodgingMap.render()
#
#
define ['jquery','lib/utils/css_helper'], ($, CssHelper) ->
 
  class LodgingMap

    constructor: (@args={})->
      @prepare()
      @markerImageFor('sight', 'small')

    prepare: ->
      opts =
        zoom: @args.zoom
        center: new google.maps.LatLng(@args.latitude, @args.longitude)
        mapTypeId: google.maps.MapTypeId.ROADMAP

      target = $(@args.target).get()[0]
      @map = new google.maps.Map(target, opts)
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
      @map.setOptions({styles: pinkParksStyles})

    setLodgingMarker: ->
      opts =
        position: new google.maps.LatLng(@args.lodging.latitude, @args.lodging.longitude)
        map: @map
        title: @args.lodging.title
        optimized: @args.optimized
        icon: @markerImageFor('hotel', 'large')
      marker = new google.maps.Marker(opts)

    drawNearbyPOI: (poi) ->
      opts =
        position: new google.maps.LatLng(poi.geometry.coordinates[1], poi.geometry.coordinates[0])
        map: @map
        title: poi.properties.title
        description: poi.properties.description
        optimized: @args.optimized
        poi_id: poi.properties.id
        category: poi.category
        icon: @markerImageFor(poi.category)
      marker = new google.maps.Marker(opts)

    createMarkerImageFor: (category, size)->
      cssInfo = CssHelper.propertiesFor(
        "icon-poi-#{category}-#{size} icon-poi-#{size}",
        [
          'background-position',
          'background-image',
          'height',
          'width'
        ]
      )
      url = CssHelper.extractUrl(cssInfo['background-image'])
      stripPx = CssHelper.stripPx
      width = stripPx(cssInfo['width'])
      height = stripPx(cssInfo['height'])
      pos = cssInfo['background-position'].split(' ')
      x = stripPx(pos[0])
      y = stripPx(pos[1])
      new google.maps.MarkerImage(
        url,
        new google.maps.Size(width, height),
        new google.maps.Point(-x, -y)
      )

    markerImageFor: (category, size='small')->
      @markerImages ?= {}
      key = "#{category}-#{size}"
      @markerImages[key] ?= @createMarkerImageFor(category, size)

    initMapPOIs: (data)->
      @markers ?= {}
      for poi in @allPOIs(data)
        marker = @drawNearbyPOI(poi)
        @addClickListener(marker)
        @markers[poi.properties.id] = marker

    allPOIs: (data)->
      _.flatten(_.values(data))

    addClickListener: (marker)->
      # own function so marker in closure
      google.maps.event.addListener marker, 'click', =>
        poi_id = marker.poi_id
        @args.listener?.poiSelected(poi_id)

    highlightPOI: (poi_id)->
      for id, marker of @markers
        if id == poi_id
          marker.setIcon(@markerImageFor(marker.category, 'large'))
          @map.panTo(marker.getPosition())
        else
          marker.setIcon(@markerImageFor(marker.category))

    resetPOIs: ->
      marker.setIcon(@markerImageFor(marker.category)) for id, marker of @markers
      @map.panTo( new google.maps.LatLng(@args.latitude, @args.longitude))


