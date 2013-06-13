require ['public/assets/javascripts/lib/components/meta.js'], (Meta) ->

  describe 'Meta', ->
    
    data =
      copy: 
        title: "Vietnam hotels and hostels"
        description: "Some general information about accommodation in Vietnam"

    data_no_title =
      copy:
        description: "Some general information about accommodation in Vietnam"


    describe 'Object', ->
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
        meta._updateMeta(data)

      it 'updates the meta title', ->
        expect($('meta[name="title"]').attr('content')).toBe(data.copy.title)

      it 'updates the meta description', ->
        expect($('meta[name="description"]').attr('content')).toBe(data.copy.description)



    # --------------------------------------------------------------------------
    # Events API
    # --------------------------------------------------------------------------

    describe 'on cards received', ->
      beforeEach ->
        loadFixtures('meta.html')
        window.meta = new Meta()
        spyOn(meta, "_updateTitle")
        spyOn(meta, "_updateMeta")

      it 'calls _updateTitle with the title', ->
        $(meta.config.LISTENER).trigger(':cards/received', data)
        expect(meta._updateTitle).toHaveBeenCalledWith(data.copy.title)

      it 'calls _updateMeta with the data', ->
        $(meta.config.LISTENER).trigger(':cards/received', data)
        expect(meta._updateMeta).toHaveBeenCalledWith(data)

      it 'does not update the page unless there is a title returned', ->
        $(meta.config.LISTENER).trigger(':cards/received', data_no_title)
        expect(meta._updateTitle).not.toHaveBeenCalled()
        expect(meta._updateMeta).not.toHaveBeenCalled()


    describe 'on page received', ->
      beforeEach ->
        loadFixtures('meta.html')
        window.meta = new Meta()
        spyOn(meta, "_updateTitle")
        spyOn(meta, "_updateMeta")

      it 'calls _updateTitle with the title', ->
        $(meta.config.LISTENER).trigger(':cards/received', data)
        expect(meta._updateTitle).toHaveBeenCalledWith(data.copy.title)

      it 'calls _updateMeta with the data', ->
        $(meta.config.LISTENER).trigger(':cards/received', data)
        expect(meta._updateMeta).toHaveBeenCalledWith(data)

      it 'does not update the page unless there is a title returned', ->
        $(meta.config.LISTENER).trigger(':cards/received', data_no_title)
        expect(meta._updateTitle).not.toHaveBeenCalled()
        expect(meta._updateMeta).not.toHaveBeenCalled()
