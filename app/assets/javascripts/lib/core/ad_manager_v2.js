define([ "jquery", "lib/core/ad_unit", "dfp" ], function($, AdUnit) {

  "use strict";

  // var networkID = 9885583;
  var networkID = 4817;

  function AdManager(config) {
    this.$listener = $(config.$listener || "#js-row--content");
    this.config = config;
    this.loadedAds = [];
    this._init();
  }

  AdManager.prototype._init = function() {
    var self = this;

    function boundCallback($adunit) {
      self._adCallback.call(self, $adunit);
    }

    $.dfp({
      dfpID: this.config.networkID || networkID,
      setTargeting: this.formatKeywords(),
      namespace: this.config.layers.join("/"),
      collapseEmptyDivs: true,
      enableSingleRequest: false,
      afterEachAdLoaded: boundCallback
    });

    this.$listener.on(":ads/refresh", function(e, type) {
      self.refresh(type);
    });
  };

  AdManager.prototype._adCallback = function($adunit) {
    this.loadedAds.push(new AdUnit($adunit));
    // TODO: analytics here
  };

  AdManager.prototype.formatKeywords = function() {
    var keywords = {
      thm: this.config.theme || this.config.adThm,
      tnm: (this.config.template || this.config.adTnm).replace(/\s/, "").split(",")
    };

    if (this.config.keyValues && !$.isEmptyObject(this.config.keyValues)) {
      for (var key in this.config.keyValues) {
        if (this.config.keyValues.hasOwnProperty(key)) {
          keywords[key] = this.config.keyValues[key];
        }
      }
    }

    return keywords;
  };

  AdManager.prototype.refresh = function(type) {
    if (type) {
      for (var i = 0, len = this.loadedAds.length; i < len; i++) {
        if (this.loadedAds[i].getType() === type) {
          this.loadedAds[i].refresh();
        }
      }
    } else {
      window.googletag.pubads().refresh();
    }
  };

  return AdManager;

});
