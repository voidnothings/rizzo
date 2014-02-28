define(["jquery"], function($) {

  return function() {
    require(["dfp"], function() {

      var networkID = 4817;

      var lpConfig = window.lp.ads || {};

      var keywords = {
        "ctt": lpConfig.continent,
        "cnty": lpConfig.country,
        "dest": lpConfig.destination,
        "thm": lpConfig.adThm,
        "tnm": lpConfig.adTnm ? lpConfig.adTnm.replace(/\s/, "").split(",") : ""
      };

      if (!$.isEmptyObject(lpConfig.keyValues)) {
        for (var key in lpConfig.keyValues) {
          if (lpConfig.keyValues.hasOwnProperty(key)) {
            keywords[key] = lpConfig[key];
          }
        }
      }

      function isAdEmpty($adunit) {
        if ($adunit.css("display") === "none") {
          return true;
        }

        var $iframe = $adunit.find("iframe").contents();

        // Sometimes DFP will return uesless 1x1 blank images
        // so we must check for them.
        return $iframe.find("img").width() === 1;
      }

      function adCallback($adunit) {
        if (!isAdEmpty($adunit)) {
          $adunit.closest('.is-closed').removeClass('is-closed');
        }

        // TODO: analytics here
      };

      $.dfp({
        dfpID: networkID,
        setTargeting: keywords,
        namespace: lpConfig.layers ? lpConfig.layers.join("/") : "",
        collapseEmptyDivs: true,
        enableSingleRequest: false,
        afterEachAdLoaded: adCallback
      });

    });
  };

});
