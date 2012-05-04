require 'spec_helper'

describe "layouts/partials/_core_scripts" do
  it "builds path to application.js using asset_path" do
    view.should_receive(:javascript_path).with("application.js")
    render
  end
end
