require ['public/assets/javascripts/lib/components/tabs.js'], (Tabs) ->

  describe 'Tabs', ->

    

    describe 'Setup', ->
      it 'is defined', ->
        expect(Tabs).toBeDefined()

    describe 'Functionality', ->
      beforeEach ->
        loadFixtures('tabs.html')
        myTabs = new Tabs('#myTestTabs')

      it 'opens tab 1', ->
        runs ->
          $('#myTestTabs').find('#label1').trigger('click')
        waits(500)
        runs ->
          expect($('#myTestTabs').find('#label1')).toHaveClass('active')
          expect($('#myTestTabs').find('#test1')).toHaveClass('active')

      it 'closes tab 1', ->
        $('#myTestTabs').find('#test1').addClass('active')
        $('#myTestTabs').find('#label1').addClass('active')
        runs ->
          $('#myTestTabs').find('#label1').trigger('click')
        waits(500)
        runs ->
          expect($('#myTestTabs').find('#label1')).not.toHaveClass('active')
          expect($('#myTestTabs').find('#test1')).not.toHaveClass('active')
 
      it 'switches to tab 2', ->
        runs ->
          myTabs = new Tabs('#myTestTabs')
          myTabs.switch(2)
        waits(500)
        runs ->
          expect($('#myTestTabs').find('#label2')).toHaveClass('active')
          expect($('#myTestTabs').find('#test2')).toHaveClass('active')
        , 500
      
      it 'switches to a tab with id of #test2', ->
        runs ->
          myTabs = new Tabs('#myTestTabs')
          myTabs.switch('#test2')
        waits(500)
        runs ->
          expect($('#myTestTabs').find('#label2')).toHaveClass('active')
          expect($('#myTestTabs').find('#test2')).toHaveClass('active')
        , 500
 
      it 'switches to tab 1 when it is already active', ->
        runs ->
          myTabs = new Tabs('#myTestTabs')
          $('#myTestTabs').find('#test1').addClass('active')
          $('#myTestTabs').find('#label1').addClass('active')
          myTabs.switch(1)
        waits(500)
        runs ->
          expect($('#myTestTabs').find('#label1')).toHaveClass('active')
          expect($('#myTestTabs').find('#test1')).toHaveClass('active')
        , 500

