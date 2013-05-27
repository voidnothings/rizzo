define ['jquery', 'jplugs/jquery-cookies.2.2.0'], ($)->

  class AnalyticsAuth

    constructor: ->
      @lpCookie = $.cookies.get("lpCookie")
      @lpNewUser = $.cookies.get("lpNewUser")
      @signedInUser = @isUserSignedIn()

    get: ->      
      if !!@signedInUser
        return {
          eVar24 : @signedInUser
          eVar25 : (if !!@lpNewUser then "just registered" else "logged in") }
      else
        return {
          eVar25 : "guest" }

    isUserSignedIn: () ->
      if @lpCookie
        userCookieVal = @lpCookie.split(/#/)
        return (if userCookieVal then userCookieVal[0] else null)
      else
        return @lpNewUser

