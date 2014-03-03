require(["public/assets/javascripts/lib/core/ad_manager_v2"], function(AdManager) {

  describe("Ad Manager v2", function() {

    var instance;

    beforeEach(function() {
      loadFixtures("ad_iframe.html");
      instance = new AdManager(123456, {});
    });

    describe("._init()", function() {

      it("Loads and instantiates jQuery DFP", function() {

        spyOn(instance, "_adCallback").andReturn(null);

        runs(function() {
          instance._init();
        });

        waitsFor(function() {
          return $.hasOwnProperty("dfp");
        }, "DFP should be loaded", 250);

        runs(function() {
          expect($('.adunit').hasClass("display-none")).toBe(true);
        });

      });

    });

    describe(".formatKeywords()", function() {

      it("Should return the instance config formatted for jQuery.dfp targeting", function() {
        var config = instance.config = {
          "continent": "europe",
          "country": "france",
          "city": "destination",
          "adThm": "honeymoons,world-food",
          "adTnm": "overview,poi-list",
          "keyValues": {
            "foo": "bar"
          }
        };

        var result = instance.formatKeywords();

        expect(result.ctt).toEqual(config.continent);
        expect(result.cnty).toEqual(config.country);
        expect(result.dest).toEqual(config.destination);
        expect(result.tnm).toEqual(config.adTnm.split(","));
        expect(result.foo).toEqual(config.keyValues.foo);
      });
    });

  });

});
