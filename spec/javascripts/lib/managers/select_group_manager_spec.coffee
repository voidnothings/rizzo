require ['public/assets/javascripts/lib/managers/select_group_manager'], (SelectGroupManager) ->

  describe 'Select Group Manager', ->

    describe 'Select Group Manager object', ->
      it 'is defined', ->
        expect(SelectGroupManager).toBeDefined()

    describe 'initialization', ->
      beforeEach ->
        loadFixtures('select_group_manager.html')

      it 'picks up all elements in need of SelectGroupManager', ->
        selectGroupManager = new SelectGroupManager()
        expect(selectGroupManager.selectContainers.length).toBe(1)

    describe 'functionality', ->
      beforeEach ->
        loadFixtures('select_group_manager.html')
        new SelectGroupManager()

      it 'adds the selected class on focus', ->
        $('select').focus()
        expect($('select').hasClass('dropdown__value--selected')).toBe(true)

      it 'adds the selected class on blur', ->
        $('select').blur()
        expect($('select').hasClass('dropdown__value--selected')).toBe(true)
