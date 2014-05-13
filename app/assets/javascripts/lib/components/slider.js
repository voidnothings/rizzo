// Params: @args {
//   $el: {string} selector for parent element
//   slides: {string} selector for the individual slide elements.
//   slidesContainer: {string} selector for the element containing the slides
// }
define([ "jquery", "lib/extends/events" ], function($, EventEmitter) {
  "use strict";

  var
    defaults = {
      slides: ".slider__slide",
      slidesContainer: ".slider__container",
      slidesViewport: ".slider__viewport",
      controls: true,
      deferLoading: false
    },
    key,
    value;

  function Slider(args) {
    this.config = $.extend({}, defaults, args);
    this.currentSlide = 1;
    this.$el = $(this.config.el);
    this.$slides = this.$el.find(this.config.slides);
    this.numSlides = this.$el.find(this.$slides).length;

    if (this.$el.length === 0 || this.numSlides < 2) {
      return false;
    }

    this.init();
  }

  Slider.prototype.init = function() {
    this._gatherElements();
    this._addClasses();

    if (this.$currentSlide.length) {
      this._goToSlide(this.$slides.index(this.$currentSlide) + 1);
    }

    this.$slidesContainer.width("" + (this.$slides.length * 100) + "%");

    this.config.controls && this._createControls();

    this._updateCount();
    this.$slidesViewport.removeClass("is-loading");
    this.$listener.on(":slider/next", this._nextSlide);
    this.$listener.on(":slider/previous", this._previousSlide);

    // TODO: Move this into the map/media-gallery js when it exists
    this.$el.find(".js-resizer").on("click", function() {
      return $("input[name=\"" + $(this).attr("for") + "\"]").toggleClass("is-checked");
    });
  };

  Slider.prototype._gatherElements = function() {
    this.$currentSlide = this.$slides.filter(".is-current");
    this.$listener = $(this.config.$listener || "#js-row-content");
    this.$slidesContainer = this.$el.find(this.config.slidesContainer);
    this.$slidesViewport = this.$el.find(this.config.slidesViewport);
    this.$sliderControlsContainer = $(".slider__controls-container");
  };

  Slider.prototype._addClasses = function() {
    // Add the class to the @$el unless there's already a @$slidesViewport defined.
    if (!this.$slidesViewport.length) {
      this.$slidesViewport = this.$el.addClass(this.config.slidesViewport.substring(1));
    }

    // As above with the @$slidesViewport
    if (!this.$sliderControlsContainer.length) {
      this.$sliderControlsContainer = this.$slidesViewport.addClass("slider__controls-container");
    }

    this.$sliderControlsContainer.addClass("at-beginning");
  };

  Slider.prototype._createControls = function() {
    var _this = this,
      pagination = "",
      slideLinks;

    this.$sliderControls = $("<div class=\"slider__controls no-print\"></div>");
    this.$sliderPagination = $("<div class=\"slider__pagination no-print\"></div>");
    this.$next = $("<a href=\"#\" class=\"slider__control slider__control--next icon--chevron-right--before icon--white--before\">2 of " + this.numSlides + "</a>");
    this.$prev = $("<a href=\"#\" class=\"slider__control slider__control--prev icon--chevron-left--after icon--white--after\">" + this.numSlides + " of " + this.numSlides + "</a>");
    this.$sliderControls.append(this.$next, this.$prev);
    this.$sliderControlsContainer.append(this.$sliderControls);

    this.$slides.each(function(i) {
      return pagination += "<a href=\"#\" class=\"slider__pagination--link\">" + (i + 1) + "</a>";
    });

    this.$sliderPagination.append(pagination);
    this.$sliderControlsContainer.append(this.$sliderPagination);
    this._fadeControls();

    slideLinks = this.$sliderPagination.find(".slider__pagination--link");

    slideLinks.on({
      click: function(e) {
        var index = parseInt(e.target.innerHTML, 10);
        _this.$slides.removeClass("is-potentially-next");
        _this._goToSlide(index);
        return false;
      },

      mouseenter: function(e) {
        var index = parseInt(e.target.innerHTML, 10);
        _this.$el.removeClass("is-animating");
        _this.$slides.removeClass("is-potentially-next");
        _this.$slides.eq(index - 1).addClass("is-potentially-next");
        if (_this.config.deferLoading) {
          return _this._loadHiddenContent(_this.$slides);
        }
      },

      mouseleave:  function() {
        return _this.$slides.removeClass("is-potentially-next");
      }
    });

    this.$next.on("click", function() {
      _this._nextSlide();
      return false;
    });

    this.$prev.on("click", function() {
      _this._previousSlide();
      return false;
    });

    this.$next.on("mouseenter click", function() {
      if (_this.config.deferLoading) {
        return _this._loadHiddenContent(_this.$el.find(_this.$slides));
      }
    });

    this.$next.on("mouseenter click", function() {
      if (_this.config.deferLoading) {
        return _this._loadHiddenContent(_this.$el.find(_this.$slides));
      }
    });
  };

  Slider.prototype._loadHiddenContent = function(slides) {
    this.trigger(":asset/uncomment", [ slides.slice(1), "[data-uncomment]" ]);
    this.config.deferLoading = false;
  };

  Slider.prototype._nextSlide = function() {
    if (this.$slidesViewport.is(".at-end")) {
      return;
    }
    this._goToSlide(this.currentSlide + 1);
  };

  Slider.prototype._previousSlide = function() {
    if (this.$slidesViewport.is(".at-beginning")) {
      return;
    }
    this._goToSlide(this.currentSlide - 1);
  };

  Slider.prototype._goToSlide = function(index) {
    var percentOffset;
    if (index < 1) {
      index = 1;
    }

    if (index > this.$slides.length) {
      index = this.$slides.length;
    }

    percentOffset = (index - 1) * 100;

    this.$slidesContainer.css("marginLeft", ( -1 * percentOffset ) + "%");
    this.currentSlide = index;
    this._updateSlideClasses();
    this._updateCount();
  };

  Slider.prototype._updateSlideClasses = function() {
    this.$slides.removeClass("is-current is-previous is-next");
    this.$slides.eq(this.currentSlide - 1).addClass("is-current").prev().addClass("is-previous").end().next().addClass("is-next");
    return this.$slides.removeClass("is-hidden");
  };

  Slider.prototype._updateCount = function() {
    var currentHTML, nextIndex, prevIndex;
    currentHTML = this.$next.html() || "";
    nextIndex = this.currentSlide + 1;
    prevIndex = this.currentSlide - 1;

    if (nextIndex > this.$slides.length) {
      nextIndex = 1;
    }

    if (prevIndex < 1) {
      prevIndex = this.$slides.length;
    }

    this.$sliderControlsContainer.removeClass("at-beginning at-end");

    if (this.currentSlide === 1) {
      this.$sliderControlsContainer.addClass("at-beginning");
    } else if (this.currentSlide === this.$slides.length) {
      this.$sliderControlsContainer.addClass("at-end");
    }

    this.$next.html(currentHTML.replace(/(^[0-9]+)/, nextIndex));
    this.$prev.html(currentHTML.replace(/(^[0-9]+)/, prevIndex));
    this.$sliderControlsContainer.find(".slider__pagination--link.is-active").removeClass("is-active");
    this.$sliderControlsContainer.find(".slider__pagination--link").eq(this.currentSlide - 1).addClass("is-active");
  };

  Slider.prototype._fadeControls = function() {
    return setTimeout((function(_this) {
      return function() {
        return _this.$sliderControls.addClass("is-faded-out");
      };
    })(this), 1000);
  };

  for (key in EventEmitter) {
    value = EventEmitter[key];
    Slider.prototype[key] = value;
  }

  return Slider;

});
