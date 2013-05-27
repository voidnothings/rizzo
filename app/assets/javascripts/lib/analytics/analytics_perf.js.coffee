define ['lib/analytics/bucket'], (Bucket) ->

  class AnalyticsPerf

    constructor: ->
      if @isCapable()
        @perfData = window.performance.timing
        @navStart = @perfData.fetchStart

    isCapable: ->
      window.performance and window.performance.timing

    get: ->
      if @isCapable()
        bucket = new Bucket({bin: 100})
        perfTimings = [@requestStartTime(), @renderTime(), @loadEventStartTime()]
        normalized = (bucket.normalize(value) for value in perfTimings)
        return {eVar71: normalized.join(':')}
      else
        return {}

    requestStartTime: ->
      responseStart = @perfData.responseStart 
      responseStart - @navStart

    loadEventStartTime: ->
      loadEventStart = @perfData.loadEventStart 
      loadEventStart - @navStart

    domContentLoadedEventEndTime: -> 
      domContentLoadedEventEnd = @perfData.domContentLoadedEventEnd 
      domContentLoadedEventEnd - @navStart

    navigationType: ->
      navigation_type = ['navigate', 'reload', 'back_forward']
      navigation_type[window.performance.navigation] or 'undefined'

    renderTime: ->
      if window.chrome and window.chrome.loadTimes
        Number(new Date(window.chrome.loadTimes().firstPaintTime * 1000)) - @navStart
      else if window.performance and window.performance.msFirstPaint
        Number(window.performance.msFirstPaint) - @navStart
      else
       'NS'
