define(["jquery", "lib/core/ad_unit"], function($, AdUnit) {


  function AdManager(networkID, config) {
    this.networkID = networkID;
    this.config = config;
    this.loadedAds = [];
    this._init();
  }

  AdManager.prototype._init = function() {
    var self = this;

    require(["dfp"], function() {

      function boundCallback($adunit) {
        self._adCallback.call(self, $adunit);
      }

      $.dfp({
        dfpID: self.networkID,
        setTargeting: self.formatKeywords(),
        namespace: self.config.layers ? self.config.layers.join("/") : "",
        collapseEmptyDivs: true,
        enableSingleRequest: false,
        afterEachAdLoaded: boundCallback
      });

    });
  };

  AdManager.prototype._adCallback = function($adunit) {
    this.loadedAds.push(new AdUnit($adunit));
    // TODO: analytics here
  };

  AdManager.prototype.formatKeywords = function() {
    var keywords = {
      "ctt": this.config.continent,
      "cnty": this.config.country,
      "dest": this.config.destination,
      "thm": this.config.adThm,
      "tnm": this.config.adTnm ? this.config.adTnm.replace(/\s/, "").split(",") : ""
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

  return AdManager;

});
