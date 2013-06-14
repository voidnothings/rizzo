require ['public/assets/javascripts/lib/components/stack_intro.js'], (StackIntro) ->

  describe 'StackIntro', ->

    describe 'Object', ->

      it 'is defined', ->
        expect(StackIntro).toBeDefined()

    describe 'default instance', ->
      
      beforeEach ->
        loadFixtures('stack_intro.html')
        @stackIntro = new StackIntro()

      it 'has default configuration', ->
        args =
          LISTENER: '#js-card-holder'
          el: '.js-stack-intro'
          title: '.js-copy-title'
          lead: '.js-copy-lead'
          body: '.js-copy-body' 
        expect(@stackIntro.config).toEqual(args)

      it 'extends base configuration', ->
        customArgs =
          LISTENER: '#js-card-holder'
          el: '.foo-intro'
          title: '.foo-title'
          lead: '.foo-lead'
          body: '.foo-body' 
        customIntro = new StackIntro(customArgs)
        expect(customIntro.config).toEqual(customArgs)


    describe 'When the parent element does not exist', ->
      beforeEach ->
        loadFixtures('stack_intro.html')
        window.stackIntro = new StackIntro({ el: '.foo'})
        spyOn(stackIntro, "init")

      it 'does not initialise', ->
        expect(stackIntro.init).not.toHaveBeenCalled()


    # --------------------------------------------------------------------------
    # Private Methods
    # --------------------------------------------------------------------------

    describe 'updating', ->
      beforeEach ->
        loadFixtures('stack_intro.html')
        window.stackIntro = new StackIntro()

      it 'updates intro title', ->
        title = 'City Of Goa'
        window.stackIntro._update({title: title})
        expect($("#{window.stackIntro.config.title}")).toHaveText(title)

      it 'updates lead paragraph', ->
        lead = 'Lorem ipsum dolor sit amet'
        window.stackIntro._update({lead: lead})
        expect($("#{window.stackIntro.config.lead}")).toHaveText(lead)

      it 'updates body content', ->
        body = '<p>Lorem ipsum dolor sit amet, consectetur adipiscing eli.</p>'
        window.stackIntro._update({body: body})
        expect($("#{window.stackIntro.config.body}")).toHaveHtml(body)


    describe 'content visibility', ->    
      
      beforeEach ->
        loadFixtures('stack_intro.html')
        @stackIntro = new StackIntro()

      it 'hides lead container', ->
        lead = ''
        @stackIntro._update({lead: lead})
        expect($("#{@stackIntro.config.lead}")).toBeHidden()

      it 'shows lead container', ->
        lead = 'Lorem ipsum dolor sit amet'
        @stackIntro._update({lead: lead})
        expect($("#{@stackIntro.config.lead}")).toBeVisible()  

      it 'hides body container', ->
        body = ''
        @stackIntro._update({body: body})
        expect($("#{@stackIntro.config.body}")).toBeHidden()

      it 'shows body container', ->
        body = 'lorem'
        @stackIntro._update({body: body})
        expect($("#{@stackIntro.config.body}")).toBeVisible()           


    # --------------------------------------------------------------------------
    # Events API
    # --------------------------------------------------------------------------

    data =
      copy:
        title: "Vietnam hotels and hostels"
        lead: "Some lead information about accommodation in Vietnam"
        description: "Some general information about accommodation in Vietnam"

    describe 'on received events', ->
      beforeEach ->
        loadFixtures('stack_intro.html')
        @stackIntro = new StackIntro()
        spyOn(@stackIntro, "_update")

      it 'cards/received', ->
        $(stackIntro.config.LISTENER).trigger(':cards/received', data)  
        expect(@stackIntro._update).toHaveBeenCalledWith(data.copy)

      it 'page/received', ->
        $(stackIntro.config.LISTENER).trigger(':page/received', data)  
        expect(@stackIntro._update).toHaveBeenCalledWith(data.copy)
