define ['jquery', 'lib/utils/page_state', 'lib/extends/events'], ($, PageState, EventEmitter) ->

  class PrepareSlider extends PageState

    for key, value of EventEmitter
      @prototype[key] = value

    constructor: (args) ->
      @$el = $(args.el)
      @_prepareSlider() if @$el.length > 0

    # Private Methods

    _flattenNodeList: (slide) ->
      cards = $(slide).find('.js-card')
      nodes = []
      for card in cards
        if $(card).hasClass('js-double-image-card')
          nodes.push(card.children[0], card.children[1])
        else
          nodes.push(card)
      nodes

    _prepareSlider: ->
      # The cards are already split into groups of 4
      groups = @$el.children()

      # Get the width of a group (they will all be the same)
      groupWidth = groups.width()
      
      # Let's use at maximum 90% of the screen for a slide
      viewport = parseInt(@getViewPort() * 0.9)

      # Calculate how many groups we can fit on a slide
      groupsPerSlide = Math.floor(viewport / groupWidth)
      
      # And determine what width that would make each slide
      slideWidth = groupsPerSlide * groupWidth

      # Split the card groups into slides
      @slides = []
      while groups.length > 0
        @slides.push(groups.splice(0, groupsPerSlide))

      # Load the images in the first slide
      @trigger(':asset/uncomment', [@_flattenNodeList(@slides[0]), '[data-uncomment]'])

      # Create each slide
      slidesContainer = $('<div/>').addClass('slider__container')
      for slide in @slides
        $slide = $('<div/>').width(slideWidth).addClass('slider__slide').append(slide)
        slidesContainer.append($slide)

      # Remove overflow
      $('.js-overthrow').removeClass('overthrow')

      # Reset the width definition of our container
      @$el.width(slideWidth)

      # Insert the slides
      @$el.html(slidesContainer)
