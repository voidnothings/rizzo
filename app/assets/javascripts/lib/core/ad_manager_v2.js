define(["jquery"], function($) {

  function AdUnit($target) {
    this.$target = $target
    this._init();
  }

  AdUnit.prototype._init = function() {
    if (!this.isEmpty()) {
      this.$target.closest('.is-closed').removeClass('is-closed');
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

  function AdManager(networkID, config) {
    this.networkID = networkID;
    this.config = config;
    this.loadedAds = [];
    this._init();
  }

  AdManager.prototype._init = function() {
    var self = this;

    require(["dfp"], function() {

      function adLoadedCallback($adunit) {
        self.loadedAds.push(new AdUnit($adunit));
        // TODO: analytics here
      }

      $.dfp({
        dfpID: self.networkID,
        setTargeting: self.keywords(),
        namespace: self.config.layers ? self.config.layers.join("/") : "",
        collapseEmptyDivs: true,
        enableSingleRequest: false,
        afterEachAdLoaded: adLoadedCallback
      });

    });
  };

  AdManager.prototype.keywords = function() {
    var keywords = {
      "ctt": this.config.continent,
      "cnty": this.config.country,
      "dest": this.config.destination,
      "thm": this.config.adThm,
      "tnm": this.config.adTnm ? this.config.adTnm.replace(/\s/, "").split(",") : ""
    };

    if (!$.isEmptyObject(this.config.keyValues)) {
      for (var key in config.keyValues) {
        if (this.config.keyValues.hasOwnProperty(key)) {
          keywords[key] = this.config[key];
        }
      }
    }

    return keywords;
  };

  return AdManager;

});
