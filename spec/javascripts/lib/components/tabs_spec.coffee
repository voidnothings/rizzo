require ['public/assets/javascripts/lib/components/tabs.js'], (Tabs) ->

  describe 'Tabs', ->

    waitTime = 10

    describe 'Object', ->
      it 'is defined', ->
        expect(Tabs).toBeDefined()

    describe 'Functionality', ->
      beforeEach ->
        loadFixtures('tabs.html')
        myTabs = new Tabs('#myTestTabs', 0)

      it 'initializes with the first tab being active', ->
        expect($('#myTestTabs').find('#label1')).toHaveClass('is-active')
        expect($('#myTestTabs').find('#test1')).toHaveClass('is-active')

      it 'opens tab 2', ->
        runs ->
          $('#myTestTabs').find('#label2').trigger('click')
        waits(waitTime)
        runs ->
          expect($('#myTestTabs').find('#label1')).not.toHaveClass('is-active')
          expect($('#myTestTabs').find('#test1')).not.toHaveClass('is-active')
          expect($('#myTestTabs').find('#label2')).toHaveClass('is-active')
          expect($('#myTestTabs').find('#test2')).toHaveClass('is-active')
 
      it 'switches to tab 1 when it is already active', ->
        runs ->
          $('#myTestTabs').find('#label1').trigger('click')
        waits(waitTime)
        runs ->
          expect($('#myTestTabs').find('#label1')).toHaveClass('is-active')
          expect($('#myTestTabs').find('#test1')).toHaveClass('is-active')
          expect($('#myTestTabs').find('#label2')).not.toHaveClass('is-active')
          expect($('#myTestTabs').find('#test2')).not.toHaveClass('is-active')
        , waitTime

