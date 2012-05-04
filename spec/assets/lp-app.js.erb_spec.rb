require 'spec_helper'

describe "/assets/javascripts/lib/lp-app", :type => :view do

  before :each do
    view.view_paths << File.expand_path('app', Rails.root)
  end

  it "uses asset_path to build the path to breadcrumbs.html" do
    view.should_receive(:asset_path).with("breadcrumbs.html")
    render
  end
end
