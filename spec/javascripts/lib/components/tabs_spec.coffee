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
          expect($('#myTestTabs').find('#label1')).toHaveClass('is-active')
          expect($('#myTestTabs').find('#test1')).toHaveClass('is-active')
          expect($('#myTestTabs').find('#label2')).not.toHaveClass('is-active')
          expect($('#myTestTabs').find('#test2')).not.toHaveClass('is-active')

      it 'closes tab 1', ->
        $('#myTestTabs').find('#test1').addClass('is-active')
        $('#myTestTabs').find('#label1').addClass('is-active')
        runs ->
          $('#myTestTabs').find('#label1').trigger('click')
        waits(500)
        runs ->
          expect($('#myTestTabs').find('#label1')).not.toHaveClass('is-active')
          expect($('#myTestTabs').find('#test1')).not.toHaveClass('is-active')
          expect($('#myTestTabs').find('#label2')).not.toHaveClass('is-active')
          expect($('#myTestTabs').find('#test2')).not.toHaveClass('is-active')

      it 'switches to a tab with id of #test2', ->
        runs ->
          myTabs = new Tabs('#myTestTabs')
          myTabs.switch('#test2')
        waits(500)
        runs ->
          expect($('#myTestTabs').find('#label2')).toHaveClass('is-active')
          expect($('#myTestTabs').find('#test2')).toHaveClass('is-active')
          expect($('#myTestTabs').find('#label1')).not.toHaveClass('is-active')
          expect($('#myTestTabs').find('#test1')).not.toHaveClass('is-active')
        , 500
 
      it 'switches to tab 1 when it is already is-active', ->
        runs ->
          myTabs = new Tabs('#myTestTabs')
          $('#myTestTabs').find('#test1').addClass('is-active')
          $('#myTestTabs').find('#label1').addClass('is-active')
          myTabs.switch('#test1')
        waits(500)
        runs ->
          expect($('#myTestTabs').find('#label1')).toHaveClass('is-active')
          expect($('#myTestTabs').find('#test1')).toHaveClass('is-active')
          expect($('#myTestTabs').find('#label2')).not.toHaveClass('is-active')
          expect($('#myTestTabs').find('#test2')).not.toHaveClass('is-active')
        , 500

