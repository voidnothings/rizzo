require ['public/assets/javascripts/lib/mobile/core/authenticator_mobile'], (Authenticator) ->

  describe 'Authenticator', ->

    beforeEach ->
      localStorage.removeItem('lp-uname')
      window.lp.supports.localStorage = true

    it 'is defined', ->
      expect(Authenticator).toBeDefined()


    describe 'default options', ->

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
        @auth = new Authenticator()
        spyOn(@auth, "getLocation").andReturn('foo')
        loadFixtures('userBox.html')
        @auth.constructor()

      describe 'user', ->

        it 'is signed out', ->
          expect(@auth.userState).toBe(false)
          expect($('.js-user-nav')).not.toHaveClass('is-logged')

        it 'sees a register link', ->
          expect($('a.js-user-join')).toExist()

        it 'has a user join url', ->
          expect($('a.js-user-join').attr('href')).toBe(@auth.signInUrl())


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

        it 'does not have a sign-in link', ->
          expect($('a.js-user-singin')).not.toExist()

        it 'does not has a register link', ->
          expect($('a.js-user-join')).not.toExist()

        it 'has user box', ->
          expect($('.js-user-box')).toExist()

        it 'has an avatar thumbnail', ->
          expect($('img.user-box__img')).toExist()
          expect(@auth.userAvatar()).toBe("#{@auth.options.membersUrl}/#{@auth.lpUserName}/mugshot/small")


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
           expect($('a.js-user-profile').text()).toBe('My Profile')

        it 'has a user-settings link', ->
           expect($('a.js-user-settings')).toExist()
           expect($('a.js-user-settings').text()).toBe('Settings')

        it 'has a user-forum-activity link', ->
           expect($('a.js-user-forum')).toExist()
           expect($('a.js-user-forum').text()).toBe('Forum Activity')

        it 'has a sign-out link', ->
           expect($('a.js-user-signout')).toExist()
           expect($('a.js-user-signout').text()).toBe('Sign-Out')
           expect($('a.js-user-signout').attr('href')).toBe(@auth.options.signOutUrl)
