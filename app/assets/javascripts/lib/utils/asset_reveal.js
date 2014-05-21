define([ "jquery" ], function($) {

  "use strict";

  var defaults = {
    el: "#js-row--content"
  };

  function AssetReveal(args) {
    this.config = $.extend({}, defaults, args);
    this.$el = $(this.config.el);

    this.$el.length && this._listen();
  }

  AssetReveal.prototype._listen = function() {
    var _this = this;

    this.$el.on(":asset/uncomment", function(e, elements, selector) {
      if (e.data) {
        elements = e.data[0];
        selector = e.data[1];
      }

      _this._uncomment(elements, selector || "[data-uncomment]");
    });

    this.$el.on(":asset/uncommentScript", function(e, elements, selector) {
      if (e.data) {
        elements = e.data[0];
        selector = e.data[1];
      }

      _this._uncommentScript(elements, selector || "[data-script]");
    });

    this.$el.on(":asset/loadBgImage", function(e, elements) {
      _this._loadBgImage(elements);
    });

    this.$el.on(":asset/loadDataSrc", function(e, elements) {
      _this._loadDataSrc(elements);
    });
  };

  AssetReveal.prototype._removeComments = function(html) {
    return html.replace("<!--", "").replace("-->", "");
  };

  AssetReveal.prototype._uncomment = function(elements, selector) {
    var i, len, inner, $element,
        $elements = $(elements).find(selector);

    for (i = 0, len = $elements.length; i < len; i++) {
      $element = $elements.eq(i);
      inner = this._removeComments($element.html());
      $element.before(inner).remove();
    }
  };

  AssetReveal.prototype._uncommentScript = function(elements, selector) {
    var i, len, inner, $element,
        $elements = $(elements).find(selector);

    for (i = 0, len = $elements.length; i < len; i++) {
      $element = $elements.eq(i);
      inner = this._removeComments($element.html());
      $element.html(inner);
    }
  };

  AssetReveal.prototype._loadBgImage = function(elements) {
    var $elements = $(elements),
        blockedBG = "rwd-image-blocker";

    if ($elements.hasClass(blockedBG)) {
      $elements.removeClass(blockedBG);
    } else {
      $elements.find("." + blockedBG).removeClass(blockedBG);
    }
  };

  AssetReveal.prototype._loadDataSrc = function(elements) {
    var i, len, data, prop, $element, $img,
        $elements = $(elements);

    for (i = 0, len = $elements.length; i < len; i++) {
      $element = $elements.eq(i);

      if (!$element.data("src")) {
        $element = $element.find("[data-src]");
      }

      data = $element.data();

      if (!data) {
        continue;
      }

      $img = $("<img />");

      for (prop in data) {
        if (data.hasOwnProperty(prop)) {
          $img.attr(prop, data[prop]);
        }
      }

      $element.replaceWith($img);
    }
  };

  return AssetReveal;

});
