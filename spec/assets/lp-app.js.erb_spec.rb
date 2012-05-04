require 'spec_helper'

describe "/assets/javascripts/lib/lp_global", :type => :view do
  pending
  # FIXME: RSpec is looking in app/views/assets/...
  # TODO: configure RSpec to treat spec/assets/** as view specs
  it "uses asset_path to build the path to breadcrumbs.html" do
    view.should_receive(:asset_path).with("breadcrumbs.html")
    render
  end
end
