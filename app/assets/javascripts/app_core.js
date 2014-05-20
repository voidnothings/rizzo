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

      new Base;
      new ScrollPerf;

      // Currently we can"t serve Flamsteed over https because of f.staticlp.com
      // New community is using this file rather than app_secure_core
      // https://trello.com/c/2RCd59vk/201-move-f-staticlp-com-off-cloudfront-and-on-to-fastly-so-we-can-serve-over-https
      if (window.location.protocol !== "https:") {
        window.lp.fs = new Flamsteed({
          events: window.lp.fs.buffer,
          u: $.cookies.get("lpUid")
        });
      }

      require([ "sailthru" ], function() {
        window.Sailthru.setup({ domain: "horizon.lonelyplanet.com" });
      });

    });

  });
});
