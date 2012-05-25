require 'spec_helper'

describe "layouts/partials/_core_scripts" do

  it "builds path to rizzo.js and the google js_api using asset_path" do
    view.should_receive(:javascript_path).once.with("rizzo.js")
    render
  end

end
