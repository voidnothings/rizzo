define([ "jquery", "lib/core/ad_unit" ], function($, AdUnit) {

  "use strict";

  var defaultConfig = {
    // networkID: 9885583,
    networkID: 4817,
    adunits: ".adunit",
    listener: "#js-row--content",
    layers: [ "2009.lonelyplanet" ],
    adThm: "",
    adTnm: "",
    topic: ""
  };

  function AdManager(config) {
    this.config = $.extend({}, defaultConfig, config);
    this.$adunits = $(this.config.adunits);
    this.$listener = $(this.config.listener);
    this.loadedAds = [];
    this._init();
  }

  AdManager.prototype._init = function() {
    var self = this,
        bodyWidth = $("body").width();

    // TODO: a proper responsive implementation
    this.$adunits = this.$adunits.filter(function(index) {
      var filteredGroups = [],
          $adunit = self.$adunits.eq(index),
          sizeGroups = $adunit.data("dimensions").split(",");

      for (var i = 0, len = sizeGroups.length; i < len; i++) {
        var sizeSet = sizeGroups[i].split("x");

        if (parseInt(sizeSet[0], 10) < bodyWidth) {
          filteredGroups.push(sizeGroups[i]);
        }
      }

      $adunit.data("dimensions", filteredGroups.join(","));

      return filteredGroups.length;
    });

    function boundCallback($adunit) {
      self._adCallback.call(self, $adunit);
    }

    require([ "dfp" ], function() {

      self.$adunits.dfp({
        dfpID: self.config.networkID,
        setTargeting: self.formatKeywords(),
        namespace: self.config.layers.join("/"),
        collapseEmptyDivs: true,
        enableSingleRequest: false,
        afterEachAdLoaded: boundCallback
      });

      self.$listener.on(":ads/refresh", function(e, type) {
        self.refresh(type);
      });

    });
  };

  AdManager.prototype._adCallback = function($adunit) {
    this.loadedAds.push(new AdUnit($adunit));
    // TODO: analytics here
  };

  AdManager.prototype.formatKeywords = function() {
    var keywords = {
      topic: this.config.topic,
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
