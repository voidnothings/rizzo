require ['public/assets/javascripts/lib/components/stack_intro.js'], (StackIntro) ->

  describe 'StackIntro', ->

    describe 'Setup', ->

      it 'is defined', ->
        expect(StackIntro).toBeDefined()

    describe 'default instance', ->    
      
      beforeEach ->
        loadFixtures('stack_intro.html')
        @stackIntro = new StackIntro()

      it 'has default configuration', ->
        args =
          el: '.js-stack-intro'
          title: '.js-copy-title'
          lead: '.js-copy-lead'
          body: '.js-copy-body' 
        expect(@stackIntro.config).toEqual(args)

      it 'extends base configuration', ->
        customArgs =
          el: '.foo-intro'
          title: '.foo-title'
          lead: '.foo-lead'
          body: '.foo-body' 
        customIntro = new StackIntro(customArgs)
        expect(customIntro.config).toEqual(customArgs)

      it 'updates intro title', ->
        title = 'City Of Goa'
        @stackIntro.update({title: title})
        expect($("#{@stackIntro.config.title}")).toHaveText(title)

      it 'updates lead paragraph', ->
        lead = 'Lorem ipsum dolor sit amet'
        @stackIntro.update({lead: lead})
        expect($("#{@stackIntro.config.lead}")).toHaveText(lead)

      it 'updates body content', ->
        body = '<p>Lorem ipsum dolor sit amet, consectetur adipiscing eli.</p>'
        @stackIntro.update({body: body})
        expect($("#{@stackIntro.config.body}")).toHaveHtml(body)


    describe 'content visibility', ->    
      
      beforeEach ->
        loadFixtures('stack_intro.html')
        @stackIntro = new StackIntro()

      it 'hides lead container', ->
        lead = ''
        @stackIntro.update({lead: lead})
        expect($("#{@stackIntro.config.lead}")).toBeHidden()

      it 'shows lead container', ->
        lead = 'Lorem ipsum dolor sit amet'
        @stackIntro.update({lead: lead})
        expect($("#{@stackIntro.config.lead}")).toBeVisible()  

      it 'hides body container', ->
        body = ''
        @stackIntro.update({body: body})
        expect($("#{@stackIntro.config.body}")).toBeHidden()

      it 'shows body container', ->
        body = 'lorem'
        @stackIntro.update({body: body})
        expect($("#{@stackIntro.config.body}")).toBeVisible()           


