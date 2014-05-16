// ------------------------------------------------------------------------------
//
// Cucumber
//
// ------------------------------------------------------------------------------

define([ "jquery" ], function($) {

  "use strict";

  function Cucumber() {
    this.$listener = $("#js-card-holder");
    this.init();
  }

  Cucumber.prototype.init = function() {
    this.listen();
  };

  // -------------------------------------------------------------------------
  // Subscribe to Events
  // -------------------------------------------------------------------------

  Cucumber.prototype.listen = function() {

    this.$listener.on(":cards/received", this._removeClockClass);
    this.$listener.on(":page/received", this._removeClockClass);
    this.$listener.on(":cards/append/received", this._removeClockClass);

  };

  // -------------------------------------------------------------------------
  // Private
  // -------------------------------------------------------------------------

  Cucumber.prototype._removeClockClass = function() {
    $("body").removeClass("js-clock");
  };

  return Cucumber;

});
