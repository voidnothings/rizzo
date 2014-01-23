require(['jquery', 'public/assets/javascripts/lib/mixins/flyout.js'], function($, asFlyout) {

    describe('Flyout Mixin', function() {

        beforeEach(function() {
            window.flyout = asFlyout.call({})
        });

        describe('Object', function() {
            it('is defined', function() {
                expect(flyout).toBeDefined();
            });
        });

        describe('counts', function() {
            it('regular filters', function() {
                count = flyout.countFilters({
                    foo: true,
                    bar: true
                })
                expect(count).toBe(2)
            }),
            it('deep filters', function() {
                count = flyout.countFilters({
                    foo: true,
                    bar: {
                        x: true,
                        y: true
                    }
                })
                expect(count).toBe(3)
            })
        });

        describe('updates the facet count', function() {

            it('when there are no filters', function() {
                beforeEach(function() {
                    spyOn(flyout, "countFilters").andReturn(0);
                })
                expect(flyout.updateFilters(filters)).toBe("")
            }),
            it('when there are no filters', function() {
                beforeEach(function() {
                    spyOn(flyout, "countFilters").andReturn(2);
                })
                expect(flyout.updateFilters(filters)).toBe("(2)")
            })

        })

    });
});
