// takes a listener, a function and an optional delay
define([
  "lib/utils/feature_detect"
], function() {

  "use strict";

  return function(args) {
    var $listener = args.$listener,
      fn = args.fn,
      delay = args.delay;

    if (window.lp.supports.transitionend) {
      $listener.on(window.lp.supports.transitionend, function afterTransition() {
        fn();
        $listener.off(window.lp.supports.transitionend, afterTransition);
      });
    } else {
      setTimeout(fn, delay | 0);
    }
  };
});
