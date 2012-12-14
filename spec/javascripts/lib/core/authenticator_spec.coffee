require ['public/assets/javascripts/lib/core/authenticator'], (Authenticator) ->

  describe 'Authenticator', ->

    beforeEach ->
      localStorage.removeItem('lp-uname')

    it 'is defined', ->
      expect(Authenticator).toBeDefined()

    it 'has a version', ->
      expect(Authenticator.version).toBeDefined()

    describe 'defaults', ->

      beforeEach ->
        @auth = new Authenticator()

      it 'has a register-link', ->
        expect(@auth.options.registerLink).toBeDefined()

      it 'has a forum-activity-url', ->
        expect(@auth.options.forumPostsUrlTemplate).toBeDefined()

      it 'has a member url', ->
        expect(@auth.options.membersUrl).toBeDefined()

      it 'has a messages url', ->
        expect(@auth.options.messagesUrl).toBeDefined()

      it 'has a sign-out url', ->
        expect(@auth.options.signOutUrl).toBeDefined()


    describe 'user logged-out', ->

      beforeEach ->
        loadFixtures('userBox.html')
        @auth = new Authenticator()

      it 'is signed out', ->
        expect(@auth.userState).toBe(false)
        expect($('nav.js-user-nav')).not.toHaveClass('is-logged')

      it 'sees a sign-in link', ->
        expect($('a.js-user-sing-in')).toExist()

      it 'sees a register link', ->
        expect($('a.js-user-join')).toExist()
    
      it 'has a user join url', ->
        expect($('a.js-user-join').attr('href')).toBe(@auth.options.registerLink)
 
      it 'has a sign-in url', ->
        expect($('a.js-user-sing-in').attr('href')).toBe(@auth.signInUrl())

      it 'has a sign-in url with the current service uri', ->  
        expect(@auth.signInUrl()).toMatch(/\?service/)
        expect(@auth.signInUrl()).toMatch(/localhost/)

    
    describe 'user logged-in', ->

      beforeEach ->
        loadFixtures('userBox.html')
        window.localStorage.setItem('lp-uname', 'KellyJones')
        @auth = new Authenticator()

      afterEach ->
        localStorage.removeItem('lp-uname')

      it 'is signed in', ->
        expect(@auth.userState).toBe(true)
        expect($('nav.js-user-nav')).toHaveClass('is-logged')

      it 'does not has a sign-in link', ->
        expect($('a.js-user-sing-in')).not.toExist()

      it 'does not has a register link', ->
        expect($('a.js-user-join')).not.toExist()

      it 'has user box', ->  
        expect($('div.user-box')).toExist()
      
      it 'has an avatar thumbnail', ->
        expect($('img.user-img')).toExist()
        expect(@auth.userAvatar()).toBe("#{@auth.options.membersUrl}/#{@auth.lpUserName}/mugshot/mini")

    
    describe 'user options menu', ->

      beforeEach ->
        loadFixtures('userBox.html')
        window.localStorage.setItem('lp-uname', 'KellyJones')
        @auth = new Authenticator()

      afterEach ->
        localStorage.removeItem('lp-uname')

      it 'has a user dropdown menu', ->
        expect($('div.js-user-options')).toExist()

      it 'shows the user name', ->
         expect($('span.user-name')).toExist()
         expect($('span.user-name').text()).toBe('KellyJones')

      it 'has a user-profile link', ->
         expect($('a.user-profile')).toExist()
         expect($('a.user-profile').text()).toBe('My Profile')

      it 'has a user-settings link', ->
         expect($('a.user-settings')).toExist()
         expect($('a.user-settings').text()).toBe('Settings')

      it 'has a user-messages link', ->
         expect($('a.user-msg')).toExist()
         expect($('a.user-msg').text()).toBe('Messages')

      it 'has a user-forum-activity link', ->
         expect($('a.user-forum')).toExist()
         expect($('a.user-forum').text()).toBe('Forum Activity')

      it 'has a sign-out link', ->
         expect($('a.user-signout')).toExist()
         expect($('a.user-signout').text()).toBe('Sign-Out')
         expect($('a.user-signout').attr('href')).toBe(@auth.options.signOutUrl)


    describe 'user messages count', ->

      beforeEach ->
        loadFixtures('userBox.html')
        window.localStorage.setItem('lp-uname', 'KellyJones')
        Authenticator.prototype.showMessageCount = ()-> console.log('me')
        @auth = new Authenticator()

      it 'has no messages to read', ->
        expect($('span.js-user-msg-unread')).toExist()
        expect($('span.js-user-msg-unread').text()).toBe('')

      it 'has 7 messages to read', ->
        data = 
          received_count: 0
          sent_count: 0
          unread_count: 7
        @auth.messageCountCallBack(data)
        expect($('span.js-user-msg-unread').text()).toBe('7')

