require ['public/assets/javascripts/lib/components/gallery.js'], (Gallery) ->

  describe 'Lp Gallery', ->

      describe 'Object prototype', ->

        it 'is defined', ->
          expect(Gallery).toBeDefined()

        it 'has a version', ->
          expect(Gallery.version).toBeDefined()

        it 'has default options', ->
          expect(Gallery.options).toBeDefined()

        it 'has all the dependencies defined', ->
          expect($).toBeDefined()
          expect(Handlebars).toBeDefined()
          
        it 'has default slide template for stage section', ->
          expect(Gallery.options.stageTemplate).toBeDefined()

        it 'has default slide template for stage section', ->
          expect(Gallery.options.thumbTemplate).toBeDefined()

      describe 'Instance', ->

        beforeEach ->
          @params =
            data: [
              {src:'a.png',thumb:'a-thumb.png'},
              {src:'b.png',thumb:'b-thumb.png'}
            ]
            style: 'new-style'
          @gallery = new Gallery(@params)
          @gallery.show()
     
        afterEach ->
          @gallery.dump()
          delete @gallery

        it 'exists', ->
          expect(@gallery).toBeDefined()

        it 'merges object options with constructor arguments', ->
          expect(@gallery.args.style).toBe(@params.style)
          expect(@gallery.args.preload).toBe(3)
          expect(@gallery.args.target).toBe('body')
        
        it 'appends the lp-gallery element into target container', ->
          expect($("#{@gallery.args.target} #lp-gallery")).toExist()
      

      describe 'Toolbar', ->

        beforeEach ->
          @params =
            title: 'The Muppets Show'
          @gallery = new Gallery(@params)
          @gallery.show()
     
        afterEach ->
          @gallery.dump()
          delete @gallery

        it 'has a toolbar', ->
          expect($('div.lp-gallery-toolbar')).toExist()

        it 'has a title', ->
          expect($('div.lp-gallery-title')).toExist()
          expect($('div.lp-gallery-title').text()).toBe(@params.title)

        it 'has a close button', ->
          expect($('div.btn-soft')).toExist()

        it 'closes the gallery on close-button click', ->
          $('div.btn-soft').trigger('click')
          expect($('#lp-gallery')).not.toExist()
        
        it 'closes the gallery on esc-key press', ->
          event = $.Event("keydown")
          event.ctrlKey = false
          event.which = 27
          $('#lp-gallery').trigger(event)
          expect($('#lp-gallery')).not.toExist()

      describe 'Stage', ->
        beforeEach ->
          @params =
            data: [
              {src:'a.png', thumb:'a-thumb.png'}
              {src:'b.png', thumb:'b-thumb.png'}
              {src:'c.png', thumb:'c-thumb.png'}
              {src:'d.png', thumb:'d-thumb.png'}
              {src:'e.png', thumb:'e-thumb.png'}
              {src:'f.png', thumb:'f-thumb.png'}
            ]
            stageSlidesPerSet: -> 1
            preload: 2

          @gallery = new Gallery(@params)
          @gallery.show()
     
        afterEach ->
          @gallery.dump()
          delete @gallery

        it 'is defined and exist', ->
          expect(@gallery.stage).toBeDefined()
          expect($('div.lp-gallery-stage')).toExist()

        it 'has 6 slides', ->
          expect($('ul.lp-gallery-stage-list li').length).toBe(@params.data.length)

        it 'has one current visible slide', ->
          expect($('div.lp-gallery-stage div.lp-swipe-ctrl-ctr').width()).toBe(
            (($('ul.lp-gallery-stage-list').width()/@params.data.length)*@params.stageSlidesPerSet())
          )
          expect($('div.lp-gallery-stage li.lp-swipe-visible').length).toBe(1)

        it 'preloads assets', ->
          assets = $('ul.lp-gallery-stage-list li')
          expect(assets.find('img').length).toBe(2)
          $('ul.lp-gallery-thumbs-list li:eq(3)').trigger('click')

      describe 'Thumbs', ->
        beforeEach ->
          @params =
            data: [
              {src:'/a.png', thumb:'a-thumb.png'}
              {src:'/b.png', thumb:'b-thumb.png'}
              {src:'/c.png', thumb:'c-thumb.png'}
              {src:'/d.png', thumb:'d-thumb.png'}
              {src:'/e.png', thumb:'e-thumb.png'}
              {src:'/f.png', thumb:'f-thumb.png'}
            ]
            stageSlidesPerSet: -> 1
            thumbsSlidesPerSet: -> 3
            preload: 2

          @gallery = new Gallery(@params)
          @gallery.show()
     
        afterEach ->
          @gallery.dump()
          delete @gallery

        it 'is defined and exists', ->
          expect(@gallery.thumb).toBeDefined()
          expect($('div.lp-gallery-thumbs')).toExist()

        it 'has 6 slides', ->
          expect($('ul.lp-gallery-thumbs-list li').length).toBe(@params.data.length)

        it 'has 3 current visible slides', ->
          list_width = Number($('ul.lp-gallery-thumbs-list').get(0).style.width.split('px')[0])
          expect($('div.lp-gallery-thumbs div.lp-swipe-ctrl-ctr').width()).toBe(
            $('ul.lp-gallery-thumbs-list li:eq(0)').width()*@params.thumbsSlidesPerSet()
          )

        it 'Render thumbs', ->
          background_style = $('div.lp-gallery-image').get(0).style.backgroundImage
          expect(background_style).toMatch(@params.data[0]['thumb'])


