// ------------------------------------------------------------------------------
//
// LightBox
//
// ------------------------------------------------------------------------------

define([ "jquery", "lib/mixins/flyout" ], function($, asFlyout) {

  "use strict";

  // @args = {}
  // el: {string} selector for parent element
  var LightBox = function(args) {
    this.customClass = args.customClass;
    this.$listener = $("#js-row--content" || args.$listener);
    this.$el = $(args.el);
    this.$el && this.init();
  }, _this;

  LightBox.prototype.init = function() {
    _this = this;

    this.listen();

    this.$lightbox = $(".lightbox");
    if (!this.$lightbox.length) {
      this.$lightbox = $("<div class='lightbox'></div>");

      this.customClass && this.$lightbox.addClass(this.customClass);

      $("body").prepend(this.$lightbox);

      // Just in case there are defined dimensions already specified.
      this._centerLightbox();
    }
  };

  // -------------------------------------------------------------------------
  // Subscribe to Events
  // -------------------------------------------------------------------------

  LightBox.prototype.listen = function() {

    this.$listener.on(":lightbox/updateContent", function(event, content) {
      _this._updateContent(content);
    });

    this.$listener.on(":flyout/close", function() {
      _this.$lightbox.empty();
    });

  };

  // -------------------------------------------------------------------------
  // Private Functions
  // -------------------------------------------------------------------------

  // @content: {string} the content to dump into the lightbox.
  LightBox.prototype._updateContent = function(content) {
    this.$lightbox.html(content);
    this._centerLightbox();
  };

  LightBox.prototype._centerLightbox = function() {
    this.$lightbox.css({
      marginLeft: -1 * (this.$lightbox.width() / 2),
      marginTop: -1 * (this.$lightbox.height() / 2)
    });
  };

  // -------------------------------------------------------------------------
  // Mixins
  // -------------------------------------------------------------------------
  // The argument with the facet is required at the moment and is soon to be
  // removed from the flyout mixin.
  asFlyout.call(LightBox.prototype, { facet: ".to-be-removed" });

  // Self instantiate if the default class is used.
  if ($(".js-lightbox-toggle").length) {
    new LightBox({
      customClass: $(".js-lightbox-toggle").data("lightbox-class"),
      el: "js-lightbox-toggle"
    });
  }

  return LightBox;

});
