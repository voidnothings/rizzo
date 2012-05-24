require 'spec_helper'

describe "layouts/partials/_core_scripts" do
  
  it "builds path to rizzo.js and the google js_api using asset_path" do
    view.should_receive(:javascript_path).once.with("rizzo.js")
    view.should_receive(:javascript_path).once.with("http://www.google.com/jsapi?key=ABQIAAAADUr8Vd6I7bfZ5k4c27F7KxR5cxXriAJsP5a75Cx4cnHTXGWMNxQxhFddQkNg7EBCllU86qgA_ugglg")
    render
  end
  
end
