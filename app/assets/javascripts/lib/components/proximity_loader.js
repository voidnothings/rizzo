define([ "jquery", "lib/extends/events", "lib/utils/debounce" ], function($, EventEmitter, debounce) {

  "use strict";

  var defaults = {
    el: "#js-row--content",
    list: null,
    klass: null,
    success: ":asset/uncomment",
    threshold: 500,
    debounce: 200
  };

  function ProximityLoader(args) {
    this.config = $.extend({}, defaults, args);
    this.$el = $(this.config.el);

    if (this.$el.length) {
      this._init();
    }
  }

  $.extend(ProximityLoader.prototype, EventEmitter);

  ProximityLoader.prototype._init = function() {
    this.targets = this._setupElements(this.$el.find(this.config.list));
    this._check();
    this._watch();
  };

  ProximityLoader.prototype._setupElements = function($elements) {
    var _this = this,
        elements = [];

    $elements.each(function(i) {
      var $element = $elements.eq(i);

      elements.push({
        $el: $element,
        top: $element.offset().top,
        threshold: parseInt($element.data("threshold") || _this.config.threshold, 10)
      });
    });

    return elements;
  };

  ProximityLoader.prototype._getViewportEdge = function() {
    var scrolled = window.pageYOffset ? window.pageYOffset : document.documentElement.scrollTop;
    return scrolled + document.documentElement.clientHeight;
  };

  ProximityLoader.prototype._watch = function() {
    var _this = this;

    $(window).on("scroll", debounce(function() {
      _this._check();
    }, this.config.debounce));
  };

  ProximityLoader.prototype._check = function() {
    var i, len, target,
        targets = [],
        viewport = this._getViewportEdge();

    for (i = 0, len = this.targets.length; i < len; i++) {
      target = this.targets[i];

      if ((target.top - target.threshold) <= viewport) {
        this.trigger(this.config.success, [ target.$el, this.config.klass ]);
      } else {
        targets.push(target);
      }
    }

    this.targets = targets;
  };

  return ProximityLoader;

});
