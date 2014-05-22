define([ "jquery" ], function($) {

  "use strict";

  var Msg = function(args) {
    this.args = args || {};
    this.options = {
      target: "body",
      delay: 1000
    };
    this.$target = $(this.options.target);
    this.add(this.build(this.args.content));
  };

  Msg.prototype.build = function() {
    return this.msg = "<div class='row row--fluid " + this.args.style + "'>" +
                        "<div class='wv--split--left cookie-msg'>" + this.args.content + "</div>" +
                        "<div class='wv--split--right cookie-buttons'>" + (this.userOptions(this.args.userOptions)) + "</div>" +
                      "</div>";
  };

  Msg.prototype.userOptions = function(options, output) {
    output = output || "";

    if (!options.close) {
      output += "<a class='btn btn--slim btn--green js-close-msg'>No worries</a>";
    }

    if (!options.more) {
      return output += "<a class='btn btn--slim btn--grey js-more-msg' href='http://www.lonelyplanet.com/legal/cookies/'>Learn more</a>";
    }
  };

  Msg.prototype.add = function(el) {
    var onAdd;

    this.$target.prepend(el);

    el.find("a.js-close-msg").on("click", function(event) {
      return this.removeMsg(event);
    }.bind(this));

    if (this.args.delegate && (onAdd = this.args.delegate.onAdd())) {
      return onAdd;
    }
  };

  Msg.prototype.removeMsg = function() {
    var onRemove;

    this.$target.find("div." + this.args.style).remove();

    if (this.args.delegate && (onRemove = this.args.delegate.onRemove())) {
      return onRemove;
    }
  };

  return Msg;
});
