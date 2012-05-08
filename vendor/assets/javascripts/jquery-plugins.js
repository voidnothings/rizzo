jQuery.fn.toggleClassOnEvent = function(options) {
  jQuery(this).each(function() {
    var onHover = options && options.onHover ? options.onHover : function() {
    };
    var offHover = options && options.offHover ? options.offHover : function() {
    };
    var target = options && options.target ? jQuery(options.target) : jQuery(this);
    if (options.event === 'hover' || options.event === 'tolerantHover') {
      jQuery(this)[options.event](function() {
        target.addClass(options.className);
        onHover.call(this);
      }, function() {
        target.removeClass(options.className);
        offHover.call(this);
      }, options.tolerance, options.tolerancePredicate);
    } 
    else {
      jQuery(this).bind(options.event, function() {
        target.toggleClass(options.className);
      });
    }
  });
  return this;
}

/*! Copyright (c) 2010 Brandon Aaron (http://brandonaaron.net)
 * Licensed under the MIT License (LICENSE.txt).
 *
 * bgiframe Version 2.1.3-pre
 */

var prop = function(n){
    return n && n.constructor === Number ? n + 'px' : n;
};

$.fn.bgiframe = ($.browser.msie && /msie 6\.0/i.test(navigator.userAgent) ? function(s) {
    s = $.extend({
        top     : 'auto', // auto == .currentStyle.borderTopWidth
        left    : 'auto', // auto == .currentStyle.borderLeftWidth
        width   : 'auto', // auto == offsetWidth
        height  : 'auto', // auto == offsetHeight
        opacity : true,
        src     : 'javascript:false;'
    }, s);
    var html = '<iframe class="bgiframe"frameborder="0"tabindex="-1"src="'+s.src+'"'+
                   'style="display:block;position:absolute;z-index:-1;'+
                       (s.opacity !== false?'filter:Alpha(Opacity=\'0\');':'')+
                       'top:'+(s.top=='auto'?'expression(((parseInt(this.parentNode.currentStyle.borderTopWidth)||0)*-1)+\'px\')':prop(s.top))+';'+
                       'left:'+(s.left=='auto'?'expression(((parseInt(this.parentNode.currentStyle.borderLeftWidth)||0)*-1)+\'px\')':prop(s.left))+';'+
                       'width:'+(s.width=='auto'?'expression(this.parentNode.offsetWidth+\'px\')':prop(s.width))+';'+
                       'height:'+(s.height=='auto'?'expression(this.parentNode.offsetHeight+\'px\')':prop(s.height))+';'+
                '"/>';
    return this.each(function() {
        if ( $(this).children('iframe.bgiframe').length === 0 ) { this.insertBefore( document.createElement(html), this.firstChild );}
    });
} : function() { return this; });

// old alias
$.fn.bgIframe = $.fn.bgiframe;

jQuery.fn.tolerantHover = function(onHover, offHover, tolerance, tolerancePredicate) {
  jQuery(this).each(function() {
    var hover = false, self = jQuery(this), timeout, tolerantOnHover = function() {
      clearTimeout(timeout);
      hover = true;
      onHover.apply(this);
    }, tolerantOffHover = function() {
      var baseTolerantOffHover = function() {
        hover = false;
        timeout = setTimeout(function() {
          if (!hover) {
            offHover.apply(self);
          }
          ;
        }, tolerance);
      };
      if (tolerancePredicate) {
        return function() {
          if (tolerancePredicate()) {
            baseTolerantOffHover();
          } 
          else {
            offHover.apply(self);
          }
        }
      } 
      else {
        return baseTolerantOffHover;
      }
    }(tolerancePredicate);
    self.hover(function() {
      tolerantOnHover();
    }, function() {
      tolerantOffHover();
    });
  });
  return this;
}

