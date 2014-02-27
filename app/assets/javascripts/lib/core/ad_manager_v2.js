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

      $.dfp({
        dfpID: networkID,
        setTargeting: keywords,
        namespace: lpConfig.layers ? lpConfig.layers.join("/") : "",
        collapseEmptyDivs: true,
        enableSingleRequest: false
      });

    });
  };

});
