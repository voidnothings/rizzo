// ------------------------------------------------------------------------------
//
// Datepicker
//
// ------------------------------------------------------------------------------

define([ "jquery", "pickadate/lib/picker", "pickadate/lib/picker.date", "pickadate/lib/legacy" ], function($) {

  "use strict";

  var config = {
    callbacks: {},
    dateFormat: "d mmm yyyy",
    dateFormatLabel: "yyyy/mm/dd",
    listener: "#js-row--content",
    startSelector: "#js-av-start",
    endSelector: "#js-av-end",
    startLabelSelector: ".js-av-start-label",
    endLabelSelector: ".js-av-end-label"
  };

  // @args = {}
  // el: {string} selector for parent element
  // listener: {string} selector for the listener
  function Datepicker(args) {
    $.extend(config, args);

    this.$listener = $(config.listener);
    this.$el = $(config.el);
    this.$el && this.init();
  }

  Datepicker.prototype.init = function() {
    var today = [],
        tomorrow = [],
        d = new Date(),
        inOpts, outOpts;

    this.inDate = $(config.target).find(config.startSelector);
    this.outDate = $(config.target).find(config.endSelector);
    this.inLabel = $(config.startLabelSelector);
    this.outLabel = $(config.endLabelSelector);
    this.firstTime = this.inDate.val() ? false : true;
    this.day = 86400000;

    today.push(d.getFullYear(), d.getMonth(), d.getDate());
    tomorrow.push(d.getFullYear(), d.getMonth(), (d.getDate() + 1));

    inOpts = {
      format: config.dateFormat,
      onSet: function() {
        this._dateSelected(this.get("select", config.dateFormatLabel), "start");
      }.bind(this)
    };
    outOpts = {
      format: config.dateFormat,
      onSet: function() {
        this._dateSelected(this.get("select", config.dateFormatLabel), "end");
      }.bind(this)
    };

    if (config.backwards) {
      inOpts.max = today;
      outOpts.max = today;
    } else {
      inOpts.min = today;
      outOpts.min = tomorrow;
    }

    this.inDate.pickadate(inOpts);
    this.outDate.pickadate(outOpts);
  };

  // -------------------------------------------------------------------------
  // Private Functions
  // -------------------------------------------------------------------------

  Datepicker.prototype._dateSelected = function(date, type) {
    if (type === "start") {
      if (!this._isValidEndDate()) {
        this.outDate.data("pickadate").set("select", new Date(date).getTime() + this.day);
      }
      this.inLabel.text(date);
    } else if (type === "end") {
      if (!this._isValidEndDate() || this.firstTime) {
        this.inDate.data("pickadate").set("select", new Date(date).getTime() - this.day);
      }
      this.outLabel.text(this.outDate.val()).removeClass("is-hidden");
    }

    this.firstTime = false;

    if (config.callbacks.onDateSelect) {
      config.callbacks.onDateSelect(date, type);
    }
  };

  Datepicker.prototype._inValue = function() {
    new Date($(this.inDate).data("pickadate").get("select", config.dateFormatLabel));
  };

  Datepicker.prototype._outValue = function() {
    new Date($(this.outDate).data("pickadate").get("select", config.dateFormatLabel));
  };

  Datepicker.prototype._isValidEndDate = function() {
    this._inValue() < this._outValue();
  };

  return Datepicker;

});
