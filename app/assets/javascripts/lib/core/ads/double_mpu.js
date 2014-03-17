define([ "jquery" ], function($) {

  "use strict";

  function DoubleMPU($target, $card) {
    this.$target = $target;
    this.$card = $card;
    this._init();
  }

  DoubleMPU.prototype._init = function() {
    var $grid = this.$card.closest(".js-stack"),
        $cards = $grid.find(".js-card"),
        position = this.$card.position(),
        cardsPerRow = Math.floor( $grid.width() / $cards.filter(".card--single").width() ),
        placeholderHTML = "<div class='card card--double ad--placeholder js-card' />";

    // Eliminate all cards preceding our ad element so we can place a dummy
    // element at the nth position *after* the current one using .eq()
    $cards
      .slice( $cards.index(this.$card) )
      .eq(cardsPerRow - 2)
      .after(placeholderHTML);

    this.$card
      .before(placeholderHTML)
      .css({
        position: "absolute",
        left: position.left,
        top: position.top
      });
  };

  return DoubleMPU;

});
