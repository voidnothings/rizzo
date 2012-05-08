require 'spec_helper'

describe "layouts/partials/_core_scripts" do
  it "builds path to rizzo.js using asset_path" do
    view.should_receive(:javascript_path).with("rizzo.js")
    render
  end
end
