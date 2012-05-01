require 'spec_helper'
require 'global_resources_helper'

describe GlobalResourcesHelper do
  before do
    class << helper
      include Haml, Haml::Helpers
    end
    helper.init_haml_helpers
  end

  it "should get a list of navigation items" do
    helper.primary_navigation_items.map{|n|n[:title]}.should ==
      ['Home','Destinations','Thorn Tree forum','Shop','Hotels','Flights','Insurance']
  end

  it "should render the cart tab item" do
    helper.cart_item_element.should have_css('li[class="globalCartHead"]')
  end

  it "should render the membership tab" do
    helper.membership_item_element.should have_css('li[class="signInRegister cartDivider"]')
  end

  it "should render a white angle button" do
    arr = helper.arrow_button(color: 'white', title: 'Details and Booking')
    arr.should have_css('div[class="whiteAngleButton"]')
    arr.should have_css('a[class="lpButton2010"]', text: 'Details and Booking')
  end

end