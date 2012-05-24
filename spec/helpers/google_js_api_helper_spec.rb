require 'spec_helper'

describe GoogleJsApiHelper do
  
  it "should return a uri to the goole js_api with the key set" do
    helper.js_api_script.should eq "http://www.google.com/jsapi?key=ABQIAAAADUr8Vd6I7bfZ5k4c27F7KxR5cxXriAJsP5a75Cx4cnHTXGWMNxQxhFddQkNg7EBCllU86qgA_ugglg"
  end
  
  it "should allow you to set a different js_api key" do
    helper.js_api_script('wombats!').should eq "http://www.google.com/jsapi?key=wombats!"
  end
  
end