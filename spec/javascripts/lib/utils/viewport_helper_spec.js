require([ "jquery", "public/assets/javascripts/lib/page/viewport_helper.js" ], function($, asViewportHelper) {

  "use strict";

  describe("asViewportHelper", function() {

    describe("Initialisation", function() {

      it("is defined", function() {
        expect(asViewportHelper).toBeDefined();
      });

    });

    describe("Functionality", function() {

      beforeEach(function() {
        spyOn(asViewportHelper, "_getWindow").andReturn({
          height: function() { return 600; },
          scrollLeft: function() { return 100; },
          scrollTop: function() { return 100; },
          width: function() { return 800; }
        });
      });

      it("returns an object with the correct dimensions", function() {
        var viewport = asViewportHelper.viewport();

        expect(viewport.width).toBe(800);
        expect(viewport.height).toBe(600);
        expect(viewport.top).toBe(100);
        expect(viewport.left).toBe(100);
        expect(viewport.right).toBe(900);
        expect(viewport.bottom).toBe(700);
      });

      it("knows whether an element is within the viewport", function() {
        var elStub = {
          offset: function() {
            return {
              bottom: 0,
              left: 150,
              right: 0,
              top: 150
            };
          },
          outerHeight: function() { return 50; },
          outerWidth: function() { return 50; }
        };

        expect(asViewportHelper.withinViewport(elStub)).toBe(true);
      });

      it("knows whether an element is outside the viewport", function() {
        var elStub = {
          offset: function() {
            return {
              bottom: 0,
              left: 0,
              right: 0,
              top: 1000
            };
          },
          outerHeight: function() { return 50; },
          outerWidth: function() { return 50; }
        };

        expect(asViewportHelper.withinViewport(elStub)).toBe(false);
      });

    });

  });
});
