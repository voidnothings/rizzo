require([ "jquery", "public/assets/javascripts/lib/extends/pushstate.js" ], function($, Pushstate) {

  "use strict";

  var pushstate, serialized, newParams, deserialized,
      listener = $("#js-card-holder");

  serialized = {
    url: "http://www.lonelyplanet.com/france/paris/hotels",
    urlWithSearchAndFilters: "http://www.lonelyplanet.com/england/london/hotels?utf8=✓&search%5Bpage_offsets%5D=0%2C58&search%5Bfrom%5D=29+May+2013&search%5Bto%5D=30+May+2013&search%5Bguests%5D=2&search%5Bcurrency%5D=USD&filters%5Bproperty_type%5D%5B3star%5D=true&filters%5Blp_reviewed%5D=true",
    urlParams: "utf8=✓&search%5Bfrom%5D=29+May+2013&search%5Bto%5D=30+May+2013&search%5Bguests%5D=2&search%5Bcurrency%5D=USD&filters%5Bproperty_type%5D%5B3star%5D=true&filters%5Blp_reviewed%5D=true",
    newUrlWithSearchAndFilters: "filters%5Bproperty_type%5D%5B4star%5D=true"
  };

  deserialized = {
    utf8: "✓",
    search: {
      from: "29 May 2013",
      to: "30 May 2013",
      guests: "2",
      currency: "USD"
    },
    filters: {
      property_type: {
        "3star": "true"
      },
      lp_reviewed: "true"
    }
  };

  newParams = {
    filters: {
      property_type: {
        "4star": true
      }
    },
    pagination: {
      page_offsets: 2
    }
  };

  describe("Pushstate", function() {
    beforeEach(function() {
      pushstate = new Pushstate();
    });

    describe("initialisation without support for history.pushState", function() {
      beforeEach(function() {
        window.pushstate = new Pushstate();
        spyOn(pushstate, "_supportsHistory").andReturn(false);
        spyOn(pushstate, "_onHashChange");
        return pushstate.init();
      });
      return it("calls _onHashChange", function() {
        $(window).trigger("hashchange");
        return expect(pushstate._onHashChange).toHaveBeenCalled();
      });
    });

    describe("creating the url", function() {
      beforeEach(function() {
        window.pushstate = new Pushstate();
        spyOn(pushstate, "getParams").andReturn(serialized.newUrlWithSearchAndFilters);
        spyOn(pushstate, "getDocumentRoot").andReturn("/");
      });

      describe("with pushState support", function() {
        it("serializes the application state with the document root", function() {
          var newUrl;
          newUrl = pushstate._createUrl(serialized.newUrlWithSearchAndFilters);
          return expect(newUrl).toBe("/?" + serialized.newUrlWithSearchAndFilters);
        });
        return it("serializes the application state with the *new* document root", function() {
          var newUrl;
          newUrl = pushstate._createUrl(serialized.newUrlWithSearchAndFilters, "/reviewed");
          return expect(newUrl).toBe("/reviewed?" + serialized.newUrlWithSearchAndFilters);
        });
      });

      return describe("without pushState support", function() {
        beforeEach(function() {
          return spyOn(pushstate, "_supportsHistory").andReturn(false);
        });
        it("creates a hashbang url with the document root", function() {
          var newUrl;
          newUrl = pushstate._createUrl(serialized.newUrlWithSearchAndFilters);
          return expect(newUrl).toBe("#!/" + "?" + serialized.newUrlWithSearchAndFilters);
        });
        return it("creates a hashbang url with the *new* document root", function() {
          var newUrl;
          newUrl = pushstate._createUrl(serialized.newUrlWithSearchAndFilters, "/reviewed");
          return expect(newUrl).toBe("#!/reviewed" + "?" + serialized.newUrlWithSearchAndFilters);
        });
      });
    });

    describe("creating the request url", function() {
      beforeEach(function() {
        window.pushstate = new Pushstate();
        return spyOn(pushstate, "getDocumentRoot").andReturn("/foo");
      });
      it("serializes the application state with the document root", function() {
        var newUrl;
        newUrl = pushstate.createRequestUrl(serialized.newUrlWithSearchAndFilters);
        return expect(newUrl).toBe("/foo?" + serialized.newUrlWithSearchAndFilters);
      });
      return it("serializes the application state with the *new* document root and appends .json", function() {
        var newUrl;
        newUrl = pushstate.createRequestUrl(serialized.newUrlWithSearchAndFilters, "/bar");
        return expect(newUrl).toBe("/bar?" + serialized.newUrlWithSearchAndFilters);
      });
    });

    describe("updating push state", function() {
      beforeEach(function() {
        spyOn(history, "pushState");
        window.pushstate = new Pushstate();
        return pushstate.navigate("", "/test");
      });
      it("history.pushState is called", function() {
        return expect(history.pushState).toHaveBeenCalledWith({}, null, "/test");
      });
    });

    describe("updating hash bang", function() {
      beforeEach(function() {
        window.pushstate = new Pushstate();
        spyOn(pushstate, "_supportsHistory").andReturn(false);
        spyOn(pushstate, "_supportsHash").andReturn(true);
        spyOn(pushstate, "setHash");
        return pushstate.navigate("", "/test");
      });
      afterEach(function() {
        window.location.hash = "";
      });
      return it("the hash is appended to the url", function() {
        return expect(pushstate.setHash).toHaveBeenCalledWith("#!/test");
      });
    });

    describe("when we dont support pushState", function() {
      beforeEach(function() {
        window.pushstate = new Pushstate();
        return spyOn(pushstate, "_supportsHistory").andReturn(false);
      });
      describe("when we have a hash", function() {
        beforeEach(function() {
          spyOn(pushstate, "getHash").andReturn("#!/testing");
          return spyOn(pushstate, "setUrl");
        });
        describe("and history navigation is enabled", function() {
          beforeEach(function() {
            pushstate.allowHistoryNav = true;
            return pushstate._onHashChange();
          });
          return it("replaces the url with the stored hash url", function() {
            return expect(pushstate.setUrl).toHaveBeenCalledWith("/testing");
          });
        });
        return describe("and history navigation is disabled", function() {
          beforeEach(function() {
            pushstate.allowHistoryNav = false;
            return pushstate._onHashChange();
          });
          return it("does not update the url", function() {
            expect(pushstate.getHash).not.toHaveBeenCalled();
            return expect(pushstate.setUrl).not.toHaveBeenCalled();
          });
        });
      });
      return describe("when we dont have a hash and history navigation is enabled", function() {
        beforeEach(function() {
          spyOn(pushstate, "getHash").andReturn("");
          spyOn(pushstate, "getUrl").andReturn("www.lonelyplanet.com/testing");
          spyOn(pushstate, "setUrl");
          pushstate.allowHistoryNav = true;
          return pushstate._onHashChange();
        });
        return it("replaces the url with the current url", function() {
          return expect(pushstate.setUrl).toHaveBeenCalledWith("www.lonelyplanet.com/testing");
        });
      });
    });

    // --------------------------------------------------------------------------
    // Back / Forward
    // --------------------------------------------------------------------------

    describe("returning to the first page", function() {
      beforeEach(function() {
        window.pushstate = new Pushstate();
        spyOn(pushstate, "getUrl").andReturn("http://www.lonelyplanet.com/england/london");
        spyOn(pushstate, "setUrl");
        pushstate.popStateFired = true;
        pushstate.currentUrl = "http://www.lonelyplanet.com/england/london";
        pushstate._handlePopState();
      });
      it("refreshes the page", function() {
        expect(pushstate.setUrl).toHaveBeenCalled();
      });
    });

  });

});
