define([ "jquery" ], function($) {

  "use strict";

  var EventEmitter = {

    _JQInit: function() {
      this._JQ = $(this);
    },

    trigger: function(evt, data) {
      this.$el.trigger(evt, data);
    },

    triggerNative: function(elem, evt, data) {
      if (!document.createEvent("Event")) {
        return false;
      }

      var customEvent = document.createEvent("Event");
      customEvent.data = data;

      customEvent.initEvent(evt, true, true);
      elem.dispatchEvent(customEvent);
    },

    on: function(evt, handler) {
      this._JQ || this._JQInit();
      this._JQ.on(evt, handler);
    },

    off: function(evt, handler) {
      this._JQ || this._JQInit();
      this._JQ.off(evt, handler);
    }

  };

  return EventEmitter;

});
