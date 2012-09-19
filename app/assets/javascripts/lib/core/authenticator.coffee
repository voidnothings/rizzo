define ['jquery'], ($)->

  class Authenticator

    @version = '0.0.11'

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
        
    showUserBox: ()->
      $(@widget).addClass('is-logged')
      $(@widget).find('img.js-user-img').attr({src: @userAvatar()})

    showLoginAndRegister: ()->
      $(@widget).removeClass('is-logged')
      joinElement = "<a class='user-join js-user-join' href='#{@options.registerLink}'>Join</a>"
      signinElement = "<a class='user-singin js-user-sing-in' href='#{@signInUrl()}'>Sign-In</a>"
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
        {title: 'Messages', uri: "#{@options.messagesUrl}", style:"user-msg", extra:"<span class='user-msg-unread js-user-msg-unread'></span>"},
        {title: 'Forum Activity', uri: "#{@options.forumPostsUrlTemplate.replace('[USERNAME]', @lpUserName)}", style:"user-forum" },
        {title: 'Sign-Out', uri: "#{@options.signOutUrl}", style:"user-signout" }
      ]
      optionElements =  ("<a class='user-menu-option #{u.style}' href='#{u.uri}'>#{u.title}#{u.extra || ''}</a>" for u in userOptions).join('')

      userMenu = "<div class='user-options js-user-options'><div class='user-options-arrow'></div><nav class='nav-user-options'><span class='user-name'>#{@lpUserName}</span>#{optionElements}</nav></div>"  
    
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
      $.getJSON("#{@options.membersUrl}/#{@lpUserName}/messages/count?callback=?", (data)=>@messageCountCallBack(data)) if @lpUserName

    messageCountCallBack: (data={unread_count:0})->
      console.log(data)
      @setLocalData('lp-unread-msg', data.unread_count)
      @setLocalData('lp-sent-msg', data.sent_count)
      @setLocalData('lp-received-msg', data.received_count)
      if data.unread_count > 0
        $('span.js-user-msg-unread').empty().html(data.unread_count).addClass('has-msg')
    
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

