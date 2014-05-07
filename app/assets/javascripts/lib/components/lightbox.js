// ------------------------------------------------------------------------------
//
// LightBox
//
// ------------------------------------------------------------------------------
define([ "jquery", "lib/mixins/flyout", "lib/utils/viewport_helper", "lib/utils/template" ], function($, asFlyout, viewportHelper, Template) {

  "use strict";

  // @args = {}
  // el: {string} selector for parent element
  var LightBox = function(args) {
    this.customClass = args.customClass;
    this.$listener = $(args.$listener || "#js-row--content");
    this.preloader = args.preloader || false;
    this.$el = $(args.el);
    this.$el && this.init();
  },
  _this,
  $window = $(window);

  // -------------------------------------------------------------------------
  // Mixins
  // -------------------------------------------------------------------------
  // The argument with the facet is required at the moment and is soon to be
  // removed from the flyout mixin.
  asFlyout.call(LightBox.prototype, { facet: ".to-be-removed", $listener: $(".lightbox__content") });

  // -------------------------------------------------------------------------
  // Initialise
  // -------------------------------------------------------------------------

  LightBox.prototype.init = function() {
    var $body = $("body");

    _this = this;

    this.$lightbox = $(".lightbox");
    this.$lightboxContent = this.$lightbox.find(".lightbox__content");

    if (!this.$lightbox.length) {
      this.$lightboxContent = $("<div class='lightbox__content' />");
      this.$lightbox = $("<div class='lightbox js-lightbox' />");

      this.customClass && this.$lightbox.addClass(this.customClass);

      this.$lightbox.append(this.$lightboxContent);

      $body.prepend(this.$lightbox);

      // Just in case there are defined dimensions already specified.
      this._centerLightbox();
    }

    this.$lightbox.css({
      height: $body.height(),
      width: $body.width()
    });
    if (this.preloader) {
      this.preloaderTmpl = Template.render($("#tmpl-preloader").text(), {});
    }

    this.listen();
  };

  // -------------------------------------------------------------------------
  // Subscribe to Events
  // -------------------------------------------------------------------------

  LightBox.prototype.listen = function() {

    this.$listener.on(":lightbox/updateContent", function(event, content) {
      _this._updateContent(content);
    });

    this.$listener.on(":lightbox/updateContentAjax", function(event, url) {
      _this._updateContentAjax(url);
    });

    this.$listener.on(":flyout/close", function() {
      _this.$lightboxContent.empty();
    });

    // this.$lightbox.on("click", function(e) {
    //   if (e.target == e.currentTarget) {
    //     _this.$listener.trigger(":toggleActive/update", _this.$el);
    //   }
    // });

    this.$listener.on(":layer/received", function(event, content) {
      _this._updateContent(content);
    });

    this.$listener.on(":htmlpage/received", function(event, content) {
      _this._updateContent(content);
    });

  };

  // -------------------------------------------------------------------------
  // Private Functions
  // -------------------------------------------------------------------------

  LightBox.prototype._updateContentAjax = function(url) {
    if (this.preloader){
      _this.$lightboxContent.html( this.preloaderTmpl );
      _this.$lightbox.addClass("is-loading");
      _this._centerLightbox();
    }

    $("#js-card-holder").trigger(":layer/request", { url: url });
  };

  // @content: {string} the content to dump into the lightbox.
  LightBox.prototype._updateContent = function(content) {
    _this.$listener.trigger(":lightbox/contentUpdated", _this.$el);
    _this.$lightbox.removeClass("is-loading");
    _this.$lightboxContent.html(content);
    _this._centerLightbox();
  };

  LightBox.prototype._centerLightbox = function() {
    this.$lightboxContent.css({
      left: this._centeredLeftPosition(),
      top: this._centeredTopPosition()
    });
  };

  LightBox.prototype._centeredLeftPosition = function() {
    var lightboxW = this.$lightboxContent.width(),
        left = $window.scrollLeft() + (viewportHelper.viewport().width / 2) - (lightboxW / 2);

    if (lightboxW > viewportHelper.viewport().width) {
      left = $window.scrollLeft();
    }

    return left;
  };

  LightBox.prototype._centeredTopPosition = function() {
    var lightboxH = this.$lightboxContent.height(),
        top = $window.scrollTop() + (viewportHelper.viewport().height / 2) - (lightboxH / 2);

    if (lightboxH > viewportHelper.viewport().height) {
      top = $window.scrollTop();
    }

    return top;
  };

  // This is useful for testing. Do not remove.
  LightBox.prototype._viewportDimensions = function() {
    return {
      h: $window.height(),
      w: $window.width()
    };
  };

  // Self instantiate if the default class is used.
  if ($(".js-lightbox-toggle").length) {
    var $lightboxToggle = $(".js-lightbox-toggle");
    new LightBox({
      customClass: $lightboxToggle.data("lightbox-class"),
      preloader: $lightboxToggle.data("lightbox-preloader"),
      el: ".js-lightbox-toggle"
    });
  }

  return LightBox;

});
