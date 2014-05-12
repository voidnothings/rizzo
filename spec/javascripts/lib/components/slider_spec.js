require([ "public/assets/javascripts/lib/components/slider.js" ], function(Slider) {
  describe("Slider", function() {

    var LISTENER = document,
    config = {
      animateDelay: 0,
      el: "#js-slider"
    };

    describe("object", function() {
      it("is defined", function() {
        expect(Slider).toBeDefined();
      });
    });

    describe("initialising", function() {
      beforeEach(function() {
        window.slider = new Slider(config);
        spyOn(slider, "init");
      });

      it("does not initialise when the parent element does not exist", function() {
        expect(slider.init).not.toHaveBeenCalled();
      });
    });

    describe("set up", function() {
      beforeEach(function() {
        loadFixtures("slider.html");
        window.slider = new Slider(config);
      });

      it("sets up the width of the container for all the slides", function() {
        expect($(".slider__container").width()).toBe(2135);
      });

      it("adds the next/prev links", function() {
        expect($(".slider__control--next").length).toBeGreaterThan(0);
        expect($(".slider__control--prev").length).toBeGreaterThan(0);
      });

      it("adds pagination links for the slides", function() {
        expect($(".slider__pagination").length).toBeGreaterThan(0);
      });

      it("adds a pagination link for each slide", function() {
        expect($(".slider__pagination--link").length).toEqual($(".slider__slide").length);
      });

      it("has the correct slides state", function() {
        expect($(".slider__control--next").html()).toBe("2 of 5");
      });

    });

    describe("standard functionality:", function() {
      beforeEach(function() {
        loadFixtures("slider.html");
        window.slider = new Slider(config);
      });

      it("updates the slide counter after navigating", function() {
        slider._nextSlide();
        expect($(".slider__control--next").html()).toBe("3 of 5");
        expect($(".slider__control--prev").html()).toBe("1 of 5");
      });

      it("updates the pagination after navigating", function() {
        slider._nextSlide();
        expect($(".slider__pagination--link").eq(0)).not.toHaveClass("is-active");
        expect($(".slider__pagination--link").eq(1)).toHaveClass("is-active");
      });

      it("goes to the next slide (first -> second)", function() {
        slider._nextSlide();
        expect($(".slider__container")[0].style.marginLeft).toBe("-100%");
      });

      it("goes to a given slide", function() {
        slider._goToSlide(4);
        expect($(".slider__container")[0].style.marginLeft).toBe("-300%");
      });

      it("goes to the previous slide (third -> second)", function() {
        slider._goToSlide(3);
        slider._previousSlide();
        expect($(".slider__container")[0].style.marginLeft).toBe("-100%");
      });

      it("knows when at the beginning", function() {
        expect($(".slider__viewport")).toHaveClass("at-beginning");
      });

      it("knows when at the end", function() {
        slider._goToSlide($(".slider__slide").length);
        expect($(".slider__viewport")).toHaveClass("at-end");
      });
    });

    describe("hidden dynamically loaded content", function() {
      beforeEach(function() {
        loadFixtures("slider_hidden_content.html");
        config.deferLoading = true;
        window.slider = new Slider(config);
        spyOnEvent($(slider.$el), ":asset/uncomment");
      });

      it("loads hidden content", function() {
        expect($(".slider__slide:nth-of-type(3) img").length).toBe(0);
        $(".slider__control--next").trigger("click");
        expect(":asset/uncomment").toHaveBeenTriggeredOn($(slider.$el), [ $(".slider__slide").slice(1), "[data-uncomment]" ]);
      });
    });
  });
});
