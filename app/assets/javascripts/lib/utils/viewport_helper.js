
define([ "jquery" ], function($, feature) {

  $.fn.isInViewport = function() {
    var bounds, viewport, win;

    win = $(window);
    viewport = {
      top: win.scrollTop(),
      left: win.scrollLeft()
    };

    viewport.right = viewport.left + win.width();
    viewport.bottom = viewport.top + win.height();
    bounds = this.offset();
    bounds.right = bounds.left + this.outerWidth();
    bounds.bottom = bounds.top + this.outerHeight();
    return !(viewport.right < bounds.left || viewport.left > bounds.right || viewport.bottom < bounds.top || viewport.top > bounds.bottom);
  };

});
