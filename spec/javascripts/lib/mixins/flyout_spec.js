require([ "jquery", "public/assets/javascripts/lib/mixins/flyout.js" ], function($, asFlyout) {

  "use strict";

  describe("Flyout Mixin", function() {

    var flyout = asFlyout.call({}, "#js-ttd-spec");

    describe("counts", function() {
      it("regular filters", function() {
        var count = flyout.countFilters({
          foo: true,
          bar: true
        });
        expect(count).toBe(2);
      }),
      it("deep filters", function() {
        var count = flyout.countFilters({
          foo: true,
          bar: {
            x: true,
            y: true
          }
        });
        expect(count).toBe(3);
      });
    });

    describe("updates the facet count", function() {

      describe("when there are no filters", function() {
        beforeEach(function() {
          spyOn(flyout, "countFilters").andReturn(0);
        });

        it("clears the filter", function() {
          expect(flyout.updateFilters()).toBe("");
        });
      });
      describe("when there are two filters", function() {
        beforeEach(function() {
          spyOn(flyout, "countFilters").andReturn(2);
        });
        it("updates", function() {
          expect(flyout.updateFilters()).toBe("(2)");
        });
      });

    });

  });
});
