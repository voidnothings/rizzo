require ['public/assets/javascripts/lib/components/accordion.js'], (Accordion) ->

  describe 'Accordion', ->

    describe 'Setup', ->
      it 'is defined', ->
        expect(Accordion).toBeDefined()

    describe 'When only one panel is allowed to be open', ->
      beforeEach ->
        loadFixtures('accordion.html')
        window.myAccordion = new Accordion({parent: '.my-accordion'})

      it 'hides all panels', ->
        expect($('#item1')).toHaveClass('is-closed')
        expect($('#item2')).toHaveClass('is-closed')
        expect($('#item3')).toHaveClass('is-closed')
        expect($('#item4')).toHaveClass('is-closed')

      it 'opens panel 1', ->
        myAccordion.openPanel(0)
        expect($('#item1')).not.toHaveClass('is-closed')
        expect($('#item1')).toHaveClass('is-open')

      it 'closes panel 1', ->
        myAccordion.closePanel(0)
        expect($('#item1')).not.toHaveClass('is-open')
        expect($('#item1')).toHaveClass('is-closed')

      it 'closes panel 1 and opens panel 2', ->
        myAccordion.openPanel(0)
        myAccordion.openPanel(1)
        expect($('#item1')).toHaveClass('is-closed')
        expect($('#item2')).toHaveClass('is-open')

    describe 'When only one panel is allowed to be open and we pass a selector', ->
      beforeEach ->
        loadFixtures('accordion.html')
        window.myAccordion = new Accordion({parent: '.my-accordion'})

      it 'closes panel 1 and opens panel 2', ->
        myAccordion.openPanel('#item1')
        expect($('#item1')).toHaveClass('is-open')
        myAccordion.openPanel('#item2')
        expect($('#item1')).toHaveClass('is-closed')
        expect($('#item2')).toHaveClass('is-open')


    describe 'When multiple panels can be opened', ->
      beforeEach ->
        loadFixtures('accordion.html')
        window.myAccordion = new Accordion({parent: '.my-accordion', multiplePanels: true})

      it 'opens panel 1', ->
        myAccordion.openPanel(0)
        expect($('#item1')).not.toHaveClass('is-closed')
        expect($('#item1')).toHaveClass('is-open')

      it 'opens panel 2 and panel 1 remains open', ->
        myAccordion.openPanel(0)
        expect($('#item1')).toHaveClass('is-open')
        myAccordion.openPanel(1)
        expect($('#item1')).not.toHaveClass('is-closed')
        expect($('#item1')).toHaveClass('is-open')
        expect($('#item2')).not.toHaveClass('is-closed')
        expect($('#item2')).toHaveClass('is-open')

      it 'does not open panel 1 because state is blocked', ->
        myAccordion.block()
        $('#item1 .js-accordion-trigger').click()
        expect($('#item1')).not.toHaveClass('is-open')
        expect($('#item1')).toHaveClass('is-closed')

    describe 'Animated heights', ->

      describe 'When open and closed height is assumed by default', ->
        beforeEach ->
          loadFixtures('accordion.html')
          window.myAccordion = new Accordion({parent: '.my-accordion', animateHeights: true})

        it 'has a closed height', ->
          assumedClosedHeight = $('.my-accordion').find('.js-accordion-trigger').outerHeight()
          expect($('#item1').data('closed')).toEqual(assumedClosedHeight)

        it 'has an open height', ->
          assumedOpenHeight = $('.my-accordion').find('.js-accordion-trigger').outerHeight()
          expect($('#item1').data('open')).toEqual(assumedOpenHeight)

      describe 'When open and closed height is specified', ->
        beforeEach ->
          loadFixtures('accordion.html')
          window.myAccordion = new Accordion({parent: '.my-accordion', animateHeights: true, openHeight: 250, height: 50})

        it 'has an explicit closed height', ->
          expect($('#item1').data('closed')).toEqual(50)

        it 'has an explicit open height', ->
          expect($('#item1').data('open')).toEqual(250)



