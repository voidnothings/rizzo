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
      range: [ data.range.split(",")[0], this._getMaxRangeValue(data) ],
      start: [ data.current.split(",")[0], this._getMaxStartValue(data) ],
      handles: 2,
      connect: true,
      serialization: {
        resolution: 1,
        to: [
          [ $("[name='" + data.targets.split(",")[0] + "']"), this._setMinLabel ],
          [ this._setMaxValue, this._setMaxLabel ]
        ]
      }
    };
  };

  RangeSlider.prototype._getCapLevel = function(data) {
    return data.capLevel;
  };

  RangeSlider.prototype._getMaxRangeValue = function(data) {
    var max;
    if (this._getCapLevel(data)) {
      max = this._getCapLevel(data);
    }
    return max || data.range.split(",")[1];
  };

  RangeSlider.prototype._getMaxStartValue = function(data) {
    var max,
    current = data.current.split(",")[1];
    if (this._getCapLevel(data) && current > this._getCapLevel(data)) {
      max = this._getCapLevel(data);
    }
    return max || current;
  };

  // Called in the scope of the range slider component
  RangeSlider.prototype._setMinLabel = function(value) {
    var $min = $(this).next(".js-range-labels").find(".js-range-min");
    $min.text(value);
  };

  // Called in the scope of the range slider component
  RangeSlider.prototype._setMaxLabel = function(value) {
    var $this = $(this),
    $max = $this.next(".js-range-labels").find(".js-range-max");
    if (value == $this.data().capLevel) {
      value += " and above";
    }
    $max.text(value);
  };

  // Called in the scope of the range slider component
  RangeSlider.prototype._setMaxValue = function(value) {
    var data = $(this).data(),
        $target = $("[name='" + data.targets.split(",")[1] + "']");

    if (value == data.capLevel) {
      value = data.range.split(",")[1];
    }

    $target.val(value);
  };

  $(function() {
    rangeSlider = new RangeSlider();
  });

  return RangeSlider;

});
