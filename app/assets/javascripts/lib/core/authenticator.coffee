define ['jquery'], ($)->

  class Authenticator

    @version = '0.0.12'

    @options =
      forumPostsUrlTemplate: '//www.lonelyplanet.com/thorntree/profile.jspa?username=[USERNAME]'
      membersUrl: '//www.lonelyplanet.com/members'
      messagesUrl: '//www.lonelyplanet.com/members/messages'
      registerLink: 'https://secure.lonelyplanet.com/members/registration/new'
      signOutUrl: 'https://secure.lonelyplanet.com/sign-in/logout'
    
    constructor: ->
      @userState = @userSignedIn()
      @widget = $('nav.user-nav')
      @options = Authenticator.options
      @signonWidget()
      
    userSignedIn: ->
      @lpUserName = @getLocalData('lp-uname')
      if (@lpUserName and (@lpUserName isnt '') and (@lpUserName isnt 'undefined'))
        true
      else
        false

    signonWidget: ->
      if @userState is true
        @showUserBox()
      else
        @showLoginAndRegister()
        
    showLoginAndRegister: ()->
      @emptyUserNav()
      joinElement = "<a class='nav__item--primary--user js-user-join' href='#{@options.registerLink}'>Join</a>"
      signinElement = "<a class='nav__item--primary--user js-user-signin' href='#{@signInUrl()}'>Sign-In</a>"
      $('nav.js-user-nav').prepend(signinElement + joinElement)

    showUserBox: ->
      @emptyUserNav()
      $('nav.js-user-nav').addClass('is-signed-in')
      userBoxElement = "<div class='user-box js-user-box nav__submenu__trigger'><img class='user-box__img js-box-handler' src='#{@userAvatar()}'/></div>"
      $('nav.js-user-nav').prepend(userBoxElement)
      $('div.js-user-box').append(@userOptionsMenu())

    emptyUserNav: -> 
      $('nav.js-user-nav').removeClass('is-signed-in')
      $('a.js-user-join, a.js-user-signin, div.js-user-box').remove()

    userOptionsMenu: ->
      userOptions = [
        {title: 'My Profile', uri: "#{@options.membersUrl}", style:"js-user-profile"},
        {title: 'Settings', uri: "#{@options.membersUrl}/#{@lpUserName}/edit",  style:"js-user-settings"},
        {title: 'Messages', uri: "#{@options.messagesUrl}", style:"js-user-msg"},
        {title: 'Forum Activity', uri: "#{@options.forumPostsUrlTemplate.replace('[USERNAME]', @lpUserName)}", style:"nav-user-options__item--forum js-user-forum" },
        {title: 'Sign-Out', uri: "#{@options.signOutUrl}", style:"nav-user-options__item--signout js-user-signout" }
      ]
      optionElements =  ("<a class='nav__submenu__item nav-user-options__item #{u.style}' href='#{u.uri}'>#{u.title}#{u.extra || ''}</a>" for u in userOptions).join('')

      userMenu = "<nav class='nav__submenu nav__submenu--user nav-user-options js-user-options'><div class='nav-user-options__title'>#{@lpUserName}</div>#{optionElements}</nav>"
    
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
      @showMessageCount()

    showMessageCount: ->
      @updateMessageCount()

    updateMessageCount: ->
      if (@lpUserName and (@lpUserName isnt '') and (@lpUserName isnt 'undefined'))
        url = "#{@options.membersUrl}/#{@lpUserName}/messages/count?callback=?"
        $.getJSON(url, (data)=>@messageCountCallBack(data))

    messageCountCallBack: (data={unread_count:0})->
      @setLocalData('lp-unread-msg', data.unread_count)
      @setLocalData('lp-sent-msg', data.sent_count)
      @setLocalData('lp-received-msg', data.received_count)
      if data.unread_count > 0
        user_msg_el = "<span class='nav-user-options__item__float js-user-msg-unread'>#{data.unread_count}</span>"
        $('a.js-user-msg').append(user_msg_el)
    
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

