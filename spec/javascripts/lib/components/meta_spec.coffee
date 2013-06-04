require ['public/assets/javascripts/lib/components/meta.js'], (Meta) ->

  describe 'Meta', ->
    
    data = 
      title: "Vietnam hotels and hostels"
      description: "Some general information about accommodation in Vietnam"
      stack_description: "Some general stack based information about accommodation in Vietnam"

    data_no_description = 
      title: "Vietnam hotels and hostels"
      description: "Some general information about accommodation in Vietnam"

    data_no_title =
      description: "Some general information about accommodation in Vietnam"


    describe 'Setup', ->
      it 'is defined', ->
        expect(Meta).toBeDefined()

      it 'has default options', ->
        expect(Meta::config).toBeDefined()



    # --------------------------------------------------------------------------
    # Private Methods
    # --------------------------------------------------------------------------

    describe 'updating the title', ->
      beforeEach ->
        window.meta = new Meta()
        meta._updateTitle("foo")

      it 'updates the document title', ->
        expect(document.title).toBe("foo")


    describe 'updating the meta tags', ->
      beforeEach ->
        loadFixtures('meta.html')
        window.meta = new Meta()
        meta._updateMeta(data_no_description)

      it 'updates the meta title', ->
        expect($('meta[name="title"]').attr('content')).toBe(data_no_description.title)

      it 'updates the meta description', ->
        expect($('meta[name="description"]').attr('content')).toBe(data_no_description.description)


    describe 'updating the view', ->
      beforeEach ->
        loadFixtures('meta.html')
        window.meta = new Meta()

      describe 'when there is a stack description', ->
        beforeEach ->
          meta._updateView(data)

        it 'updates the stack title', ->
          expect($('.js-intro-title').text()).toBe(data.title)

        it 'updates the stack description', ->
          expect($('.js-intro-lead').text()).toBe(data.stack_description)

      describe 'when there is no stack description', ->
        beforeEach ->
          meta._updateView(data_no_description)

        it 'updates the stack title', ->
          expect($('.js-intro-title').text()).toBe(data.title)

        it 'does not update the stack description', ->
          expect($('.js-intro-lead').text()).toBe("")



    describe 'on page received', ->
      beforeEach ->
        loadFixtures('meta.html')
        window.meta = new Meta()
        spyOn(meta, "_updateTitle")
        spyOn(meta, "_updateMeta")
        spyOn(meta, "_updateView")

      it 'calls _updateTitle with the title', ->
        $(meta.config.LISTENER).trigger(':page/received', data)
        expect(meta._updateTitle).toHaveBeenCalledWith(data.title)

      it 'calls _updateMeta with the data', ->
        $(meta.config.LISTENER).trigger(':page/received', data)
        expect(meta._updateMeta).toHaveBeenCalledWith(data)

      it 'calls _updateView with the data', ->
        $(meta.config.LISTENER).trigger(':page/received', data)
        expect(meta._updateView).toHaveBeenCalledWith(data)

      it 'does not update the page unless there is a title returned', ->
        $(meta.config.LISTENER).trigger(':page/received', data_no_title)
        expect(meta._updateTitle).not.toHaveBeenCalled()
        expect(meta._updateMeta).not.toHaveBeenCalled()
        expect(meta._updateView).not.toHaveBeenCalled()