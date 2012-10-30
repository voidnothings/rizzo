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
        expect($('#panel1')).toHaveClass('is-hidden')
        expect($('#panel2')).toHaveClass('is-hidden')
        expect($('#panel3')).toHaveClass('is-hidden')
        expect($('#panel4')).toHaveClass('is-hidden')
      
      it 'opens panel 1', ->
        myAccordion.openPanel(0)
        expect($('#panel1')).not.toHaveClass('is-hidden')

      it 'closes panel 1', ->
        myAccordion.closePanel(0)
        expect($('#panel1')).toHaveClass('is-hidden')

      it 'closes panel 1 and opens panel 2', ->
        myAccordion.openPanel(0)
        myAccordion.openPanel(1)
        expect($('#panel1')).toHaveClass('is-hidden')
        expect($('#panel2')).not.toHaveClass('is-hidden')
    
    describe 'When only one panel is allowed to be open and we pass a selector', ->
      beforeEach ->
        loadFixtures('accordion.html')
        window.myAccordion = new Accordion({parent: '.my-accordion'})

      it 'closes panel 1 and opens panel 2', ->
        myAccordion.openPanel('#panel1')
        expect($('#panel1')).not.toHaveClass('is-hidden')
        myAccordion.openPanel('#panel2')
        expect($('#panel1')).toHaveClass('is-hidden')
        expect($('#panel2')).not.toHaveClass('is-hidden')

    describe 'When multiple panels can be opened', ->
      beforeEach ->
        loadFixtures('accordion.html')
        window.myAccordion = new Accordion({parent: '.my-accordion', multiplePanels: true})

      it 'opens panel 1', ->
        myAccordion.openPanel(0)
        expect($('#panel1')).not.toHaveClass('is-hidden')

      it 'opens panel 2 and panel 1 remains open', ->
        myAccordion.openPanel(0)
        expect($('#panel1')).not.toHaveClass('is-hidden')
        myAccordion.openPanel(1)
        expect($('#panel1')).not.toHaveClass('is-hidden')
        expect($('#panel2')).not.toHaveClass('is-hidden')

    describe 'It adds the active class to the correct element', ->
      beforeEach ->
        loadFixtures('accordion.html')
        args = 
          parent: '.my-accordion'
          multiplePanels: false
          activeClass: 
            elem: '.js-accordion-item'
            className: 'banana'
        window.myAccordion = new Accordion(args)

      it 'adds the active class to item with id', ->
        myAccordion.openPanel('#panel1')
        expect($('#item1')).toHaveClass('banana')
      
      it 'adds the active class to item 1', ->
        myAccordion.openPanel(2)
        expect($('#item3')).toHaveClass('banana')
        
    describe 'It adds the active class to each open element', ->
      beforeEach ->
        loadFixtures('accordion.html')
        args = 
          parent: '.my-accordion'
          multiplePanels: true
          activeClass: 
            elem: '.js-accordion-item'
            className: 'banana'
        window.myAccordion = new Accordion(args)

      it 'adds the active class to item with id', ->
        myAccordion.openPanel('#panel1')
        myAccordion.openPanel(1)
        myAccordion.openPanel(2)
        expect($('#item1')).toHaveClass('banana')
        expect($('#item2')).toHaveClass('banana')
        expect($('#item3')).toHaveClass('banana')












