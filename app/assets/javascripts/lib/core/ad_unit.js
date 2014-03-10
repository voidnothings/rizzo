define(["jquery"], function($) {

  function AdUnit($target) {
    this.$target = $target
    this._init();
  }

  AdUnit.prototype._init = function() {
    if (!this.isEmpty()) {
      this.$target.closest('.is-closed').removeClass('is-closed');
    }
  };

  AdUnit.prototype.isEmpty = function() {
    if (this.$target.css("display") === "none") {
      return true;
    }

    var $iframe = this.$target.find("iframe").contents();

    // Sometimes DFP will return uesless 1x1 blank images
    // so we must check for them.
    return $iframe.find("img").width() === 1;
  };

  return AdUnit;

});
