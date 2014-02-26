require ['jquery', 'lib/core/base', 'flamsteed', 'lib/utils/scroll_perf', 'polyfills/function_bind', 'trackjs'], ($, Base, _FS, ScrollPerf) ->
  $ ->
    base = new Base()
    new ScrollPerf
    window.lp.fs = new _FS({events: window.lp.fs.buffer, u: $.cookies.get('lpUid')})
    require ['sailthru'], ->
      Sailthru.setup(domain: 'horizon.lonelyplanet.com')
