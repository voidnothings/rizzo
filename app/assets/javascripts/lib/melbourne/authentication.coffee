define ['jquery'], ($)->

  class Authentication

    @options =
      registerLink: 'https://secure.lonelyplanet.com/members/registration/new'
      unreadMessageRefresh: 120000
      membersUrl: 'http://www.lonelyplanet.com/members'
      groupsUrl: 'http://www.lonelyplanet.com/groups'
      staticUrl: 'http://static.lonelyplanet.com/static-ui'
      messagesUrl: 'http://www.lonelyplanet.com/members/messages'
      favouritesUrl: 'http://www.lonelyplanet.com/favourites'
      tripPlannerUrl: 'http://www.lonelyplanet.com/trip-planner'
      forumPostsUrlTemplate: 'http://www.lonelyplanet.com/thorntree/profile.jspa?username=[USERNAME]'
      signOutUrl: 'https://secure.lonelyplanet.com/sign-in/logout'

    constructor: ->
      @widget = $('.nav__item--user')
      @options = Authentication.options
      @signonWidget()

    supportStorage: ->
      try
        (window.localStorage) && (window['localStorage'] != null)
      catch error
        false
      
    signonWidget: ->
      if @userSignedIn() is true
        @displayUserShortcutMenu()
      else
        @displaySigninRegisterWidget()

    userSignedIn: ->
      @lpUserName = @getLocalData('lp-uname')
      if (@lpUserName and (@lpUserName isnt '') and (@lpUserName isnt 'undefined'))
        true
      else
        false

    update: ->
      @setLocalData("lp-uname", window.lpLoggedInUsername)
      @signonWidget()
      @displayUnreadMessageCount()

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

    displaySigninRegisterWidget: ->
      @widget.removeClass('user--logged-in')
      signInButton = $('<button class="user--button--signin js-user-signin" value="Sign in">Sign In</button>')
      signInButton.click(=>@signIn())
      @widget.empty()
      @widget.append(signInButton)
      @widget.append("<a class='user--button--register js-user-register' href='#{@options.registerLink}'>Register</a>")

    avatar: ->
      "<img src='#{@options.membersUrl}/#{@lpUserName}/mugshot/mini' alt='avatar' class='user__img' width='27px' height='27px'/>"

    refreshUnreadCountCallBack:(data={unread_count:0})->
      @setLocalData('lp-unread-msg', data.unread_count)
      @setLocalData('lp-sent-msg', data.sent_count)
      @setLocalData('lp-received-msg', data.received_count)
      unread_indicator = $(".js-user-msg-unread")
      unread_indicator.text(data.unread_count)
      if (data.unread_count > 0)
        unread_indicator.addClass("user__msg-new")
      else
        unread_indicator.removeClass("user__msg-new")

    updateMessageCount: ->
      if (@lpUserName and (@lpUserName isnt '') and (@lpUserName isnt 'undefined'))
        url = "#{@options.membersUrl}/#{@lpUserName}/messages/count?callback=?"
        $.getJSON(url, (data)=>@refreshUnreadCountCallBack(data))

    displayUnreadMessageCount: ->
      @updateMessageCount()

    displayUserShortcutMenu: ->
      userMenu = [
        "<a class='user-nav' href='#{@options.membersUrl}'>#{@avatar()}",
        "<span class='user__name'>#{@getLocalData('lp-uname')}</span>",
        "<span class='user__msg-unread js-user-msg-unread'>#{@getLocalData('lp-unread-msg') || 0}</span>",
        "<span class='user-nav__arrow js-user-nav-handler' alt='More shortcuts'/>",
        "</a>",
        "<ul class='user-nav__menu js-user-nav-menu'>",
        "<li><a class='user-nav__item' href='#{@options.membersUrl}'>My profile</a></li>",
        "<li><a class='user-nav__item' href='#{@options.membersUrl}/#{@lpUserName}/edit'>Settings</a></li>",
        "<li><a class='user-nav__item' href='#{@options.messagesUrl}'>Messages</a></li>",
        "<li><a class='user-nav__item' href='#{@options.forumPostsUrlTemplate.replace('[USERNAME]', @lpUserName)}'>Forum activity</a></li>",
        "<li class=''><a class='user-nav__item user-nav__item--last' href='#{@options.signOutUrl}'>Sign out</a></li>",
        "</ul>"
      ].join('')
      
      @widget.empty().addClass('user--logged-in').append(userMenu)
      
      @widget.find('.js-user-nav-handler').click( (e) =>
        e.preventDefault()
        @widget.find('.js-user-nav-menu').toggle()
      )

      @widget.find('li.signout a').click( (e) =>
        e.preventDefault()
        @signOut()
      )

    bindEvents: ->
      $('#unread').click(()-> e.preventDefault(); window.location = "#{options.membersUrl}/#{@lpUserName}/messages")

    signIn:->
      window.location="https://secure.lonelyplanet.com/sign-in/login?service=#{escape(window.location)}"

    signOut: ->
      opts =
        domain: 'lonelyplanet.com'
        path: '/'
        secure: true
      window.location="https://secure.lonelyplanet.com/sign-in/logout"
