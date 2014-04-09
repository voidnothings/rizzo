// ------------------------------------------------------------------------------
//
// Authenticator
//
// This script handles checking whether the user is signed in and generating
// the sign in/join links OR profile pic with sub menu (along with the right hand
// nav that appears on mobile).
//
// ------------------------------------------------------------------------------

define([ "jsmin", "lib/utils/asset_fetch", "lib/utils/template" ], function($, AssetFetch, Template) {
  "use strict";

  var Authenticator = function() {
    this.statusUrl = "https://www.lonelyplanet.com/thorntree/users/status";

    this.init();
  },
  _this;

  // -------------------------------------------------------------------------
  // Initialise
  // -------------------------------------------------------------------------
  Authenticator.prototype.init = function() {
    _this = this;

    if (!this.$template) {
      this.templateContainer = $("#js-user-nav-template");
      this.$template = document.createElement("div");
      this.$template.innerHTML = this.templateContainer.innerHTML;
    }

    AssetFetch.get(this.statusUrl, this._updateStatus);
  };

  // -------------------------------------------------------------------------
  // Private Functions
  // -------------------------------------------------------------------------

  Authenticator.prototype._createUserLinks = function() {
    var template = document.createElement("div");

    template.innerHTML = _this.$template.querySelector(".js-user-signed-out-template").innerHTML;

    // Remove any previously generated user navigation.
    $(".js-user-signed-in, .js-user-signed-out").remove();
    _this.templateContainer.parentNode.insertBefore(template, _this.templateContainer);
  };

  Authenticator.prototype._createUserMenu = function() {
    var template = _this.$template.querySelector(".js-user-signed-in-template").innerHTML,
        $rendered = document.createElement("div"),
        $userAvatar;

    $rendered.innerHTML = Template.render(template, window.lp.user);

    if (window.lp.user.unreadMessageCount > 0) {
      $rendered.querySelectorAll(".js-unread-messages").classList.remove("is-hidden");
    }

    // Remove any previously generated user navigation.
    $(".js-user-signed-in, .js-user-signed-out").remove();
    _this.templateContainer.after($rendered);

    $userAvatar = $(".js-user-avatar");
    $userAvatar.src = $userAvatar.dataset.src;
  };

  Authenticator.prototype._updateStatus = function(userStatus) {
    if (userStatus && userStatus.username) {
      window.lp.user = userStatus;
      _this._createUserMenu();
    } else {
      _this._createUserLinks();
    }
  };

  // Self instantiate
  new Authenticator();

  return Authenticator;

});
