define([ "jquery" ], function($) {

  "use strict";

  var win = $(window);

  return {

    viewport: function() {
      return {
        width: win.width(),
        height: win.height(),
        top: win.scrollTop(),
        left: win.scrollLeft(),
        right: win.scrollLeft() + win.width(),
        bottom: win.scrollTop() + win.height()
      };
    },

    withinViewport: function($el) {
      var bounds,
          viewport = this.viewport();

      bounds = $el.offset();
      bounds.right = bounds.left + $el.outerWidth();
      bounds.bottom = bounds.top + $el.outerHeight();
      return !(viewport.right < bounds.left || viewport.left > bounds.right || viewport.bottom < bounds.top || viewport.top > bounds.bottom);

    }

  };

});
