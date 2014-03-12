require ['jquery'], ($) ->
  require [
    'lib/managers/select_group_manager'
    'lib/utils/scroll_perf'
    'lib/utils/toggle_active'
    'lib/components/range_slider'
    'lib/components/lightbox'
    'pickadate/lib/picker'
    'pickadate/lib/picker.date'
    'pickadate/lib/legacy'
    'lib/styleguide/ajax-content'
    'lib/styleguide/copy'
    'lib/styleguide/snippet-expand'
    'lib/styleguide/svg'
    'lib/styleguide/colours'
    'lib/styleguide/typography'
    'lib/styleguide/lightbox'
    'lib/utils/feature_detect'
  ], (SelectGroupManager, ScrollPerf, ToggleActive) ->

    new ScrollPerf
    new SelectGroupManager()
    new ToggleActive()
    d = new Date()
    $('.input--datepicker').pickadate({
      min: [d.getFullYear(), (d.getMonth() + 1), d.getDate()]
    })
