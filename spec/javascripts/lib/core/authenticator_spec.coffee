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


    describe 'staging environment', ->

      beforeEach ->

        @auth = new Authenticator()
        spyOn(@auth, 'getDomain').andReturn("lpstaging.com")
        @auth.constructor()


      it 'creates custom urls based on the domain', ->
        expect(@auth.options.registerLink).toContain("lpstaging.com")
        expect(@auth.options.forumPostsUrlTemplate).toContain("lpstaging.com")
        expect(@auth.options.membersUrl).toContain("lpstaging.com")
        expect(@auth.options.messagesUrl).toContain("lpstaging.com")
        expect(@auth.options.signOutUrl).toContain("lpstaging.com")


    describe 'logged-out', ->

      beforeEach ->
        loadFixtures('userBox.html')
        @auth = new Authenticator()

      describe 'user', ->

        it 'is signed out', ->
          expect(@auth.userState).toBe(false)
          expect($('.js-user-nav')).not.toHaveClass('is-logged')

        it 'sees a sign-in link', ->
          expect($('a.js-user-signin')).toExist()

        it 'sees a register link', ->
          expect($('a.js-user-join')).toExist()

        it 'has a user join url', ->
          expect($('a.js-user-join').attr('href')).toBe(@auth.options.registerLink)

        it 'has a sign-in url', ->
          expect($('a.js-user-signin').attr('href')).toBe(@auth.signInUrl())

        # it 'has a sign-in url with the current service uri', ->  
        #   expect(@auth.signInUrl()).toMatch(/\?service/)
        #   expect(@auth.signInUrl()).toMatch(/localhost/)


    describe 'logged-in', ->

      describe 'user', ->

        beforeEach ->
          loadFixtures('userBox.html')
          window.localStorage.setItem('lp-uname', 'KellyJones')
          @auth = new Authenticator()

        afterEach ->
          localStorage.removeItem('lp-uname')

        it 'is signed in', ->
          expect(@auth.userState).toBe(true)
          expect($('.js-user-nav')).toHaveClass('is-signed-in')

        it 'does not has a sign-in link', ->
          expect($('a.js-user-singin')).not.toExist()

        it 'does not has a register link', ->
          expect($('a.js-user-join')).not.toExist()

        it 'has user box', ->  
          expect($('div.user-box')).toExist()
        
        it 'has an avatar thumbnail', ->
          expect($('img.user-box__img')).toExist()
          expect(@auth.userAvatar()).toBe("#{@auth.options.membersUrl}/#{@auth.lpUserName}/mugshot/mini")

    
    describe 'options menu', ->

      beforeEach ->
        loadFixtures('userBox.html')
        window.localStorage.setItem('lp-uname', 'KellyJones')
        @auth = new Authenticator()

      afterEach ->
        localStorage.removeItem('lp-uname')

      describe 'user', ->

        it 'has a user dropdown menu', ->
          expect($('.js-user-options')).toExist()

        it 'shows the user name', ->
           expect($('div.nav__submenu__title')).toExist()
           expect($('div.nav__submenu__title').text()).toBe('KellyJones')

        it 'has a user-profile link', ->
           expect($('a.js-user-profile')).toExist()
           expect($('a.js-user-profile').text()).toBe('My profile')

        it 'has a user-settings link', ->
           expect($('a.js-user-settings')).toExist()
           expect($('a.js-user-settings').text()).toBe('Settings')

        it 'has a user-forum-activity link', ->
           expect($('a.js-user-forum')).toExist()
           expect($('a.js-user-forum').text()).toBe('Forum activity')

        it 'has a sign-out link', ->
           expect($('a.js-user-signout')).toExist()
           expect($('a.js-user-signout').text()).toBe('Sign out')
           expect($('a.js-user-signout').attr('href')).toBe(@auth.options.signOutUrl)


    # describe 'messages count', ->
    # 
    #   describe 'user', ->
    #     
    #     beforeEach ->
    #       loadFixtures('userBox.html')
    #       window.localStorage.setItem('lp-uname', 'KellyJones')
    #       Authenticator.prototype.showMessageCount = ()-> console.log('me')
    #       @auth = new Authenticator()
    # 
    #     it 'has no messages to read', ->
    #       expect($('span.js-user-msg-unread')).not.toExist()
    # 
    #     it 'has 7 messages to read', ->
    #       data = 
    #         received_count: 0
    #         sent_count: 0
    #         unread_count: 7
    #       @auth.messageCountCallBack(data)
    #       expect($('span.js-user-msg-unread').text()).toBe('7')
    # 
