
define([ "jquery" ], function($) {

  "use strict";

  var _pageYOffset,
      started = false,
      speed = 15;

  var HeroParallax = function (args) {
    this.$els = $('.js-bg-parallax');
    this.init();
  };

  HeroParallax.prototype.init = function () {
    var scroll_ok;
    scroll_ok = true;
    setInterval(function() {
      return scroll_ok = true;
    }, 33);

    $(window).bind('scroll', $.proxy(this._onScroll, this));
  }

  HeroParallax.prototype._updateBg = function (i, el) {
    el = $(el);
    if (this._isElementInViewport(el)) {
      var percent = 30 + (((el.offset().top - _pageYOffset) * speed) / el.height());
      el.css('backgroundPosition', "center " + percent + "%");
    }
  }

  HeroParallax.prototype._update = function () {
    requestAnimationFrame($.proxy(this._update, this));

    $.each(this.$els, $.proxy(this._updateBg, this));
  };

  HeroParallax.prototype._startrAF = function () {
    if (!started){
      requestAnimationFrame($.proxy(this._update, this));
      started = true;
    }
  };

  HeroParallax.prototype._onScroll = function () {
    _pageYOffset = window.pageYOffset;
    this._startrAF();
  };

  HeroParallax.prototype._isElementInViewport = function($el) {
    var bounds, viewport, win;

    win = $(window);
    viewport = {
      top: win.scrollTop(),
      left: win.scrollLeft()
    };

    viewport.right = viewport.left + win.width();
    viewport.bottom = viewport.top + win.height();
    bounds = $el.offset();
    bounds.right = bounds.left + $el.outerWidth();
    bounds.bottom = bounds.top + $el.outerHeight();
    return !(viewport.right < bounds.left || viewport.left > bounds.right || viewport.bottom < bounds.top || viewport.top > bounds.bottom);

  };

  return HeroParallax;
});
