require ['public/assets/javascripts/lib/components/section_toggle.js'], (SectionToggle) ->

  describe 'Section Toggle', ->

    describe 'Object', ->
      it 'is defined', ->
        expect(SectionToggle).toBeDefined()

    describe 'Initialising', ->
      beforeEach ->
        loadFixtures('section_toggle.html')
        spyOn(SectionToggle.prototype, "init")

      it 'has default options', ->
        window.SectionToggle = new SectionToggle()
        expect(window.SectionToggle).toBeDefined()

      it 'initialises when the parent element exists', ->
        window.SectionToggle = new SectionToggle()
        expect(window.SectionToggle.init).toHaveBeenCalled()

      it 'does not initialise if the parent element does not exist', ->
        window.SectionToggle = new SectionToggle({selector: '.my-missing-section'})
        expect(window.SectionToggle.init).not.toHaveBeenCalled()


    describe 'When the total height of the area is smaller than the max height', ->
      beforeEach ->
        loadFixtures('section_toggle.html')
        spyOn(SectionToggle.prototype, "getFullHeight").andReturn(50)
        spyOn(SectionToggle.prototype, "addHandler")
        spyOn(SectionToggle.prototype, "setWrapperState")

      it 'keeps the toggle area open and does not have a toggle button', ->
        window.SectionToggle = new SectionToggle({maxHeight: 100})
        expect(window.SectionToggle.addHandler).not.toHaveBeenCalled()
        expect(window.SectionToggle.setWrapperState).not.toHaveBeenCalled()
        expect(window.SectionToggle.$el).toHaveClass('is-open')


    describe 'When the total height of the area is larger than the max height', ->
      beforeEach ->
        loadFixtures('section_toggle.html')
        spyOn(SectionToggle.prototype, "getFullHeight").andReturn(150)

      it 'closes toggle area and adds a block-style toggle button', ->
        window.SectionToggle = new SectionToggle({maxHeight: 100})
        expect(window.SectionToggle.$el).toHaveClass('is-closed')
        expect(window.SectionToggle.$el.find('.btn--read-more').length).toBe(1)
        expect(window.SectionToggle.wrapper).toHaveClass('read-more-block')
        expect(window.SectionToggle.wrapper.css('maxHeight')).toEqual('100px')

      it 'closes toggle area and adds an inline-style toggle button', ->
        window.SectionToggle = new SectionToggle({maxHeight: 100, style: 'inline'})
        expect(window.SectionToggle.$el).toHaveClass('is-closed')
        expect(window.SectionToggle.$el.find('.btn--read-more').length).toBe(1)
        expect(window.SectionToggle.wrapper).toHaveClass('read-more-inline')
        expect(window.SectionToggle.wrapper.css('maxHeight')).toEqual('100px')


    describe 'When the Read More button is clicked', ->
      beforeEach ->
        loadFixtures('section_toggle.html')
        spyOn(SectionToggle.prototype, "getFullHeight").andReturn(150)
        window.SectionToggle = new SectionToggle({maxHeight: 100})
        window.SectionToggle.click()

      it 'opens the toggle area when the toggle button is clicked', ->
        expect(window.SectionToggle.$el).toHaveClass('is-open')
        # expect(window.SectionToggle.$el.find('.btn--read-more').length).toBe(1)
        # expect(window.SectionToggle.wrapper).toHaveClass('read-more-block')
        # expect(window.SectionToggle.wrapper.css('maxHeight')).toEqual('150px')

