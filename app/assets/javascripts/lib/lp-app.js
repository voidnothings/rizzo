(function() {
  window.lpGlobal = (function($) {
    var self = {};
    if (window.lp && lp.ads){
      self.adZone = window.lp.ads.adZone;
      self.adKeywords = window.lp.ads.adKeywords;
      self.tile = window.lp.ads.tile;
      self.segQS = window.lp.ads.segQS;
    }
    
    self.init = function() {
      self.onLoad();
    };

    self.onLoad = function(){
      var _this_ = this;
      if (window.addEventListener){
        window.addEventListener('load', function(){_this_.start();},false);
      } else if (window.attachEvent){
        window.attachEvent('onload', function(){_this_.start();});
      }
    };

    self.start = function() {
      self.destinationsNav();
      self.userStatus();
      self.showShoppingCart();
      self.loadBreadcrumbs();
      self.bindBaseEvents();
      self.bindDetailViewEvents();
      // self.setupOmnitureUserInfo();
      self.loadLeaderBoard();
    };

    self.destinationsNav = function(){
      var script = document.createElement('script');
      script.src = "http://www.lonelyplanet.com/global-navigation";
      script.async = true;
      var s = document.getElementsByTagName('script')[0];
      s.parentNode.insertBefore(script, s);
    };

    self.userStatus = function(){
      var lpLoggedInUsername;
      var auth = new Lp.Authentication();
      window.auth = auth;
      var script = document.createElement('script');
      script.src = "https://secure.lonelyplanet.com/sign-in/status";
      script.async = true;
      script.onload = script.onreadystatechange = function(){auth.update();};
      var s = document.getElementsByTagName('script')[0];
      s.parentNode.insertBefore(script, s);
    };
    
    self.showShoppingCart = function(){
      var itemCount = 0;
      var cartData = $.cookies.get("shopCartCookie");
      if (cartData !== null && cartData.A !== undefined) {
        itemCount = cartData.A.length;
      }
      $("nav.primary ul li.globalCartHead a").html("Cart: " + itemCount);
    };

    self.loadLeaderBoard = function(unit, target){
      var iframe = document.createElement('iframe');
      ord=Math.random()*10000000000000000;
      iframe.src = 'http://ad.doubleclick.net/adi/2009.lonelyplanet/' + self.adZone + ';' + self.adKeywords + ';' + self.segQS + ';' +  'tile=' + self.tile + ';sz=728x90;ord=' + ord + '?';
      iframe.style.height = '90px';
      iframe.style.width = '728px';
      iframe.marginHeight="0";
      iframe.marginWidth="0";
      iframe.frameBorder="0";
      var s = document.getElementById('ad_masthead');
      s.appendChild(iframe);
    };

    self.loadBreadcrumbs = function(){
      jQuery(document).ready(function($){
        var location = window.location;
        breadcrumbSelector = "#breadcrumb";
        try {
          jQuery.ajax({
            type: "GET",
            url: "/assets/breadcrumbs.html?destId=357884",
            contentType: "text/xml",
            dataType: "html",
            cache: true,
            success: function(html) {
              jQuery("#breadcrumbWrap").replaceWith(html);
      
              var breadcrumbBar = new BreadcrumbBar(jQuery(breadcrumbSelector));
              var a = new BreadcrumbResizer();
            }
          });
        } catch(err) {
        }
      });
    };

    //omniture
    self.setupOmnitureUserInfo = function(s){
      if (lpSignedInUser()) {
        s.eVar24 = Base64.encode(lpSignedInUser());
        s.eVar25 = isUserNewlyRegistered() ? "just registered" : "logged in";
      } else {
        s.eVar25 = "guest";
      }
    };

    self.bindBaseEvents =  function(){
      $("#language").removeClass('javascriptDisabled');
      $("#languageSelect").change(function() {
        $("#language").submit();
      });
    };

    self.bindDetailViewEvents = function(){
      var _self = self;
      $('..partner-review .handler').on('click', function(e){_self.toggleDescription(this,e);});
    };

    self.toggleDescription = function(handler, e){
      $('.partner-review .details, .partner-review .facilities').toggleClass('closed').toggleClass('open');
    };

    return self;
    });

  new window.lpGlobal(jQuery).init();
}).call(this);