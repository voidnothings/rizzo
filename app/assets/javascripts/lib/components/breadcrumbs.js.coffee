define ['jquery'], ($) ->
 
  class Breadcrumbs

    LISTENER = '#js-card-holder'

    constructor: () ->
      @listen()

    # Subscribe
    listen: ->
      $(LISTENER).on ':cards/received :page/received', (e, data) =>
        @_updateNavBar(data.place) if data.place
        @_updateBreadcrumbs(data.breadcrumbs) if data.breadcrumbs

    # Private

    _updateNavBar: (place) ->
      $('#js-secondary-nav .place-title-heading').attr('href', "/#{place.slug}").text(place.name)

    _updateBreadcrumbs: (html) ->
      $('#js-breadcrumbs').html($(html).html())
