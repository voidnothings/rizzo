require(["public/assets/javascripts/lib/core/ad_unit"], function(AdUnit) {

  describe("Ad Unit", function() {

    var instance;

    beforeEach(function() {
      loadFixtures("ad_iframe.html");
      instance = new AdUnit($(".adunit"));
    });

    describe("._init()", function() {

      it ("Should remove 'is-closed' class from closest ancestor", function() {
        var $fixture = $(".is-closed");

        spyOn(instance, "isEmpty").andReturn(false);
        instance._init();

        expect($fixture.hasClass("is-closed")).toBe(false);
      });

    });

    describe(".isEmpty()", function() {

      it("Should return true if ad slot set to display none by DFP", function() {
        instance.$target.css("display", "none");
        expect(instance.isEmpty()).toBe(true);
      });

      it("Should return true if loaded ad is a 1x1 image", function() {
        instance.$target.find("iframe").contents().find("body").append("<img width='1' height='1' />");
        expect(instance.isEmpty()).toBe(true);
      });

      it("Should return false if an loaded ad is not a 1x1 image", function() {
        instance.$target.find("iframe").contents().find("body").append("<img width='728' height='90' />");
        expect(instance.isEmpty()).toBe(false);
      });

    });

  });

});
