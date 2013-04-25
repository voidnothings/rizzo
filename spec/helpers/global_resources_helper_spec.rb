require 'spec_helper'
require 'global_resources_helper'

describe GlobalResourcesHelper do

  context "legacy global resources" do 

    before do
      class << helper
        include Haml, Haml::Helpers
      end
      helper.init_haml_helpers
    end

    it "gets a list of navigation items" do
      helper.primary_navigation_items.map{|n|n[:title]}.should ==
        ['Home','Destinations','Themes','Thorn Tree forum','Shop','Hotels','Flights','Insurance']
    end

    it "renders the cart tab item" do
      helper.cart_item_element.should have_css('a.nav__item--cart.js-user-cart')
    end

    it "renders the membership tab" do
      helper.membership_item_element.should have_css('div.nav__item--user.js-user--nav')
    end

  end

  context "place_heading at city level" do

    before do
      class << helper
        include Haml, Haml::Helpers
      end
      helper.init_haml_helpers
      @args = {
        title: 'Lisbon',
        section_name: 'Hotels',
        slug: '/lisbon/',
        parent: 'portugal',
        parent_slug: '/portugal/'
      }
    end
    it { helper.place_heading(@args[:title], @args[:section_name], @args[:slug], @args[:parent], @args[:parent_slug]).should have_css('a.place-title-heading'), text: @args[:title] } 
    it { helper.place_heading(@args[:title], @args[:section_name], @args[:slug], @args[:parent], @args[:parent_slug]).should have_css('span.accessibility'), text: @args[:section_name] } 
    it { helper.place_heading(@args[:title], @args[:section_name], @args[:slug], @args[:parent], @args[:parent_slug]).should have_css('a.place-title__parent'), text: @args[:parent], href: @args[:parent_slug] }      

  end

  context "place_heading at country level" do

    before do
      class << helper
        include Haml, Haml::Helpers
      end
      helper.init_haml_helpers
      @args = {
        title: 'Lisbon',
        section_name: 'Hotels',
        slug: '/lisbon/'
      }
    end
    it { helper.place_heading(@args[:title], @args[:section_name], @args[:slug], @args[:parent], @args[:parent_slug]).should have_css('a.place-title-heading'), text: @args[:title] } 
    it { helper.place_heading(@args[:title], @args[:section_name], @args[:slug], @args[:parent], @args[:parent_slug]).should have_css('span.accessibility'), text: @args[:section_name] } 
    it { helper.place_heading(@args[:title], @args[:section_name], @args[:slug], @args[:parent], @args[:parent_slug]).should_not have_css('a.place-title__parent'), text: @args[:parent], href: @args[:parent_slug] }      

  end


  context "secondary-nav-bar" do

    before do
      class << helper
        include Haml, Haml::Helpers
      end
      helper.init_haml_helpers
      @args = {
        title: 'Lisbon',
        section_name: 'b',
        slug: '/lisbon/',
        collection: [
          {title: 'a', url:'/a'},
          {title: 'b', url:'/b'},
          {title: 'c', url:'/c'},
          {title: 'd', url:'/d'}
      ]
      } 
    end

    it 'renders the secondary bar' do
      helper.secondary_nav_bar(@args).should have_css('div.row--secondary')
    end

    it "renders the secondary navigation" do
      helper.secondary_nav_bar(@args).should have_css('div.nav--secondary')
    end

    it "renders a title section on the secondary nav-bar" do 
      helper.secondary_nav_bar(@args).should have_css('div.row--secondary div.place-title')
    end
    
    it "renders an accessibility section name tag whithin body title" do 
      helper.secondary_nav_bar(@args).should have_css('.place-title span.accessibility', text:'b')
    end

    it "renders a list of navigation anchors" do 
      helper.secondary_nav_bar(@args).should have_css("a[href='\/a']", text: 'a')
    end

    it "sets the current section" do 
      helper.secondary_nav_bar(@args).should have_css("a[class='current js-nav-item nav__item nav__item--secondary']", text: 'b')
      helper.secondary_nav_bar(@args).should_not have_css("a[class='current js-nav-item nav__item nav__item--secondary']", text: 'c')
    end

  end  

end

