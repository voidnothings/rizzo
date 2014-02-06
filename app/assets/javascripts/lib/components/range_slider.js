define([ "jquery", "nouislider/jquery.nouislider" ], function($) {

  "use strict";

  var RangeSlider = function() {
    this.sliders = $(".js-range-slider");
    this._initSliders();
  },
  rangeSlider;

  RangeSlider.prototype._initSliders = function() {
    var _this = this;
    this.sliders.each(function() {
      var $slider = $(this);
      $slider.noUiSlider(_this._getConfig($slider.data()));
    });
  };

  RangeSlider.prototype._getConfig = function(data) {
    return {
      range: [ data.range.split(",")[0], data.range.split(",")[1] ],
      start: [ data.current.split(",")[0], data.current.split(",")[1] ],
      handles: 2,
      connect: true,
      serialization: {
        resolution: 1,
        to: [
          [ $("[name='" + data.targets.split(",")[0] + "']") ],
          [ $("[name='" + data.targets.split(",")[1] + "']") ]
        ]
      }
    };
  };

  $(function() {
    rangeSlider = new RangeSlider();
  });

  return RangeSlider;

});
