define ['jquery'], ($)->

  class Authenticator

    @version = '0.0.13'
    
    constructor: (baseDomain) ->
      @options = @createUrls(baseDomain)
      @userState = @userSignedIn()
      @el = $('.js-user-nav')
      @signonWidget()
    
    createUrls: (baseDomain)->
      forumPostsUrlTemplate: "//www.#{baseDomain}/thorntree/profile.jspa?username=[USERNAME]"
      membersUrl: "//www.#{baseDomain}/members"
      messagesUrl: "//www.#{baseDomain}/members/messages"
      registerLink: "https://secure.#{baseDomain}/members/registration/new"
      signOutUrl: "https://secure.#{baseDomain}/sign-in/logout"

    userSignedIn: ->
      @lpUserName = @getLocalData('lp-uname')
      if (@lpUserName and (@lpUserName isnt '') and (@lpUserName isnt 'undefined')) then true else false

    signonWidget: ->
      if @userState is true
        @showUserBox()
      else
        @showLoginAndRegister()

    showLoginAndRegister: ()->
      @emptyUserNav()
      joinElement = "<a class='nav__item nav__item--primary js-user-join js-nav-item' href='#{@options.registerLink}'>Join</a>"
      signinElement = "<a class='nav__item nav__item--primary js-user-signin js-nav-item' href='#{@signInUrl()}'>Sign-In</a>"
      @el.append(signinElement + joinElement)

    showUserBox: ->
      @emptyUserNav()
      @el.addClass('is-signed-in')
      userBoxElement = "<div class='nav__item nav__item--user user-box js-user-box nav__submenu__trigger'><img class='user-box__img js-box-handler' src='#{@userAvatar()}'/></div>"
      @el.append(userBoxElement)
      $('.js-user-box').append(@userOptionsMenu())

    emptyUserNav: -> 
      @el.removeClass('is-signed-in')
      $('a.js-user-join, a.js-user-signin, div.js-user-box').remove()

    userOptionsMenu: ->
      userOptions = [
        {title: 'My Profile', uri: "#{@options.membersUrl}", style:"js-user-profile"},
        {title: 'Settings', uri: "#{@options.membersUrl}/#{@lpUserName}/edit",  style:"js-user-settings"},
        {title: 'Messages', uri: "#{@options.messagesUrl}", style:"js-user-msg"},
        {title: 'Forum Activity', uri: "#{@options.forumPostsUrlTemplate.replace('[USERNAME]', @lpUserName)}", style:"nav-user-options__item--forum js-user-forum" },
        {title: 'Sign-Out', uri: "#{@options.signOutUrl}", style:"nav-user-options__item--signout js-user-signout" }
      ]
      optionElements =  ("<a class='nav__item nav__submenu__item nav__submenu__link nav-user-options__item js-nav-item #{u.style}' href='#{u.uri}'>#{u.title}#{u.extra || ''}</a>" for u in userOptions).join('')
      userMenu = "<div class='nav__submenu nav__submenu--user'><div class='nav--stacked nav__submenu__content nav__submenu__content--user nav-user-options js-user-options'><div class='nav__submenu__item nav__submenu__title'>#{@lpUserName}</div>#{optionElements}</div></div>"
    
    signInUrl:->
      "https://secure.lonelyplanet.com/sign-in/login?service=#{escape(window.location)}"
    
    userAvatar: ->
      "#{@options.membersUrl}/#{@lpUserName}/mugshot/mini"

    update: ->
      @setLocalData("lp-uname", window.lpLoggedInUsername)
      prevState = @userState
      @userState = @userSignedIn()
      if(@userState is not prevState)
        @signonWidget()
#      @showMessageCount()

#   commented out just in case this functionality is to be resurrected

#    showMessageCount: ->
#      @updateMessageCount()

#    updateMessageCount: ->
#      if (@lpUserName and (@lpUserName isnt '') and (@lpUserName isnt 'undefined'))
#        url = "#{@options.membersUrl}/#{@lpUserName}/messages/count?callback=?"
#        $.getJSON(url, (data)=>@messageCountCallBack(data))

#    messageCountCallBack: (data={unread_count:0})->
#      @setLocalData('lp-unread-msg', data.unread_count)
#      @setLocalData('lp-sent-msg', data.sent_count)
#      @setLocalData('lp-received-msg', data.received_count)
#      if data.unread_count > 0
#        user_msg_el = "<span class='nav-user-options__item__float js-user-msg-unread'>#{data.unread_count}</span>"
#        $('a.js-user-msg').append(user_msg_el)
    
    bindEvents: ->
      $('#unread').click(()-> e.preventDefault(); window.location = "#{options.membersUrl}/#{@lpUserName}/messages")

    signOut: ->
      window.location= @options.signOutUrl

    getLocalData:(k)->
      if (@supportStorage())
        window.localStorage.getItem(k)
      else
        @localDataFallback(k)
    
    setLocalData:(k,v)->
      if (@supportStorage())
        window.localStorage.setItem(k,v)
      else
        window[k] = v
    
    delAllLocalData:()->
      if (@supportStorage())
        window.localStorage.clear()

    delLocalData:(k)->
      window.localStorage.removeItem(k)

    localDataFallback:(k)->
      switch(k)
        when 'lp-uname'
          window.lpLoggedInUsername
        when 'lp-unread-msg' then 0
        when 'lp-received-msg' then 0
        when 'lp-sent-msg' then 0
        else null

    supportStorage: ->
      try
        (window.localStorage) && (window['localStorage'] != null)
      catch error
        false

