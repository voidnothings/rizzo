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
      } 
    end

    it { helper.section_title(@args).should have_css('span.header__lead'), text: 'Lisbon' } 
    it { helper.section_title(@args).should_not have_css('h1.header__title', text:'Hotels') } 
    it { helper.section_title(@args).should have_css('div.header__title', text:'Hotels') } 
    it { helper.section_title(@args.merge({:is_body_title=>true})).should have_css('h1.header__title', text:'Hotels') } 

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
      helper.secondary_nav_bar(@args).should have_css('div.row--secondary span[class="place-title"]')
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

