// Protect legacy apps that already define jQuery from downloading it again
if (window.jQuery) {
  define("jquery", [], function() {
    "use strict";
    return window.jQuery;
  });
}

require([ "jquery" ], function($) {

  "use strict";

  require([
    "lib/core/base",
    "flamsteed",
    "trackjs",
    "polyfills/function_bind",
    "polyfills/xdr"
  ], function(Base, Flamsteed) {

    $(function() {

      new Base({ secure: true });

      window.lp.fs = new Flamsteed({
        events: window.lp.fs.buffer,
        u: $.cookies.get("lpUid")
      });

    });

  });
});
