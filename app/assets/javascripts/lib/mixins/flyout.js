(function() {

  define(["jquery"], function($) {

    var asFlyout = function(args) {
      _this = this,
      this.$facetCount = $(args.facet),

      this.countFilters = function(filters) {
        var count = 0,

        countFilter = function(value) {
          if (value === true) {
            return count++
          }
          for (var i in value) {
            countFilter(value[i])
          }
        }

        for (var property in filters) {
          countFilter(filters[property])
        }

        return count;
      },

      this.updateFilters = function(filters) {
        filtersApplied = _this.countFilters(filters) || ""
        if (filtersApplied) {
          filtersApplied = "(" + filtersApplied + ")";
        }
        return filtersApplied;
      },

      this.close = $('#js-row--content').on(':toggleActive/click', function(event, data) {
        var target = event.target;
        if (data.isActive) {
          $(document).on('click.toggleActive', function(event) {
            if (!$(event.target).closest('.js-filter-flyout').length) {
              $('#js-row--content').trigger(':toggleActive/update', target);
              $(document).off('click.toggleActive')
            }
          });
        } else {
          $(document).off('click.toggleActive')
        }

      });

      this.updateCount = $('#js-row--content').on(':cards/received', function(event, data, state) {
        state && state.filters &&
          _this.$facetCount.text(_this.updateFilters(state.filters))
      });

      return this;

    }

    return asFlyout;

  });

}).call(this);
