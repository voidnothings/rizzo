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

  context "section_title (legacy layout)" do

    before do
      class << helper
        include Haml, Haml::Helpers
      end
      helper.init_haml_helpers
      @args = {
        title: 'Lisbon',
        section_name: 'Hotels',
        page_name: 'foo-body-heading',
      } 
    end
    
    it { helper.section_title(@args).should have_css('div.header__lead', text:'Lisbon') } 
    it { helper.section_title(@args).should have_css('div.header__title'), text: 'Hotels' } 
    it { helper.section_title(@args).should have_css('h1.accessibility.js-page-header', text: 'foo-body-heading') } 

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
        page_name: 'foo-body-heading',
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
      helper.secondary_nav_bar(@args).should have_css('div.row__title--secondary', text:'Lisbon')
    end

    it "renders a list of navigation anchors" do 
      helper.secondary_nav_bar(@args).should have_css("a[href='\/a']", text: 'a')
    end

    it "sets the current section" do 
      helper.secondary_nav_bar(@args).should have_css("a[class='current js-nav-item nav__item--secondary']", text: 'b')
      helper.secondary_nav_bar(@args).should_not have_css("a[class='current js-nav-item nav__item--secondary']", text: 'c')
    end
    
    it 'sets the body heading' do
      helper.secondary_nav_bar(@args).should have_css('h1.accessibility', text:'foo-body-heading')
    end

  end


end

