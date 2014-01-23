(function() {

  define(["jquery"], function($) {

    var asFlyout = function(facet){

      this.$facetCount = $(facet);

      this.countFilters = function(filters){
        var count = 0, countFilter;

        countFilter = function (value) {
          if (value === true) { return count++ }
          for (var i in value) {
            countFilter(value[i])
          }
        }
        for (var property in filters) {
          countFilter(filters[property])
        }
        return count;
      };

      // Add off-click event listener for the filter dropdown
      
      this.close = $('#js-row--content').on(':toggleActive/click', function(event, active) {
        var target = event.target;
        
        $(document).one('click.toggleActive', function(event) {
          if (!$(event.target).closest('.js-filter-flyout').length) {
            $('#js-row--content').trigger(':toggleActive/update', target);
          }
        });

      });

      this.updateCount = $('#js-row--content').on(':cards/received', function(event, data, state){
        if (state && state.filters) {
          numFilters = this.countFilters();

        }
      });

      return this;

    }
    return asFlyout;

  });

}).call(this);
