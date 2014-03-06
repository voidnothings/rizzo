require([ "jquery" ], function($) {
  "use strict";

  $("body").prepend("<div class='lightbox is-closed js-lightbox-toggle'><img src='http://assets.staticlp.com/assets/rizzo-sloth-404.jpg' height='600' width='800' /></div>");
  $(".js-lightbox-toggle").on("click", function(e) {
    $(".lightbox").toggleClass("is-open is-closed");
    e.preventDefault();
    return false;
  });
});
