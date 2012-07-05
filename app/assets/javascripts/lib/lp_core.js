var namespace = function (namespaceString) {
  var names = namespaceString.split('.'), scope = window, i;
  for (i = 0; i < names.length; i++) {
    if (typeof (scope[names[i]]) === 'undefined') {
      scope = scope[names[i]] = {};
    } 
    else {
      scope = scope[names[i]];
    }
  }
};
//
namespace('lp.nav');
//
var createMainNavTab = function() {
  var tab = jQuery(this);
  if (tab.hasClass('tabNotReady')) {
    return;
  }
  tab.toggleClassOnEvent({className: 'highlight',event: 'tolerantHover',tolerance: 200,tolerancePredicate: function() {
    return tab.find('> .menu:not(.hidden)').length !== 0;
  },offHover: function() {
    jQuery(this).children('ul').addClass('hidden');
  }});

  var down_arrows = tab.find('span.arrow');
  var right_arrows = tab.find('ul.menu > li > .arrow');
  down_arrows.add(right_arrows).add(tab.children('a')).toggleClassOnEvent({className: 'highlight',event: 'hover'});
  tab.find('li:has(.submenu)').bind('mouseenter', function() {
    if (tab.find('.submenu:not(.hidden)').length === 0) {
      jQuery(this).addClass('highlight');
    }
  }).bind('mouseleave', function() {
    if (tab.find('.submenu:not(.hidden)').length === 0) {
      jQuery(this).removeClass('highlight');
    }
  }).toggleClassOnEvent({className: 'selectable',event: 'hover'});
  down_arrows.click(function(event) {
    event.preventDefault();
    event.stopPropagation();
    tab.addClass('highlight');
    tab.children('ul').toggleClass('hidden');
    tab.find('.submenu').addClass('hidden');
    tab.find('.menu li').removeClass('highlight');
    var userTab = tab.filter('.userLoggedIn, .currentUserLoggedIn');
    userTab.children('ul').width(userTab.width() - 2);
  });
  tab.find('.menu').each(function() {
    var menu = jQuery(this).bgiframe();
    var menu_items = menu.children('li');
    menu_items.each(function() {
      var submenu = jQuery(this).find('.submenu').bgiframe();
      jQuery(this).click(function() {
        if (submenu.hasClass('hidden')) {
          menu_items.find('.submenu').addClass('hidden');
          submenu.removeClass('hidden');
          var topPadding = 14;
          var bottomPadding = 7;
          var currentTop = parseInt(submenu.css('top'), 10) || 0;
          var submenuTop = Math.floor((jQuery(this).height() - submenu.height()) / 2) - currentTop;
          var windowBottomEdge = jQuery(window).scrollTop() + jQuery(window).height();
          var submenuOffsetTop = submenu.offset().top;
          var submenuBottomEdge = submenu.outerHeight() + submenuOffsetTop + submenuTop;
          if (windowBottomEdge <= submenuBottomEdge + bottomPadding) {
            submenuTop -= (submenuBottomEdge + bottomPadding) - windowBottomEdge;
          }
          var menuTopEdge = menu.offset().top;
          var submenuTopEdge = submenuOffsetTop + submenuTop;
          if (submenuTopEdge <= menuTopEdge + topPadding) {
            submenuTop += (menuTopEdge + topPadding) - submenuTopEdge;
          }
          submenu.css('top', (submenuTop + currentTop) + 'px');
          menu_items.removeClass('highlight');
          jQuery(this).addClass('highlight');
        } 
        else {
          menu_items.find('.submenu').addClass('hidden');
        }
      });
      jQuery(this).children('a').add(submenu).click(function(event) {
        event.stopPropagation();
      });
    });
  });
};

var globalNav = function(navHtmlSnippet, selector) {
  jQuery(selector).append(navHtmlSnippet);
  jQuery(selector + 'span.arrow').removeClass('invisible');
  jQuery(selector).each(createMainNavTab);
};

// callback after hochiminh content download....
lp.nav.createMainNav = function(jQuery) {
  jQuery(function() {
    var mainNav = jQuery('#mainNav');
    mainNav.children('.tab').each(createMainNavTab);
    mainNav.removeClass('notReady');
  });
};


var _destinationsGlobalNav = function (data) {
  var destinations = new globalNav(data.nav, "nav.primary ul li.destinations");
};

lp.nav.createMainNav(jQuery);

// //omniture
// self.setupOmnitureUserInfo = function(s){
//   if (lpSignedInUser()) {
//     s.eVar24 = Base64.encode(lpSignedInUser());
//     s.eVar25 = isUserNewlyRegistered() ? "just registered" : "logged in";
//   } else {
//     s.eVar25 = "guest";
//   }
// };
// 
// // sign in
// function lpSignedInUser() {
//   var lpCookie = jQuery.cookies.get("lpCookie");
//   if (lpCookie) {
//     var userCookieVal = lpCookie.split(/#/);
//     return userCookieVal ? userCookieVal[0] : null;
//   }
//   var lpNewUser = jQuery.cookies.get("lpNewUser");
//   if (lpNewUser) {
//     return lpNewUser;
//   }
// }
// 
// function isUserNewlyRegistered() {
//   return jQuery.cookies.get("lpNewUser") ? true : false;
// }

function callback(object, methodName){
  var context = object;
  return function(param1, param2) 
  {
    context[methodName](param1, param2);
    return false;
  };
}

// breadcrumbs
function BreadcrumbTab(domElement, breadcrumbBar){
  this.init = function(domElement, breadcrumbBar){
    this.tab = jQuery(domElement);
    this.span = this.tab.children("span");
    this.arrowLink = this.span.children("a.dropDown");
    this.arrow = this.arrowLink.children("img.arrow");
    this.dropDown = this.tab.children("ul");
    this.tab.hover(callback(this, 'over'), callback(breadcrumbBar, 'resetAll'));
    this.dropDown.hover(callback(this, 'dropDownOver'), callback(breadcrumbBar, 'resetAll'));
    this.arrowLink.hover(callback(this, 'arrowOver'), callback(this, 'arrowOut'));
    this.arrowLink.click(callback(this, 'toggleDropDown'));
  };
  this.over = function(){
    this.highlight(this.tab);
  };
  this.dropDownOver = function(){
    this.highlight(this.tab);
    this.showDropDown();
  };
  this.toggleDropDown = function(){
    if (this.isDropDownVisible()){
      this.hideDropDown();
    } else {
      this.showDropDown();
    }
  };
  this.arrowOver = function(){
    this.highlight(this.arrow);
  };
  this.arrowOut = function(){
    this.removeHighlight(this.arrow);
  };
  this.reset = function(){
    this.removeHighlight(this.tab);
    this.hideDropDown();
  };
  this.highlight = function(element){
    element.addClass("over");
  };
  this.removeHighlight = function(element){
    element.removeClass("over");
  };
  this.isDropDownVisible = function(){
    return this.dropDown.hasClass("onScreen");
  };
  this.showDropDown = function(){
    this.dropDown.addClass("onScreen");
    this.span.addClass("shadow");
  };
  this.hideDropDown = function(){
    this.dropDown.removeClass("onScreen");
    this.span.removeClass("shadow");
  };
  this.init(domElement, breadcrumbBar);
}

function BreadcrumbResizer(){
  var theBreadcrumbHeight = jQuery('#breadcrumbWrap').height();
  var theBreadcrumbLink = jQuery('#breadcrumb li a');
  var subBreadcrumbLinks = jQuery('#breadcrumb li ul li a');
  if (theBreadcrumbHeight > 40 && theBreadcrumbHeight < 75) {
    theBreadcrumbLink.css("font-size", ".7em").css("margin-top", "3px");
    subBreadcrumbLinks.css("font-size", "1em");
    return true;
  }
  if (theBreadcrumbHeight > 75) {
    theBreadcrumbLink.css("font-size", ".55em").css("padding-right", "2px").css("padding-left", "2px").css("margin-top", "3px");
    subBreadcrumbLinks.css("font-size", "1em");
    return true;
  }
}
$(function() {
  var breadcrumb = new BreadcrumbResizer();
});

function BreadcrumbBar(domElement) 
{
  this.init = function(domElement) {
    this.items = [];
    breadcrumbBar = this;
    jQuery(domElement).children("li").each(function(i){
      breadcrumbBar.items[i] = new BreadcrumbTab(this, breadcrumbBar);
    });
  };
  this.resetAll = function(element){
    jQuery(this.items).each(function(){this.reset();});
  };
  this.init(domElement);
}


