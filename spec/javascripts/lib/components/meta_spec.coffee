require ['public/assets/javascripts/lib/components/meta.js'], (Meta) ->

  describe 'Meta', ->
    
    data = 
      title: "Vietnam hotels and hostels"
      description: "Some general information about accommodation in Vietnam"
      stack_description: "Some general stack based information about accommodation in Vietnam"

    data_no_description = 
      title: "Vietnam hotels and hostels"
      description: "Some general information about accommodation in Vietnam"


    describe 'Setup', ->
      it 'is defined', ->
        expect(Meta).toBeDefined()

      it 'has default options', ->
        expect(Meta::config).toBeDefined()


    describe 'on page received', ->
      beforeEach ->
        loadFixtures('meta.html')
        window.meta = new Meta()
      
      describe 'when there is a stack description', ->
        beforeEach ->
          $(meta.config.LISTENER).trigger(':page/received', data)

        it 'updates the meta title', ->
          expect($('meta[name="title"]').attr('content')).toBe(data.title)

        it 'updates the meta description', ->
          expect($('meta[name="description"]').attr('content')).toBe(data.description)

        it 'updates the stack title', ->
          expect($('.js-intro-title').text()).toBe(data.title)

        it 'updates the stack description', ->
          expect($('.js-intro-lead').text()).toBe(data.stack_description)


      describe 'when there is no stack description', ->
        beforeEach ->
          $(meta.config.LISTENER).trigger(':page/received', data_no_description)

        it 'updates the meta title', ->
          expect($('meta[name="title"]').attr('content')).toBe(data.title)

        it 'updates the meta description', ->
          expect($('meta[name="description"]').attr('content')).toBe(data.description)

        it 'does not update the stack description', ->
          expect($('.js-intro-lead').text()).toBe("")