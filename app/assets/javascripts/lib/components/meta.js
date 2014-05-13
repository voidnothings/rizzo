define([ "jquery" ], function($) {

  "use strict";

  var Meta = function() {
    _this = this;
    this.$listener = $("#js-card-holder");
    this.listen();
  },
  _this;

  Meta.prototype.listen = function() {
    this.$listener.on(":cards/received", this._received);
    this.$listener.on(":page/received", this._received);
  };

  // Private

  Meta.prototype._received = function(e, data) {
    if (data.copy && data.copy.title){
      _this._updateTitle(data.copy.title);
      _this._updateMeta(data);
    }
  };

  Meta.prototype._updateTitle = function( title ) {
    document.title = title;
  };

  Meta.prototype._updateMeta = function( data ) {
    $("meta[name='title']").attr("content", data.copy.title);
    $("meta[name='description']").attr("content", data.copy.description);
  };

  return Meta;

});
