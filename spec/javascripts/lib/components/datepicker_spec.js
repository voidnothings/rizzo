require([ "jquery", "public/assets/javascripts/lib/components/datepicker.js" ], function($, Datepicker) {

  "use strict";

  describe("Datepicker", function() {


    describe("Initialisation", function() {

      it("is defined", function() {
        var datepicker = new Datepicker({});
        expect(datepicker).toBeDefined();
      });

    });

    describe("Functionality", function() {

      beforeEach(function() {
        loadFixtures("datepicker.html");
      });

      it("gets set up with empty fields", function() {
        new Datepicker({ target: ".js-standard" });

        expect($(".picker").length).toBe(2);
      });

      it("fires a given 'onDateSelect' callback when a date is selected", function() {
        var config = {
          callbacks: {
            onDateSelect: function() {}
          },
          target: ".js-standard"
        };

        spyOn(config.callbacks, "onDateSelect");

        new Datepicker(config);

        $("#js-av-start").trigger("focus");
        $(".picker--opened .picker__day--today").trigger("click");

        expect(config.callbacks.onDateSelect).toHaveBeenCalled();
      });

      it("selecting an 'end' date before the selected 'start' date updates the 'start' date to the day before", function() {
        var expected, selected;

        new Datepicker({
          target: ".js-standard"
        });

        $("#js-av-start").trigger("focus");
        $(".js-start-container .picker__day--infocus:not(.picker__day--disabled)").eq(5).trigger("click");

        $("#js-av-end").trigger("focus");
        $(".js-end-container .picker__day--infocus:not(.picker__day--disabled)").eq(4).trigger("click");

        $("#js-av-start").trigger("focus");
        selected = $(".js-start-container .picker__day--selected");
        // .eq(4) because `today` isn't an option in the `#js-av-end` field.
        expected = $(".js-start-container .picker__day--infocus:not(.picker__day--disabled)").eq(4);

        expect(selected.html()).toBe(expected.html());
      });

      it("selecting a 'start' date after the selected 'end' date updates the 'end' date to the day after", function() {
        var expected, selected;

        new Datepicker({
          target: ".js-standard"
        });

        $("#js-av-end").trigger("focus");
        $(".js-end-container .picker__day--infocus:not(.picker__day--disabled)").eq(4).trigger("click");

        $("#js-av-start").trigger("focus");
        $(".js-start-container .picker__day--infocus:not(.picker__day--disabled)").eq(5).trigger("click");

        $("#js-av-end").trigger("focus");
        selected = $(".js-end-container .picker__day--selected");
        // .eq(5) because `today` isn't an option in the `#js-av-end` field.
        expected = $(".js-end-container .picker__day--infocus:not(.picker__day--disabled)").eq(5);

        expect(selected.html()).toBe(expected.html());
      });

      it("can limit searching to only be in the past", function() {
        var sibling;

        new Datepicker({
          backwards: true,
          target: ".js-standard"
        });

        $("#js-av-start").trigger("focus");
        sibling = $(".picker--opened .picker__day--today").closest("td").next().find(".picker__day");

        expect(sibling).toHaveClass("picker__day--disabled");
      });

    });

  });
});
