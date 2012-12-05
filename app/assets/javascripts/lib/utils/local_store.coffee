# ----------------------------------------------------------
# 
# LocalStore (util)
# Serialize key,value into localstorage with cookies fallback
# for browsers that doesn't support localstorage.
# 
# ----------------------------------------------------------



define ->

  class LocalStore

    @version = '0.0.1'

    #src http://mathiasbynens.be/notes/localstorage-pattern
    @hasStorage = ->
      try
        uid = Number(new Date)
        localStorage.setItem(uid, uid)
        localStorage.removeItem(uid)
        true
      catch error
        false

    @set = (k,v) ->
      if @hasStorage()
        localStorage.setItem(k, v)
      else
        @setCookie(k, v)

    @get = (k) ->
      if @hasStorage()
        localStorage.getItem('cookie-compliance')
      else
        @getCookie('cookie-compliance')

    @getCookie = (k) -> 
      c = document.cookie.split('; ')
      cookies = {}
      for b in c
        a = b.split('=')
        cookies[a[0]] = a[1]
      cookies[k]

    @setCookie = (k, v, days) -> 
      if days
        date = new Date
        date.setTime(date.getTime() + (days * 86400000))
        exp = "; expires= #{date.toGMTString()}"  
      else
        exp =""
      window.document.cookie = "#{k}=#{v}#{exp}; path=/"

    @removeCookie = (k) -> 
      @setCookie(k,'',-1)
