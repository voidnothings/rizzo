define(["jquery"], function($) {
  return function Swipe(options) {
    var config = $.extend({
      listener: $("#js-row--content"),
      selector: ".js-onswipe"
    }, options),

    listener = config.listener,

    // the selector that will be announcing on swipes
    selector = config.selector,

    $window = $(window),

    swipe = this,

    prevent = function(event) {
      event.preventDefault();
      return false;
    };

    swipe.isPointerTouchEvent = function(event) {
      return (event.pointerType && event.pointerType == "touch" || event.pointerType == "pen");
    };

    swipe.isW3CTouchEvent = function(event) {
      return (!!event.targetTouches || !!event.changedTouches);
    };

    swipe.getTarget = function(element) {
      element = listener.find(element);
      return element.is(selector)? element: element.closest(selector);
    };

    swipe.eventToPoint = function(event) {
      var point;

      if (swipe.isPointerTouchEvent(event) && event.buttons > 0)  {
        point = event;
      } else if (swipe.isW3CTouchEvent(event)) {
        event.changedTouched && event.changedTouched.length && (point = event.changedTouches[0]);
        event.targetTouches && event.targetTouches.length && (point = event.targetTouches[0]);
      } else {
        return false;
      }

      return {
        x: point.clientX,
        y: point.clientY
      };
    };

    // only for ie
    swipe.getScrollTop = function() {
      return (document.documentElement && document.documentElement.scrollTop) || document.body.scrollTop;
    }

    swipe.gestureBegins = function(event) {
      var target = swipe.getTarget(event.target);
      if (!target.length) return;
      event = event.originalEvent;
      swipe.scrollTop = swipe.getScrollTop();
      swipe.startPoint = swipe.eventToPoint(event);
    };

    swipe.gestureMoves = function(event) {
      var currentPoint, x, y, diff, target = swipe.getTarget(event.target);
      if (!target.length) return;
      event = event.originalEvent;
      currentPoint = swipe.eventToPoint(event);

      swipe.difference = {
        x: currentPoint.x - swipe.startPoint.x,
        y: currentPoint.y - swipe.startPoint.y
      };

      if (Math.abs(swipe.difference.x) > Math.abs(swipe.difference.y)) {
        $window.on("touchmove", prevent);
      } else if (swipe.isPointerTouchEvent(event)) {
        window.scrollTo(0, (-swipe.difference.y) + swipe.scrollTop);
      }
    };

    swipe.gestureEnds = function(event) {
      $window.off("touchmove", prevent);
      var threshold, target = swipe.getTarget(event.target);
      if (!target.length) return;
      threshold = target.data("swipe-threshold") || 10;

      if (swipe.difference) {
        if (swipe.difference.x < threshold) {
          target.trigger(":swipe/left");
        } else if (swipe.difference.x > threshold) {
          target.trigger(":swipe/right");
        }
      }

      if (swipe.isPointerTouchEvent(event.originalEvent)) {
        swipe.scrollTop = swipe.getScrollTop();
      }

      delete swipe.difference;
    };

    listener.on("touchstart pointerdown MSPointerDown", selector, swipe.gestureBegins);
    listener.on("touchmove pointermove MSPointerMove", selector, swipe.gestureMoves);
    listener.on("touchend touchleave pointerout MSPointerOut", selector, swipe.gestureEnds);
  };
});
