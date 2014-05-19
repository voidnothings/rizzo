require([ "public/assets/javascripts/lib/components/proximity_loader.js" ], function(ProximityLoader) {

  var config = {
    list: ".js-loader-one, .js-loader-two, .js-loader-three",
    success: ":foo/bar",
    debounce: 0
  };

  describe("Proximity Loader", function() {
    describe("Object", function() {
      it("is defined", function() {
        expect(ProximityLoader).toBeDefined();
      });
    });

    describe("Initialisation", function() {
      beforeEach(function() {
        loadFixtures("proximity_loader.html");
        window.proximityLoader = new ProximityLoader(config);
        spyOn(proximityLoader, "_check");
        spyOn(proximityLoader, "_getViewportEdge").andReturn(0);
        proximityLoader.constructor(config);
      });

      it("creates an object of positions and thresholds for each element", function() {
        expect(window.proximityLoader.targets[0].top).toEqual(100);
        expect(window.proximityLoader.targets[0].threshold).toEqual(50);
        expect(window.proximityLoader.targets[1].top).toEqual(200);
        expect(window.proximityLoader.targets[1].threshold).toEqual(50);
        expect(window.proximityLoader.targets[2].top).toEqual(300);
        expect(window.proximityLoader.targets[2].threshold).toEqual(50);
      });

      it("checks to see if we have any elements that require scripts loading", function() {
        expect(proximityLoader._check).toHaveBeenCalled();
      });
    });

    describe("Scrolling", function() {
      beforeEach(function() {
        loadFixtures("proximity_loader.html");
        window.proximityLoader = new ProximityLoader(config);
        spyOn(proximityLoader, "_check");
        spyOn(proximityLoader, "_getViewportEdge").andReturn(150);
        $(window).trigger("scroll");
        waits(100);
      });

      it("calls _check", function() {
        expect(proximityLoader._check).toHaveBeenCalled();
      });
    });

    describe("Firing the success event when required", function() {
      beforeEach(function() {
        loadFixtures("proximity_loader.html");
        window.proximityLoader = new ProximityLoader(config);
        spyOn(proximityLoader, "_getViewportEdge").andReturn(150);
      });

      it("triggers the asset reveal event with the element and the classname", function() {
        var spyEvent = spyOnEvent(proximityLoader.$el, ":foo/bar");
        proximityLoader.constructor(config);
        expect(":foo/bar").toHaveBeenTriggeredOn(proximityLoader.$el);
      });
    });

  });

});
