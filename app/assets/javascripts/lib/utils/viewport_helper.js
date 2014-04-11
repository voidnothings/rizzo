
define([ "jquery" ], function($, feature) {

  return function(el) {
    var bounds, viewport, win
        $el = $(el);

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

});
