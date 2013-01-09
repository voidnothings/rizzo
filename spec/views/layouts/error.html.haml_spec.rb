require 'spec_helper'

describe "layouts/error" do

  it "yields the content for error_omniture" do
    tag = "omniture error"
    view.content_for(:error_omniture){tag}
    render
    rendered.should include tag
  end

end

