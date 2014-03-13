require([ "jquery", "public/assets/javascripts/lib/components/lightbox.js" ], function($, LightBox) {

  "use strict";

  describe("LightBox", function() {

    beforeEach(function() {
      loadFixtures("lightbox.html");
      window.lightbox = new LightBox({ el: ".js-lightbox-spec", customClass: "lightbox-foo" });
    });

    describe("Initialisation", function() {

      it("is defined", function() {
        expect(lightbox).toBeDefined();
      });

      it("appends the lightbox container", function() {
        expect($(".lightbox").length).toBe(1);
      });

      it("extends the flyout functionality", function() {
        expect(lightbox.close).toBeDefined();
      });

      it("defines a way to update the contents", function() {
        expect(lightbox._updateContent).toBeDefined();
      });

    });

    describe("Functionality", function() {

      it("can update the lightbox contents", function() {
        $("#js-row--content").trigger(":lightbox/updateContent", "Test content here.");

        expect($(".lightbox").html()).toBe("Test content here.");
      });

      it("centers the opened lightbox correctly", function() {
        $(".lightbox").height(600).width(800);
        lightbox._centerLightbox();

        expect($(".lightbox").css("margin-left")).toBe("-400px");
        expect($(".lightbox").css("margin-top")).toBe("-300px");
      });

      it("can add a custom class to the lightbox", function() {
        expect($(".lightbox")).toHaveClass("lightbox-foo");
      });

    });

  });
});
