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
      @widget = $('nav.user-nav')
      @options = Authentication.options
      @signonWidget()
      
    userSignedIn: ->
      @lpUserName = @getLocalData('lp-uname')
      if (@lpUserName and (@lpUserName isnt '') and (@lpUserName isnt 'undefined'))
        true
      else
        false

    signonWidget: ->
      if @userSignedIn() is true
        @showUserBox()
        # @displayUserShortcutMenu()
      else
        @showLoginAndRegister()
        # @displaySigninRegisterWidget()
        
    showUserBox: ()->
      $(@widget).addClass('is-logged')
      $(@widget).find('img.js-user-img').attr({src: @userAvatar()})

    showLoginAndRegister: ()->
      $(@widget).removeClass('is-logged')
      joinElement = "<a class='user-join js-user-join' href='#{@options.registerLink}'>Join</a>"
      signinElement = "<a class='user-singin js-user-sing-in' href='#{@signInUrl()}'>Sing-In</a>"
      $('div.js-auth-box').empty()
      $('div.js-auth-box').append(joinElement).append(signinElement)

    showUserBox: ->
      $(@widget).addClass('is-logged')
      userBoxElement = "<div class='user-box'><img class='user-img' src='#{@userAvatar()}'/><span class='user-handler js-box-handler'></div>"
      $('div.js-auth-box').empty()
      $('div.js-auth-box').append(userBoxElement)
      $('div.js-auth-box').append(@userOptionsMenu())



    userOptionsMenu: ->
      userOptions = [
        {title: 'My Profile', uri: "#{@options.membersUrl}", style:"user-profile" },
        {title: 'Settings', uri: "#{@options.membersUrl}/#{@lpUserName}/edit", style:"user-settings" },
        {title: 'Messages', uri: "#{@options.messagesUrl}", style:"user-msg" },
        {title: 'Forum Activity', uri: "#{@options.forumPostsUrlTemplate.replace('[USERNAME]', @lpUserName)}", style:"user-forum" },
        {title: 'Sign-Out', uri: "#{@options.signOutUrl}", style:"user-signout" }
      ]
        
      optionElements =  ("<a class='user-menu-option #{u.style}' href='#{u.uri}'>#{u.title}</a>" for u in userOptions).join('')
        
      "<nav class='nav-user-options'>#{optionElements}</nav>"  

    signInUrl:->
      "https://secure.lonelyplanet.com/sign-in/login?service=#{escape(window.location)}"

    update: ->
      @setLocalData("lp-uname", window.lpLoggedInUsername)
      @signonWidget()
      # @displayUnreadMessageCount()

    displaySigninRegisterWidget: ->
      $(@widget).removeClass('is-logged')

      # signInButton = $('<button class="signInButton submitButtonShort" value="Sign in">Sign In</button>')
      # signInButton.click(=>@signIn())
      # @widget.empty()
      # @widget.append(signInButton)
      # @widget.append("<p><a href='#{@options.registerLink}'>Register</a></p>")

    userAvatar: ->
      "#{@options.membersUrl}/#{@lpUserName}/mugshot/mini"

    refreshUnreadCountCallBack:(data={unread_count:0})->
      @setLocalData('lp-unread-msg', data.unread_count)
      @setLocalData('lp-sent-msg', data.sent_count)
      @setLocalData('lp-received-msg', data.received_count)
      unread_indicator = $(".primary .unread")
      unread_indicator.text(data.unread_count)
      if (data.unread_count > 0)
        unread_indicator.addClass("newMail")
      else
        unread_indicator.removeClass("newMail")

    updateMessageCount: ->
      $.getJSON("#{@options.membersUrl}/#{@lpUserName}/messages/count?callback=?", (data)=>@refreshUnreadCountCallBack(data)) if @lpUserName

    displayUnreadMessageCount: ->
      @updateMessageCount()

    displayUserShortcutMenu: ->
      @widget.addClass('is-logged')
      $('user-img').attr('')
      # userMenu = [
      #   "<a class='navHead' href='#{@options.membersUrl}'>#{@avatar()}",
      #   "<span class='loggedInUsername'>#{@getLocalData('lp-uname')}</span>",
      #   "<span class='unread'>#{@getLocalData('lp-unread-msg') || 0}</span>",
      #   "<span class='arrow' alt='More shortcuts'/>",
      #   "</a>",
      #   "<ul class='menu hidden'>",
      #   "<li><a href='#{@options.membersUrl}'>My profile</a></li>",
      #   "<li><a href='#{@options.membersUrl}/#{@lpUserName}/edit'> Settings </a></li>",
      #   "<li><a href='#{@options.messagesUrl}'> Messages </a></li>",
      #   "<li><a href='#{@options.forumPostsUrlTemplate.replace('[USERNAME]', @lpUserName)}'> Forum activity </a></li>",
      #   "<li class='signout'><a href='#{@options.signOutUrl}'> Sign out </a></li>",
      #   "</ul>"
      # ].join('')
      # @widget.empty().addClass('userLoggedIn').removeClass('signInRegister').append(userMenu)
      # @widget.find('span.arrow').click((e)=> e.preventDefault(); @widget.find('ul.menu').toggle())
      # @widget.find('li.signout a').click((e)=> e.preventDefault();  @signOut();)

    bindEvents: ->
      $('#unread').click(()-> e.preventDefault(); window.location = "#{options.membersUrl}/#{@lpUserName}/messages")

    signOut: ->
      opts =
        domain: 'lonelyplanet.com'
        path: '/'
        secure: true
      window.location="https://secure.lonelyplanet.com/sign-in/logout"

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

