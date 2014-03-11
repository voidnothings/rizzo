define([ "jquery", "lib/core/ads/interstitial", "lib/core/ads/double_mpu" ], function($, Interstitial, DoubleMPU) {

  "use strict";

  function AdUnit($target) {
    this.$target = $target;
    this.$iframe = $target.find("iframe");
    this._init();
  }

  AdUnit.prototype._init = function() {
    if (this.isEmpty()) {
      return;
    }

    this.$target.closest(".is-closed").removeClass("is-closed");

    var extension = this.$target("extension");

    if (extension && this.extensions[extension]) {
      this.extensions[extension].call(this);
    }
  };

  AdUnit.prototype.isEmpty = function() {
    if (this.$target.css("display") === "none") {
      return true;
    }

    var $iframe = this.$target.find("iframe").contents();

    // Sometimes DFP will return uesless 1x1 blank images
    // so we must check for them.
    return $iframe.find("img").width() === 1;
  };

  AdUnit.prototype.refresh = function() {
    var slot = this.$target.data("googleAdUnit");
    window.googletag.pubads().refresh([ slot ]);
  };

  AdUnit.prototype.extensions = {

    wallpaper: function() {
      var $link = this.$iframe.contents().find("#ad-link");

      if ($link.length) {
        this.$target.addClass("ad-interstitial");
        this.extension = new Interstitial(this.$target, $link);
      }
    },

    mpu: function() {
      var $container = this.$target.closest(".js-card-ad");

      if (this.$iframe.height() > $container.height()) {
        $container.addClass("ad-doubleMpu");
        this.extension = new DoubleMPU(this.$target, $container);
      }
    }

  };

  return AdUnit;

});
