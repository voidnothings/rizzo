define([ "jquery" ], function($) {

  "use strict";

  function AdInterstitial($target, $contents) {
    this.$target = $target;
    this.$contents = $contents.clone();

    this._init();
  }

  AdInterstitial.prototype._init = function() {
    var self = this,
        dimensions = this.$contents.data("adDimensions");

    this.$target.detach();

    this.$modal = $("<div class='ad-modal ad-interstitial-wrap is-faded-out'>");
    this.$close = $("<a href='#' class='close'>Close X</a>");
    this.$countdown = $("<span class='countdown'>Advertisement closes in <span id='timeleft'></span> seconds.</span>");

    this.$modal
      .css({
        position: "absolute",
        width: dimensions.width,
        height: dimensions.height
      })
      .append(this.$close, this.getHTML(), this.$countdown);

    this.$close.on("click", function(e) {
      e.preventDefault();
      self.close();
    });

    this.open();
  };

  AdInterstitial.prototype.getHTML = function() {
    return this.$contents
      .attr("target", "_blank")
      .removeAttr("id")
      .removeData("adDimensions")
      .get(0).outerHTML;
  };

  AdInterstitial.prototype.countdown = function() {
    var self = this,
        $timeleft = this.$countdown.find("span");

    this.timeout = 14;

    if (this.counter) {
      clearTimeout(this.counter);
    }

    this.counter = setTimeout(function() {
      self.timeout--;

      $timeleft.html(self.timeout);

      if (self.timeout === 0) {
        self.close();
      }
    }, 100);

    $timeleft.html(this.timeout);
  };

  AdInterstitial.prototype.center = function() {
    var $window = $(window);

    this.$modal.css({
      left: ($window.width() / 2) - (this.$modal.width() / 2),
      top: ($window.height() / 2) - (this.$modal.height() / 2)
    });
  };

  AdInterstitial.prototype.open = function() {
    var self = this;

    $(window)
      .on("keypress.interstitial", function(e) {
        if (e.keyCode === 27) {
          self.close();
        }
      })
      .on("resize.interstitial", function() {
        self.center();
      });

    this.$modal.appendTo(document.body).removeClass("is-faded-out");

    this.countdown();
    this.center();
  };

  AdInterstitial.prototype.close = function() {
    this.$modal.detach();
    clearTimeout(this.counter);
    $(window).off(".interstitial");
  };

  return AdInterstitial;

});
