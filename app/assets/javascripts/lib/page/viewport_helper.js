// ------------------------------------------------------------------------------
//
// asViewportHelper
//
// ------------------------------------------------------------------------------

define([ "jquery" ], function($) {

  "use strict";

  var asViewportHelper = function() {};

  asViewportHelper.viewport = function() {
    var win = this._getWindow();

    return {
      width: win.width(),
      height: win.height(),
      top: win.scrollTop(),
      left: win.scrollLeft(),
      right: win.scrollLeft() + win.width(),
      bottom: win.scrollTop() + win.height()
    };
  };

  asViewportHelper.withinViewport = function($el) {
    var bounds,
        viewport = this.viewport();

    bounds = $el.offset();
    bounds.right = bounds.left + $el.outerWidth();
    bounds.bottom = bounds.top + $el.outerHeight();
    return !(viewport.right < bounds.left || viewport.left > bounds.right || viewport.bottom < bounds.top || viewport.top > bounds.bottom);
  };

  // -------------------------------------------------------------------------
  // Private Functions
  // -------------------------------------------------------------------------

  // We need this function so we can stub it out for testing.
  asViewportHelper._getWindow = function() {
    return $(window);
  };

  return asViewportHelper;

});
