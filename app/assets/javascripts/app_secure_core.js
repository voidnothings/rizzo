require([ "jquery" ], function($) {

  "use strict";

  require([
    "lib/core/base",
    "lib/utils/scroll_perf",
    "flamsteed",
    "trackjs",
    "polyfills/function_bind",
    "polyfills/xdr"
  ], function(Base, ScrollPerf, Flamsteed) {

    $(function() {

      new Base({ secure: true });
      new ScrollPerf;

      window.lp.fs = new Flamsteed({
        events: window.lp.fs.buffer,
        u: $.cookies.get("lpUid")
      });

    });

  });
});
