require ['public/assets/javascripts/lib/mixins/page_state.js'], (asPageState) ->

  describe 'asPageState', ->

    asPageState = new asPageState()

    describe 'Object', ->
      it 'is defined', ->
        expect(asPageState).toBeDefined()

    describe 'Has Filtered', ->

      describe 'by subpath', ->
        beforeEach ->
          spyOn(asPageState, "withinFilterUrl").andReturn(true)

        it 'returns true for hasFiltered', ->
          expect(asPageState.hasFiltered()).toBe(true)

      describe 'by querystring', ->
        beforeEach ->
          spyOn(asPageState, "withinFilterUrl").andReturn(false)
          spyOn(asPageState, "getParams").andReturn("/england/london/hotels?filters=foo")

        it 'returns true for hasFiltered', ->
          expect(asPageState.hasFiltered()).toBe(true)

    describe 'Has not Filtered', ->

      describe 'by subpath', ->
        beforeEach ->
          spyOn(asPageState, "withinFilterUrl").andReturn(false)

        it 'returns true for hasFiltered', ->
          expect(asPageState.hasFiltered()).toBe(false)

      describe 'by querystring', ->
        beforeEach ->
          spyOn(asPageState, "withinFilterUrl").andReturn(false)
          spyOn(asPageState, "getParams").andReturn("/england/london/hotels?search=foo")

        it 'returns true for hasFiltered', ->
          expect(asPageState.hasFiltered()).toBe(false)


    describe 'Has Searched', ->

      describe 'by querystring', ->
        beforeEach ->
          spyOn(asPageState, "getParams").andReturn("/england/london/hotels?search=foo")

        it 'returns true for hasSearched', ->
          expect(asPageState.hasSearched()).toBe(true)

      describe 'by querystring', ->
        beforeEach ->
          spyOn(asPageState, "getParams").andReturn("/england/london/hotels?filters=foo")

        it 'returns true for hasSearched', ->
          expect(asPageState.hasSearched()).toBe(false)


    describe 'Get Document Root', ->

      describe 'within a subcategory url', ->
        beforeEach ->
          spyOn(asPageState, "withinFilterUrl").andReturn(true)

        it 'in hotels', ->
          expect(asPageState.createDocumentRoot("/england/london/hotels/rated")).toBe("/england/london/hotels")
          expect(asPageState.createDocumentRoot("/england/london/hotels/apartments")).toBe("/england/london/hotels")
          expect(asPageState.createDocumentRoot("/england/london/hotels/5-star")).toBe("/england/london/hotels")

        it 'in things to do', ->
          expect(asPageState.createDocumentRoot("/england/london/things-to-do/snowboarding")).toBe("/england/london/things-to-do")

      describe 'without a subcategory url', ->
        beforeEach ->
          spyOn(asPageState, "withinFilterUrl").andReturn(false)

        it 'in hotels', ->
          expect(asPageState.createDocumentRoot("/england/london/hotels/")).toBe("/england/london/hotels/")

        it 'in things to do', ->
          expect(asPageState.createDocumentRoot("/england/london/things-to-do/")).toBe("/england/london/things-to-do/")
