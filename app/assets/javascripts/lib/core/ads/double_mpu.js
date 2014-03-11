define([ "jquery" ], function($) {

  "use strict";

  function DoubleMPU($target, $card) {
    this.$target = $target;
    this.$card = $card;
  }

  DoubleMPU.prototype._init = function() {
    this.$target.detach();

    var $grid = this.$card.closest(".js-stack"),
        $cards = $grid.find(".js-card"),
        position = this.$card.position(),
        cardsPerRow = Math.floor( $grid.width() / $cards.filter(".card--single").width() );

    // Eliminate all cards preceding our ad element so we can place a dummy
    // element at the nth position *after* the current one using .eq()
    $cards = $cards.slice( $cards.index(this.$card) );

    // cardsPerRow - 2 because the MPU is the width of 2 cards.
    $cards.eq(cardsPerRow - 2).after("<div class='card card--double ad--placeholder js-card' />");

    this.$card.css({
      position: "absolute",
      left: position.left,
      top: position.top
    });
  };

  return DoubleMPU;

});
