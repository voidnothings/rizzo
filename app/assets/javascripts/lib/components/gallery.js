define([
  "jquery",
  "lib/components/slider",
  "lib/analytics/analytics",
  "lib/utils/on_transition_end"
], function($, Slider, Analytics, onTransitionEnd) {

  "use strict";

  var defaults = {
    el: "#js-gallery",
    listener: "#js-row--content",
    sliderConfig: {}
  };

  function Gallery(args) {
    this.config = $.extend({}, defaults, args);

    this.$listener = $(this.config.listener);
    this.$gallery = this.$listener.find(this.config.el);
    this.analytics = new Analytics();
    this.slug = this.$gallery.data("href");
    this.init();
  }

  Gallery.prototype.init = function() {
    this.slider = new Slider($.extend({
      el: this.$gallery,
      $listener: this.$listener,
      assetBalance: 4,
      createControls: false,
      keyboardControl: true
    }, this.config.sliderConfig));
    this._gatherElements();
    this._handleEvents();
  };

  Gallery.prototype._gatherElements = function() {
    this.galleryTitle = this.$gallery.find(".js-gallery-title");
    this.galleryPoi = this.$gallery.find(".js-gallery-poi");
    this.galleryBreadcrumb = this.$gallery.find(".js-gallery-breadcrumb");
  };

  Gallery.prototype._updateImageInfo = function() {
    var slideDetails = this.slider.$currentSlide.find(".js-slide-details"),
        caption = slideDetails.find(".caption").text(),
        poi = slideDetails.find(".poi").html(),
        breadcrumb = slideDetails.find(".breadcrumb").html();

    this.galleryTitle.text(caption);
    this.galleryPoi.html(poi);
    this.galleryBreadcrumb.html(breadcrumb);
  };

  Gallery.prototype._updateSlug = function() {
    var partial = this.slider.$currentSlide.data("partial-slug");
    window.history.pushState && window.history.pushState({}, "", this.slug + "/" + partial);
  };

  Gallery.prototype._handleEvents = function() {
    var afterTransition = function() {
      this.analytics.track();
      this._updateImageInfo();
      this._updateSlug();
      this.$listener.trigger(":ads/refresh");
    }.bind(this);

    onTransitionEnd({
      $listener: this.$listener,
      fn: afterTransition
    });
  };

  return Gallery;
});
